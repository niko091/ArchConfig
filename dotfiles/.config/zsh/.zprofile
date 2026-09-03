# Start Niri automatically only from the primary local login console.
# Passing -l tells niri-session that Zsh is already a login shell.
if [[ -o interactive &&
      -z ${WAYLAND_DISPLAY:-} &&
      -z ${DISPLAY:-} &&
      ${TTY:-} == /dev/tty1 ]]; then
    exec /usr/bin/niri-session -l
fi
