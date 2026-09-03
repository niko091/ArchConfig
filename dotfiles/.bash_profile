#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Start the graphical session automatically after logging in on tty1.
if [[ -z ${WAYLAND_DISPLAY:-} && -z ${DISPLAY:-} && $(tty) == /dev/tty1 ]]; then
    exec /usr/bin/niri-session -l
fi
