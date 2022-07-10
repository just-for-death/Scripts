#!/bin/bash
 
shopt -s expand_aliases
shutdownChoice=$(zenity --height=300 --list --radiolist --text "would you like to log out?" --column "" --column "Action:" \
    FALSE "Lock" \
    TRUE "Log out" \
    FALSE "Restart" \
    FALSE "Shut down" \
    FALSE "Suspend" \
    FALSE "Hibernate")
alias i3lock="i3lock -i $HOME/Pictures/Wallpapers/Tye/Broken-Windows-Error.png -p win"
case "$shutdownChoice" in
 Lock) i3lock;;
 "Log out") i3-msg exit;;
 Restart) systemctl reboot;;
 "Shut down") systemctl poweroff;;
 Suspend) i3lock && systemctl suspend;;
 Hibernate) i3lock && systemctl hibernate;;
 *) echo Cancelled;;
esac
