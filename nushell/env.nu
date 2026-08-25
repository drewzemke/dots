# zoxide setup
if not ('~/.zoxide.nu' | path exists) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin setup: autoload/atuin.nu sources ~/.local/share/atuin/init.nu, which
# atuin generates at install time. it goes stale after a nushell upgrade since
# it targets the old nu syntax. regenerate + patch with:
#
#   atuin init nu
#   | str replace --regex 'name: atuin(\s+modifier: none\s+keycode: up)' 'name: atuin_up_arrow$1'
#   | str replace --regex '(keycode: char_r\s+mode: \[emacs, vi_normal, vi_insert)\]' '$1, helix_insert, helix_normal, helix_select]'
#   | str replace --regex '(keycode: up\s+mode: \[emacs, vi_normal, vi_insert)\]' '$1, helix_insert, helix_normal]'
#   | save -f ~/.local/share/atuin/init.nu
#
# 1st replace: atuin names both its keybindings `atuin` and nushell warns about
# duplicates. fixed upstream in atuinsh/atuin#3975, unreleased as of 18.20.0 --
# drop it once a release includes the fix.
# 2nd/3rd: atuin only targets emacs/vi modes, so ctrl+r and up do nothing in
# helix mode. up stays out of helix_select on purpose -- select mode
# deliberately keeps Up off history so it can't replace the anchored buffer.
