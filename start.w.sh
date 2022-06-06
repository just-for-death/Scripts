#!/bin/bash
cd "$(dirname "$0")" || exit; [ "$EUID" = "0" ] && exit
RUMTRICKS="$PWD/files/rumtricks.sh"; [ ! -e "$RUMTRICKS" ] && cp /usr/bin/rumtricks "$RUMTRICKS"; [ ! -x "$RUMTRICKS" ] && chmod +x "$RUMTRICKS"
export WINEPREFIX="$PWD/files/prefix"; export STAGING_SHARED_MEMORY=1; export WINE_LARGE_ADDRESS_AWARE=1;

# config
BINDIR="$PWD/files/groot/bin"; BIN="FarCry6.exe"; echo "$BIN" >>"$PWD/files/binval.txt"
export WINEESYNC=1; export WINEFSYNC=1; export VKD3D_CONFIG="multi_queue"
export WINEDLLOVERRIDES="mscoree=d;mshtml=d;nvapi64=n;nvapi=n;"
export WINE="$(command -v wine)"
#[ $(command -v winejc141) ] && (export WINE=$(winejc141 tkg/nomingw/ge)) || export WINE="$BINDIR/wine/bin/wine"
CMD=("$WINE" "$BIN")

# gamescope/FSR
: ${GAMESCOPE:=$(command -v gamescope)}; RRES=$(command -v rres); FSR_MODE="${FSR:=}"
[ -x "$GAMESCOPE" ] && { [[ -x "$RRES" && -n "$FSR_MODE" ]] && CMD=("$GAMESCOPE" -f $("$RRES" -g "$FSR_MODE") -- "${CMD[@]}") || CMD=("$GAMESCOPE" -f -- "${CMD[@]}"); }

# dwarfs
[ ! -f "$BINDIR/$BIN" ] && mkdir -p {"$PWD/files/groot-mnt","$PWD/files/groot-rw","$PWD/files/groot-work","$PWD/files/groot"} && dwarfs "$PWD/files/groot.dwarfs" "$PWD/files/groot-mnt" && fuse-overlayfs -o lowerdir="$PWD/files/groot-mnt",upperdir="$PWD/files/groot-rw",workdir="$PWD/files/groot-work" "$PWD/files/groot"

# rumtricks
"$RUMTRICKS" isolation directx vcrun2015 vcrun2017 vcrun2019 vkd3d win10 dxvk

# logo
echo -e "\e[38;2;140;180;240m" && cat << 'EOF'
⠀⠀⠀⠀⣴⣶⣤⡤⠦⣤⣀⣤⠆⠀⠀⠀⠀⠀⣈⣭⣿⣶⣿⣦⣼⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣴⣶⣶⡿⠀⢠⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡆⠀⠀⢀⣀⠀⠀⠀⠀⢀⣴⡆⠀⠀⠀⠀⠀⠀⠀⢀⣴⡆⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣟⠦⠀⣾⣿⣿⣷⠀⠀⠀⠀⠻⠿⢿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⢿⣿⡉⠁⠀⢸⣿⠃⠀⣾⣿⠀⠀⠀⢀⣀⠀⠀⠀⣀⣤⣴⣶⣿⣿⠀⠀⠀⠻⣿⣧⠀⠀⢀⣿⡟⠀⠀⠀⣀⣤⣴⣶⣿⣿⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⢧⠀⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⢸⣿⠀⠀⣿⣿⠀⣠⣾⠟⠿⣿⣦⡄⠉⠉⠉⠀⣿⣿⠀⠀⠀⠀⣿⡿⠀⠀⣸⣿⠁⠀⠀⠀⠈⠉⠉⠀⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⠈⠀⠀⠀⠀⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀⠀⠀⠀⠀⠀⢠⣶⠟⠛⠛⢸⣿⠀⠀⣿⣿⠀⣿⣿⠀⠀⠀⠉⠁⠀⠀⠀⠀⣿⣿⠀⠀⠀⣰⡿⠃⠀⠀⣿⣿⠀⢀⣾⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⢠⣧⣶⣥⡤⢄⠀⣸⣿⣿⠘⠀⠀⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄⠀⠀⠀⠀⠀⠉⠀⡀⠀⢸⣿⠀⠀⣿⣿⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⢶⣿⣷⣶⣶⣶⣿⣿⣾⣿⣯⣀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀
⠀⠀⠀⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷⠀⠀⠀⢊⣿⣿⡏⠀⠀⢸⣿⣿⡇⠀⢀⣠⣄⣾⠄⠀⠀⠀⠀⠀⠀⣀⡈⠙⠛⠛⠋⠀⠀⣿⡿⠀⣿⡿⠀⠀⠀⢀⡀⠀⠀⠀⢀⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠉⠉⠉⠀⠀⠀⢀⣿⡿⠀⠀⠀⠀
⠀⠀⣠⣿⠿⠛⠀⢀⣿⣿⣷⠘⢿⣿⣦⡀⠀⢸⢿⣿⣿⣄⠀⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄⠀⠀⠀⢠⣾⡟⠁⠀⠀⠀⠀⣠⣾⡿⠁⠀⠻⣿⣶⣤⣴⡿⠃⣠⣤⣶⡿⠿⣿⣶⣤⣄⠀⠀⣀⣠⣤⣿⣿⣶⣦⣤⠀⣠⣤⣶⡿⠿⣿⣶⣦⣄⠀
⠀⠀⠙⠃⠀⠀⠀⣼⣿⡟⠀⠀⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿⠀⣿⣿⡇⠀⠛⠻⢷⣄⠀⠀⠈⠻⢿⣷⣶⣶⣿⠿⠟⠋⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠉⠉⠀⠀⠀⠀⠀⠉⠉⠀⠀⠉⠉⠉⠀⠀⠀⠉⠁⠀⠈⠉⠀⠀⠀⠀⠀⠉⠉⠀
⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣄⠀⠀⠀⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟⠀⠫⢿⣿⡆⠀⠀⠀⠀⠀⠀Pain⠀heals,⠀chicks⠀dig⠀scars,⠀glory⠀lasts⠀forever!
⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀Hacker⠀group⠀on⠀1337x.to⠀and⠀rumpowered.org
EOF
echo -e "\e[0m"

# start
[ "${DBG:=0}" = "1" ] || exec &>/dev/null
cd "$BINDIR"; exec "${CMD[@]}" "$@"
