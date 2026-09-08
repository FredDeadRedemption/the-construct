{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vscode

    rustc
    cargo
    rust-analyzer

    python3

    kubernetes-helm
    k9s

    # psql and pg_dump only, server is services.postgresql
    postgresql
  ];
}
