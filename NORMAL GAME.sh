#!/bin/bash
# Brought to you by the johncena141 release group on 1337x.to
cd "$(dirname "$0")" || exit
echo -e "\e[38;5;$((RANDOM%257))m
   ▄▄        ▄▄
   ██       ███
             ██                                               ▄▄▄          ▄▄▄
 ▀███ ▄████▄ ██████▄▀███████▄  ▄████  ▄▄█▀██▀███████▄  ▄█▀██▄▀███      ▄██▀███
   ████▀  ▀████   ██  ██   ██ ██▀ ██ ▄█▀   ██ ██   ██ ██   ██  ██     ████  ██
   ████    ████   ██  ██   ██ ██     ██▀▀▀▀▀▀ ██   ██  ▄█████  ██   ▄█▀ ██  ██
   ████▄  ▄████   ██  ██   ██ ██▄   ▄██▄    ▄ ██   ██ ██   ██  ██ ▄█▀   ██  ██
   ██ ▀████▀████ ████████ ████▄█████▀ ▀█████▀████ ████▄████▀██████▄████████████▄
██ ██                                                                  ██
▀███         Pain heals. Chicks dig scars. Glory lasts forever!        ██\e[0m"
# Wine settings
export WINEESYNC=1
export WINEFSYNC=1
export WINEARCH=win64
export WINEPREFIX="$PWD/game/prefix"
export WINEDLLOVERRIDES="mscoree=d;mshtml=d;"
export WINE="$(command -v wine)"

# Game files
export EXE="bin/x64/Cyberpunk2077.exe"
export GAME_FOLDER="game/files"

# Extra
CHADTRICKS="$PWD/game/chadtricks.sh"; export STAGING_SHARED_MEMORY=1; export WINE_LARGE_ADDRESS_AWARE=1; export WINEDEBUG="fixme-all,warn-all";

# Forbid root rights
[ "$EUID" = "0" ] && exit

# Check for chadtricks
[ ! -x "$CHADTRICKS" ] && curl -L "https://raw.githubusercontent.com/john-cena-141/chadtricks/main/chadtricks.sh" -o "$CHADTRICKS" && chmod +x "$CHADTRICKS"

# Install and auto-update vkd3d
export VKD3D_DEBUG=none; export VKD3D_SHADER_DEBUG=none; VKD3D="$(curl -s https://api.github.com/repos/HansKristian-Work/vkd3d-proton/releases/latest | awk -F '["]' '/"browser_download_url":/ {print $4}')"; VKD3DVER="$(curl -s https://api.github.com/repos/HansKristian-Work/vkd3d-proton/releases/latest | awk -F '["/]' '/"browser_download_url":/ {print $11}' | cut -c 2-)"; SYSVKD3D=$(command -v setup_vkd3d_proton 2>/dev/null); SYSVKD3DVER=$(pacman -Qi vkd3d-proton-bin 2>/dev/null | awk -F": " '/Version/ {print $2}' | awk -F"-" '{ print $1 }')
install_vkd3d() {
    $WINE wineboot.exe -u && wineserver -w
    [ -n "$SYSVKD3D" ] && echo "installing vkd3d from system" && $SYSVKD3D install && echo "$SYSVKD3DVER" > "$PWD/game/prefix/.sysvkd3d"
    [ -z "$SYSVKD3D" ] && echo "installing vkd3d from github" && cd "$PWD/game" && curl -L "$VKD3D" -o vkd3d.tar.zst && tar -xf vkd3d.tar.zst && cd "vkd3d-proton-${VKD3DVER}" && ./setup_vkd3d_proton.sh install && cd .. && echo "$VKD3DVER" > prefix/.vkd3d && rm -rf "vkd3d.tar.zst" "vkd3d-proton-${VKD3DVER}" && cd ..
    wineserver -w
}
[[ ! -f "$PWD/game/prefix/.vkd3d" && ! -f "$PWD/game/prefix/.sysvkd3d" ]] && install_vkd3d || echo "vkd3d is installed"
[[ -f "$PWD/game/prefix/.sysvkd3d" && "$(cat "$PWD/game/prefix/.sysvkd3d")" != "$SYSVKD3DVER" ]] && echo "updating vkd3d from system" && install_vkd3d
[[ -f "$PWD/game/prefix/.vkd3d" && -n "$VKD3DVER" && "$VKD3DVER" != "$(awk '{print $1}' "$PWD/game/prefix/.vkd3d")" ]] && echo "newer vkd3d version found, installing" && install_vkd3d

# install vcrun2019
[[ ! -f "$WINEPREFIX/chadtricks.log" || ! "$(awk '/vcrun2019/ {print $1}' "$WINEPREFIX/chadtricks.log" 2>/dev/null)" ]] && $CHADTRICKS vcrun2019

# CP2077: Adjust Pulse latency to fix crackling audio issues
export PULSE_LATENCY_MSEC=90

# CP2077: Set Windows version to 10
$WINE winecfg -v win10

# Disable internet access
[ ! -f "$PWD/game/bindToInterface.so" ] && curl -L "https://gitlab.com/GoldenBoy314/johncena141-scripts/-/raw/main/tools/bindtointerface/bindToInterface.so" -o "$PWD/game/bindToInterface.so"
export BIND_INTERFACE=lo; export BIND_EXCLUDE="127.0.0.1,192.168.,10.,172.16."; export LD_PRELOAD="$PWD/game/bindToInterface.so:$LD_PRELOAD"

# Start game
cd "$GAME_FOLDER" || exit
"$WINE" "$EXE" --launcher-skip -skipStartScreen
