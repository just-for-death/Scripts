#!/bin/bash

# defaults
export WINEPREFIX="$PWD/files/prefix"

mount() {
    mkdir -p {"/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt","/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-rw","/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-work","/home/elsa/Downloads/Far.Cry.6-jc141/files/groot"} && dwarfs "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot.dwarfs" "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt" && fuse-overlayfs -o lowerdir="/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt",upperdir="/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-rw",workdir="/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-work" "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot"
}

unmount() {
    wineserver -k && killall -f $(<"$PWD/files/binval.txt") && sleep 2
    [ -d "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot" ] && fusermount -u "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot"
    [ -d "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt" ] && fusermount -u "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt" && rm -d -f "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot-mnt"
}

extract() {
    echo "extracting game root..."; tstart="$(date +%s)"
    [ ! -d "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot" ] && mkdir "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot"
    dwarfsextract -n "${JOBS-$(nproc)}" -i "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot.dwarfs" -o "/home/elsa/Downloads/Far.Cry.6-jc141/files/groot"
    tend="$(date +%s)"; elapsed="$((tend - tstart))"
    echo "done in $((elapsed / 60)) min and $((elapsed % 60)) sec"
}

"${1-unmount}"
