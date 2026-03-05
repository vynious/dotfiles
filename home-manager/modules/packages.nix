{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    automake
    python3Packages.pycparser
    python3Packages.cffi
    python3Packages.cryptography
    openjdk
    bfg-repo-cleaner
    erlang
    gcc
    libpq
    lua
    minikube
    nodejs
    neofetch
    fnm
    opencode
    openssl
    procs
    cmake

    git
    git-lfs
    delta
    jujutsu
    jjui

    coreutils
    curl
    wget

    jq
    yq

    fd
    eza
    neovim

    go

    rustup
    cargo-watch
    cargo-edit
    nil
    nixd
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    xclip
    docker
    docker-compose
    nerd-fonts.monaspace
    nerd-fonts._0xproto
    ngrok
    zed-editor
  ];
}
