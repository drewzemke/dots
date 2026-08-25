# zoxide setup
if not ('~/.zoxide.nu' | path exists) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin setup: autoload/atuin.nu sources ~/.local/share/atuin/init.nu, which
# atuin generates at install time. it goes stale after a nushell upgrade since
# it targets the old nu syntax. regenerate + patch with:
#   atuin init nu
#   | str replace --regex 'name: atuin(\s+modifier: none\s+keycode: up)' 'name: atuin_up_arrow$1'
#   | save -f ~/.local/share/atuin/init.nu
# the str replace works around atuin naming both its keybindings `atuin`, which
# nushell warns about. fixed upstream in atuinsh/atuin#3975, unreleased as of
# 18.20.0 -- drop the patch once a release includes it.
