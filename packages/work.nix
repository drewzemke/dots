{ pkgs, unstable, own }:

with pkgs; [
  istioctl
  mongosh
  mariadb.client
  postgresql
  snowflake-cli
]
