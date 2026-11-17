{ pkgs, unstable }:

with pkgs; [
  istioctl
  mongosh
  mariadb.client
  postgresql
  snowflake-cli
]
