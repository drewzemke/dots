#!/bin/sh
# usage: collab.sh <file>
#
# opens <file> in helix in a floating zellij pane and blocks until the user is
# done with it. prints one word on stdout describing how the pane went away:
#
#   saved   helix exited on its own (:wq, :q, :q!, etc.)
#   killed  the pane was closed from zellij (e.g. ctrl-p x), killing helix
#
# either way, whatever was last written to <file> is the result. this script
# never inspects the file's contents; that's the caller's job.
#
# why not `zellij action new-pane --blocking`? as of zellij 0.45.1, --blocking
# returns when *any* pane closes, not just the one it opened. closing an
# unrelated floating pane made claude think the user was done editing.
#
# instead, done-ness is detected two ways, polled once a second:
#
#   1. a marker file (<file>.done). the pane runs `hx <file>; touch <marker>`,
#      so the marker only appears after helix exits normally.
#   2. pane liveness. if the pane is closed from zellij, the whole pane process
#      tree is killed, so `touch` never runs and (1) would wait forever. so we
#      also stop once the pane's id disappears from `zellij action list-panes`.

set -eu

file=$1
marker=$file.done
dir=/tmp/claude-collab

# helix treats a dir containing .helix/ as the workspace root. the local
# languages.toml turns off the markdown lsp (markdown-oxide), which otherwise
# shows a "missing root" warning every time a .md file opens outside a vault.
# recreated every run since /tmp gets wiped on reboot.
mkdir -p "$dir/.helix"
printf '[[language]]\nname = "markdown"\nlanguage-servers = []\n' > "$dir/.helix/languages.toml"

# a leftover marker from an earlier run with the same filename would make us
# return immediately
rm -f "$marker"

# new-pane prints the new pane's id as "terminal_<n>"; list-panes reports the
# bare number. "$1"/"$2" inside sh -c keeps paths with spaces intact
pane=$(zellij action new-pane --floating --close-on-exit --name collab --cwd "$dir" \
  -- sh -c 'hx "$1"; touch "$2"' sh "$file" "$marker")
pane_id=${pane#terminal_}

# plugin panes have their own id space, so a plugin could share our number
pane_alive() {
  zellij action list-panes --json |
    jq -e --argjson id "$pane_id" '.[] | select(.id == $id and (.is_plugin | not))' >/dev/null
}

until [ -e "$marker" ] || ! pane_alive; do
  sleep 1
done

# check the marker first: on a normal exit, touch runs before the pane closes,
# so the marker can exist even when the pane is already gone
if [ -e "$marker" ]; then
  rm -f "$marker"
  echo saved
else
  echo killed
fi
