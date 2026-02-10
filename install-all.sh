#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install it first: https://brew.sh/"
  exit 1
fi

echo "==> Installing/updating casks from brew/Brewfile"
brew bundle --file "${ROOT_DIR}/brew/Brewfile"

echo "==> Applying Home Manager config"
if command -v home-manager >/dev/null 2>&1; then
  home-manager switch --flake "${ROOT_DIR}/home-manager"
else
  nix run github:nix-community/home-manager -- switch --flake "${ROOT_DIR}/home-manager"
fi

echo "==> Done"
