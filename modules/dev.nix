{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
    github-desktop

    rustc
    cargo
    rust-analyzer

    # cc for rust build scripts and -sys crates
    gcc
    pkg-config

    python3

    kubernetes-helm
    k9s

    # psql and pg_dump only, server is services.postgresql
    postgresql
  ];
}
