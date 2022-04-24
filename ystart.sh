#!/bin/bash
cd "$(dirname "$0")" || exit; [ "$EUID" = "0" ] && exit; echo -e "\e[0m"; export HOME="$PWD/files/data"; export XDG_DATA_HOME="$PWD/files/data/.local"; export XDG_CONFIG_HOME="$PWD/files/data/.config"; : ${GAMESCOPE:=$(command -v gamescope)}; mkdir -p {"$HOME","$XDG_CONFIG_HOME","$XDG_DATA_HOME"}; echo -e "\e[38;5;38m" && cat << 'EOF'
    ___  ________     _____  ___   ___    _____
   |\  \|\   ____\   / __  \|\  \ |\  \  / __  \
   \ \  \ \  \___|  |\/_|\  \ \  \\_\  \|\/_|\  \
 __ \ \  \ \  \     \|/ \ \  \ \______  \|/ \ \  \
|\  \\_\  \ \  \____     \ \  \|_____|\  \   \ \  \
\ \________\ \_______\    \ \__\     \ \__\   \ \__\
 \|________|\|_______|     \|__|      \|__|    \|__|
  Pain heals, Chicks dig scars, Glory lasts forever!
     Hacker group on 1337x.to and rumpowered.org
EOF
echo -e "\e[0m";
YUZU="$(command -v yuzu)"; export QT_QPA_PLATFORM=xcb
GROOT="$PWD/files/groot"; BIN="Kirby and the Forgotten Land [01004D300C5AE000][v0].nsp"
# start
cd "$GROOT"; [ ! -x "$GAMESCOPE" ] && exec "$YUZU" "$BIN" "$@" || exec gamescope -f -- "$YUZU" "$BIN" "$@"
