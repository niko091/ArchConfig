#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

echo "ArchConfig · bootstrap Arch Linux + Niri"

sudo pacman -Syu --needed base-devel git stow
sudo pacman -S --needed - <pkglist_repo.txt

if ! command -v yay >/dev/null 2>&1; then
    build_dir="$(mktemp -d)"
    trap 'rm -rf -- "$build_dir"' EXIT
    git clone https://aur.archlinux.org/yay.git "$build_dir/yay"
    makepkg -D "$build_dir/yay" -si
fi

yay -S --needed - <pkglist_aur.txt
stow --restow --target="$HOME" dotfiles

sudo systemctl enable --now power-profiles-daemon.service thermald.service
if systemctl list-unit-files greetd.service --no-legend | grep -q '^greetd.service'; then
    sudo systemctl disable greetd.service
fi
sudo systemctl enable getty@tty1.service
systemctl --user daemon-reload
systemctl --user enable --now dcal.service niri-auto-mirror.service

if [[ ${SHELL:-} != /usr/bin/zsh ]]; then
    chsh -s /usr/bin/zsh
fi

echo "Installazione completata. Al login su tty1 Niri si avvia automaticamente."
