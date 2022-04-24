#!/bin/bash
# Brought to you by YASHWIN
cd "$(dirname "$0")" || exit
echo -e "\e[38;5;$((RANDOM%257))m
YASHWIN
\e[0m"
# Settings ettings
export NSP="Pokemon Legends Arceus.xci"
export GAME_FOLDER="game"
export YUZU="$(command -v yuzu)"
export XDG_DATA_HOME="$PWD/game/data"
export XDG_CONFIG_HOME="$PWD/game/data"
export PULSE_LATENCY_MSEC=60

# Forbid root rights
[ "$EUID" = "0" ] && exit

# Start game
cd "$GAME_FOLDER" || exit
"$YUZU" "$NSP"
