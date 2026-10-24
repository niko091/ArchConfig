# Start Niri after an interactive local login on tty1.
if [[ -o interactive &&
      -z ${WAYLAND_DISPLAY:-} &&
      -z ${DISPLAY:-} &&
      ${TTY:-} == /dev/tty1 ]]; then
    exec /usr/bin/niri-session -l
fi
