{ config, pkgs, lib, ... }:

let
  envDotfiles = builtins.getEnv "DOTFILES_DIR";
  envHome = builtins.getEnv "HOME";
  dotfilesDir = if envDotfiles != "" then envDotfiles else "${envHome}/dotfiles";
in

{
  home.file = {
    ".config/zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zed";
      force = true;
    };

    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
      force = true;
    };

    ".config/kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/kitty";
      force = true;
    };

    ".config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/starship/starship.toml";
      force = true;
    };
  };

  # macOS-only
  home.file.".aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/aerospace/.aerospace.toml";
    force = true;
  };
}
