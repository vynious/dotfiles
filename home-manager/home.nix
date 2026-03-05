{ config, ... }:

let
  envUser = builtins.getEnv "USER";
  envHome = builtins.getEnv "HOME";
in

{
  imports = [
    ./modules/packages.nix
    ./modules/zsh.nix
    ./modules/programs.nix
    ./modules/dotfiles.nix
  ];

  assertions = [
    {
      assertion = envUser != "" && envHome != "";
      message = "USER/HOME are empty. Run Home Manager with --impure.";
    }
  ];

  home.username = envUser;
  home.homeDirectory = envHome;
  home.stateVersion = "25.11";

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;
}
