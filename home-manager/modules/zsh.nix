{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;
      ignoreDups = true;
      ignoreSpace = false;
    };

    shellAliases = {
      tree = "find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'";
      ls = "eza --group-directories-first --color=auto";
      ll = "eza -lah --group-directories-first --color=auto";

      ga = "git add .";
      gp = "git push";
      gf = "git fetch --all --prune";
      gl = "git pull --rebase --autostash";
      gc = "git commit";
      gst = "git status -sb";
      gco = "git checkout";
      gcb = "git checkout -b";
      glog = "git log --oneline --graph --decorate --all";
      cat = "bat";
    };

    initContent = ''
      setopt HIST_REDUCE_BLANKS

      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS

      jjpub() {
        jj bookmark set main -r @- && jj git push -b main
      }

      if command -v gpgconf >/dev/null 2>&1 && [ -d "$HOME/.gnupg" ]; then
        unset SSH_AGENT_PID
        if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
          export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        fi
        gpgconf --launch gpg-agent
      fi
    '';
  };
}
