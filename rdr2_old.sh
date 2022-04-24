#!/bin/bash
 
# Game
EXEC=RDR2.exe
EXEC_PATH="$PWD/game"
 
# Wine prefix
export WINEARCH=win64
export WINEPREFIX="$PWD/prefix"
 
# Wine configuration
export WINEDLLOVERRIDES="mscoree,mshtml,winedbg=d,dinput8,dxgi=n,b"
export WINEESYNC=1
export STAGING_SHARED_MEMORY=1
export WINE_LARGE_ADDRESS_AWARE=1
export PULSE_LATENCY_MSEC=60
 
# DXVK configuration
export DXVK_LOG_PATH=none
export DXVK_ASYNC=1
export DXVK_FRAME_RATE=0
export DXVK_STATE_CACHE_PATH="$PWD"
 
# VKD3D configuration
export VKD3D_DEBUG=none
export VKD3D_SHADER_DEBUG=none
 
# Executables
export WINE="$PWD/wine/bin/wine"
WINETRICKS="$PWD/winetricks"
GAMEMODE=$(command -v gamemoderun)
 
# Versioning, paths
WINE_PATH=$(echo "$WINE" | awk -F '/bin' '{print $1}')
GAME_NAME="$(basename "$PWD")"
if [ ! -f "$HOME/.local/share/applications/$GAME_NAME.desktop" ]; then
cat << EOM | tee "$GAME_NAME.desktop"
[Desktop Entry]
Comment=Play $GAME_NAME
Exec='$PWD/run'
Icon=$PWD/$(grep -m 1 "EXEC" run | cut -d"=" -f2 | cut -d"." -f1).ico
Name=$GAME_NAME
NoDisplay=false
Path[$e]=$PWD
StartupNotify=true
Terminal=0
Type=Application
Categories=Game
EOM
chmod +x "$GAME_NAME.desktop"
mv -f "$GAME_NAME.desktop" $HOME/.local/share/applications/
fi
 
function check-prefix() {
    if [[ ! -d "$WINEPREFIX" || $(ls "$WINEPREFIX" | wc -l) == 0 ]]; then
        "$WINE" wineboot
        "$WINE_PATH/bin/wineserver" -w
        update-dlls
        setup-fonts
    fi
}
 
function update-dlls() {
    WINE_LIB64="$WINE_PATH/lib64/wine"
    WINE_LIB="$WINE_PATH/lib/wine"
    dxvk_dlls=("dxvk_config" "d3d11" "d3d10" "d3d10core" "d3d10_1" "d3d9" "dxgi" "openvr_api_dxvk")
 
    echo "Copying OpenVR dlls"
    mkdir -p "$WINEPREFIX/drive_c/vrclient/bin"
    cp -rf "$WINE_LIB/fakedlls/vrclient.dll" "$WINEPREFIX/drive_c/vrclient/bin/"
    cp -rf "$WINE_LIB64/fakedlls/vrclient_x64.dll" "$WINEPREFIX/drive_c/vrclient/bin/"
 
    for dll in "${dxvk_dlls[@]}"; do
        echo "Copying $dll.dll into wineprefix"
        cp -rf "$WINE_LIB/dxvk/$dll.dll" "$WINEPREFIX/drive_c/windows/syswow64/$dll.dll"
        cp -rf "$WINE_LIB64/dxvk/$dll.dll" "$WINEPREFIX/drive_c/windows/system32/$dll.dll"
    done
 
    for dll in "${dxvk_dlls[@]}" "vrclient vrclient_x64"; do
        if ! "$WINE" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v "$dll" /d native /f
        then
            echo "Failed to add override for $dll"
            exit 1
        fi
    done
}
 
function setup-fonts() {
    FONTS_WINDOWS="$WINEPREFIX/drive_c/windows/Fonts"
    fontmap=(
        "LiberationSans-Regular.ttf arial.ttf"
        "LiberationSans-Bold.ttf arialbd.ttf"
        "LiberationSerif-Regular.ttf times.ttf"
        "LiberationMono-Regular.ttf cour.ttf"
        "SourceHanSansSCRegular.otf msyh.ttf"
    )
    mkdir -p "$FONTS_WINDOWS"
    for font in "${fontmap[@]}"; do
        echo "Symlinking font $(echo $font | cut -d ' ' -f1)"
        ln -sf "$WINE_PATH/share/fonts/$(echo $font | cut -d " " -f1)" "$FONTS_WINDOWS/$(echo $font | cut -d " " -f2)"
    done
}
 
check-prefix || exit
 
cd "$EXEC_PATH" || exit
$GAMEMODE "$WINE" "$EXEC" -vulkan -USEALLAVAILABLECORES -cpuLoadRebalancing -ignorepipelinecache &sleep 5 && \
    PID=$(pgrep "RDR2.exe") && \
    kill -s SIGSTOP "$PID" && \
    kill -s SIGCONT "$PID"
 
