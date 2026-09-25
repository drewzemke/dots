status is-interactive; or return

abbr -a jA 'jj absorb'
abbr -a jab 'jj abandon'
abbr -a jb 'jj bookmark'
abbr -a jc 'jj commit'
abbr -a jd 'jj describe'
abbr -a jdi 'jj diff'
abbr -a je 'jj edit'
abbr -a jev 'jj evolve'
abbr -a jf 'jj fetch'
abbr -a ji 'jj inc'
abbr -a jl 'jj log'
abbr -a jn 'jj new'
abbr -a jnt 'jj new "trunk()"'
abbr -a jo 'jj out'
abbr -a jp 'jj prep'
abbr -a jP 'jj push'
abbr -a jpp 'jj prep; and jj push'
abbr -a jr 'jj rebase'
abbr -a jrs 'jj restore'
abbr -a js 'jj status'
abbr -a jsh 'jj show'
abbr -a jsp 'jj split'
abbr -a jS 'jj squash'
abbr -a ju 'jj undo'
abbr -a J 'jjui'

set -l jj_log_preview 'jj log --color=always -r "ancestors({1},4)"'

function __fzf_jj_bookmark -V jj_log_preview
    jj bookmark list -T 'name ++ "\n"' | __fzf_insert --preview $jj_log_preview
end

function __fzf_jj_bookmark_all -V jj_log_preview
    jj bookmark list --all-remotes -T 'if(self.remote() != "git", self.name() ++ if(self.remote(), "@" ++ self.remote()) ++ "\n")' \
        | __fzf_insert --preview $jj_log_preview
end

function __fzf_jj_commit -V jj_log_preview
    jj log --no-graph -r 'all()' -T 'change_id.shortest() ++ " " ++ description.first_line() ++ "\n"' \
        | __fzf_insert --preview $jj_log_preview --accept-nth 1
end

bind alt-j __fzf_jj_bookmark
bind alt-J __fzf_jj_bookmark_all
bind ctrl-J __fzf_jj_commit
