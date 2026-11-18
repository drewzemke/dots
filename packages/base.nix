{ pkgs, unstable, own }:

with pkgs; [
  # shell & editor
  unstable.atuin
  fish
  unstable.nushell
  unstable.steel # forge + steel-language-server
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
  nodejs
  pnpm
  python3
  rustup
  uv

  # language servers
  markdown-oxide
  taplo
  tofu-ls
  vscode-langservers-extracted
  yaml-language-server

  # my projects
  own.army
  own.party

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
