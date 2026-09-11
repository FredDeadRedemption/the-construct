{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim

    # lazyvim deps not already in shell.nix/dev.nix
    lazygit
    fzf
    unzip
    nodejs
    tree-sitter
  ];

  # mason downloads dynamically linked lsp binaries that expect a filesystem hierarchy standard loader
  programs.nix-ld.enable = true;

  environment.variables.EDITOR = "nvim";
}
