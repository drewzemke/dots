{ pkgs, unstable }:

with pkgs; [
  # shell & editor
  atuin
  fish
  unstable.nushell
  unstable.steelix
  yazi
  zellij
  zoxide

  # cli utils
  age
  bat
  bottom
  delta
  eza
  fd
  fzf
  jq
  just
  less
  ripgrep
  rm-improved
  sops
  tealdeer
  vim
  vivid
  watchexec
  wget

  # vcs
  gh
  git
  gitui
  jjui
  jujutsu

  # k8s / cloud
  awscli2
  flyctl
  k9s
  kubectl
  lazydocker

  # languages & toolchains
  bacon
  cargo-update
  deno
  pnpm
  rustup

  # language servers
  markdown-oxide
  taplo
  tofu-ls
  vscode-langservers-extracted
  yaml-language-server

  # misc
  unstable.claude-code
  bitwarden-cli
  dotter
  pandoc
  rainfrog
  slides
  translate-shell
  typst
]
