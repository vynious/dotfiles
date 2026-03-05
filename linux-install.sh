#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Ensure Nix is installed ────────────────────────────────
if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is not installed. Installing via Determinate Systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # Source nix in current shell
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# ── Ensure flakes are usable ───────────────────────────────
if ! nix flake --help >/dev/null 2>&1; then
  echo "Enabling flakes and nix-command..."
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# ── Apply Home Manager config ──────────────────────────────
echo "==> Applying Home Manager config"
HM_BACKUP_EXT="backup-$(date +%Y%m%d-%H%M%S)"
HM_FLAKE_TARGET="${ROOT_DIR}/home-manager#x86_64-linux"
if command -v home-manager >/dev/null 2>&1; then
  home-manager switch --impure -b "${HM_BACKUP_EXT}" --flake "${HM_FLAKE_TARGET}"
else
  nix run github:nix-community/home-manager -- switch --impure -b "${HM_BACKUP_EXT}" --flake "${HM_FLAKE_TARGET}"
fi

# ── Post-install: Docker setup ─────────────────────────────
if command -v docker >/dev/null 2>&1; then
  if ! groups | grep -q docker; then
    echo "==> Adding $USER to the docker group (requires sudo)"
    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"
    echo "    Log out and back in for docker group to take effect."
  fi
fi

echo "==> Done"
