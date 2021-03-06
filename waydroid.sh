 #!/bin/bash
 if [ "$(/usr/bin/systemctl is-active waydroid-container.service)" == 'active' ];then
     /usr/bin/killall -9 weston
     /usr/bin/sudo /usr/bin/systemctl stop waydroid-container.service
     exit
 fi
 /usr/bin/sudo /usr/bin/systemctl restart waydroid-container.service
 /usr/bin/killall -9 weston
 if [ -z "$(/usr/bin/pgrep weston)" ]; then
     /usr/bin/weston --width=780 --height=425 --xwayland &> /dev/null &
 fi
 /usr/bin/sleep 1 &&
 export XDG_SESSION_TYPE='wayland'
 export DISPLAY=':1'
 /bin/bash -c 'sleep 7 && sudo /usr/local/bin/anbox-bridge force-reload' &
 /usr/bin/konsole --new-tab --hide-tabbar --hide-menubar -e '/usr/bin/waydroid show-full-ui' &
 while [ -n "$(/usr/bin/pgrep weston)" ];do
     /usr/bin/sleep 1
 done
 /usr/bin/sudo /usr/bin/systemctl stop waydroid-container.service
