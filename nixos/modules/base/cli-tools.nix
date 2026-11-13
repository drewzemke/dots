{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fzf
    gh
    git
    jjui
    jq
    jujutsu
    just
    vim
    wget
    yq-go
  ];
}
