#!/bin/bash
cd "$(dirname "$0")" || exit; [ "$EUID" = "0" ] && exit; echo -e "\e[38;5;$((RANDOM%257))m" && cat << 'EOF'
    ___  ________     _____  ___   ___    _____
   |\  \|\   ____\   / __  \|\  \ |\  \  / __  \
   \ \  \ \  \___|  |\/_|\  \ \  \\_\  \|\/_|\  \
 __ \ \  \ \  \     \|/ \ \  \ \______  \|/ \ \  \
|\  \\_\  \ \  \____     \ \  \|_____|\  \   \ \  \
\ \________\ \_______\    \ \__\     \ \__\   \ \__\
 \|________|\|_______|     \|__|      \|__|    \|__|
  Pain heals, Chicks dig scars, Glory lasts forever!
            Hacker group on 1337x.to
EOF
echo -e "\e[0m"; export WINEPREFIX="$PWD/files/prefix"; export STAGING_SHARED_MEMORY=1; export WINE_LARGE_ADDRESS_AWARE=1; export WINEDEBUG="fixme-all,warn-all"; GAMESCOPE="$(command -v gamescope)";
export WINEESYNC=1; export WINEFSYNC=1;
export WINEDLLOVERRIDES="mscoree=d;mshtml=d;"
#export WINE="$PWD/files/groot/wine/bin/wine"
export WINE="$(command -v wine)"
BIN="PlagueIncEvolved.exe"; GROOT="files/groot"

# rumtricks
RUMTRICKS="$PWD/files/rumtricks.sh"; [ ! -x "$RUMTRICKS" ] && curl -L "https://johncena141.eu.org:8141/johncena141/rumtricks/raw/branch/main/rumtricks.sh" -o files/rumtricks.sh && chmod +x files/rumtricks.sh
"$RUMTRICKS" isolate dxvk directx vcrun2015

# start
cd "$GROOT" || exit; if [ ! -x "$GAMESCOPE" ]; then exec "$WINE" "$BIN" "$@"; else exec gamescope -f -- "$WINE" "$BIN" "$@"; fi
