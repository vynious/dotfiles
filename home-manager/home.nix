{ config, pkgs, ... }:

let
  envUser = builtins.getEnv "USER";
  envHome = builtins.getEnv "HOME";
  envDotfiles = builtins.getEnv "DOTFILES_DIR";
  dotfilesDir = if envDotfiles != "" then envDotfiles else "${envHome}/dotfiles";
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  assertions = [
    {
      assertion = envUser != "" && envHome != "";
      message = "USER/HOME are empty. Run Home Manager with --impure.";
    }
  ];

  home.username = envUser;
  home.homeDirectory = envHome;

  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    automake # Generate GNU-style Makefile.in files
    python3Packages.pycparser # Pure Python C parser
    python3Packages.cffi # C FFI bindings for Python
    python3Packages.cryptography # Python cryptography primitives
    openjdk # Java Development Kit
    bfg-repo-cleaner # Remove large or sensitive data from Git history
    erlang # Erlang runtime and tooling
    gcc # GNU compiler collection
    libpq # PostgreSQL client libraries and tools
    lua # Lightweight scripting language
    minikube # Run Kubernetes locally
    nodejs # JavaScript runtime
    neofetch # System information display tool
    fnm # Fast Node.js version manager
    opencode # Terminal AI coding agent
    openssl # TLS/SSL toolkit
    procs # Modern replacement for ps
    cmake

    git # Distributed version control
    git-lfs # Git support for large files
    delta # Syntax-highlighted Git diff pager
    jujutsu # Git-compatible VCS (jj)

    coreutils # GNU core command-line utilitie
    curl # Transfer data over URLs
    wget # Non-interactive network downloader

    jq # Command-line JSON processor
    yq # Command-line YAML/JSON processor

    fzf # Fuzzy finder for files/commands/history
    fd # Fast user-friendly find alternative
    eza # Modern replacement for ls
    bat # Cat clone with syntax highlighting

    tmux # Terminal multiplexer
    zoxide # Smarter cd based on frecency
    starship # Cross-shell prompt
    helix
    neovim

    btop # Interactive system resource monitor
    lazygit # Terminal UI for Git workflows
    yazi # Terminal file manager

    go # Go toolchain and build tools

    rustup # Rust toolchain manager (includes rust-analyzer binary)
    cargo-watch # Re-run Cargo commands on source changes
    cargo-edit # Add/remove/update Cargo dependencies from the CLI
    nil
    nixd
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".aerospace.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/aerospace/.aerospace.toml";
      force = true;
    };

    # Keep Zed writable by linking the whole config dir out of the Nix store.
    ".config/zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zed";
      force = true;
    };

    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";
      force = true;
    };

    ".config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/starship/starship.toml";
      force = true;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/shawntyw/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

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

      idea = "open -na \"IntelliJ IDEA.app\" --args";
      goland = "open -na \"GoLand.app\" --args";

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
