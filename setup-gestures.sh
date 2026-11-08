#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# Pin the upstream implementation so reinstalls use the same reviewed version.
upstream_commit=87e81bbec9dc3599653612a0ba560af1ba2989e5
gesture_dir="$HOME/.local/share/libinput-gestures"
mkdir -p "$gesture_dir"
download="$(mktemp "$gesture_dir/.download.XXXXXX")"
trap 'rm -f -- "$download"' EXIT
curl --fail --location --silent --show-error \
    "https://raw.githubusercontent.com/bulletmark/libinput-gestures/$upstream_commit/libinput-gestures" \
    --output "$download"
install -m644 "$download" "$gesture_dir/libinput-gestures"

for relative in .config/libinput-gestures.conf .config/systemd/user/libinput-gestures.service; do
    source_file="$repo_dir/dotfiles/$relative"
    target_file="$HOME/$relative"
    if [[ -e $target_file || -L $target_file ]]; then
        if [[ $(readlink -f -- "$target_file") != "$source_file" ]]; then
            echo "Existing configuration would be overwritten: $target_file" >&2
            exit 1
        fi
    else
        mkdir -p "$(dirname -- "$target_file")"
        ln -s "$source_file" "$target_file"
    fi
done

# System changes need administrator authentication; the daemon runs as the user.
if [[ ${1:-} == --pkexec ]]; then
    pkexec /usr/bin/bash "$repo_dir/system/install-touchpad-gestures.sh"
else
    sudo /usr/bin/bash "$repo_dir/system/install-touchpad-gestures.sh"
fi

systemctl --user daemon-reload
systemctl --user enable --now libinput-gestures.service
