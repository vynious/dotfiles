{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];
  };

  programs.lazygit = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
  };

  programs.helix = {
    enable = true;
  };
}
