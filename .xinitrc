setxkbmap dvorak
wmname LG3D &
#xset fp+ /usr/share/fonts/terminus
exec /usr/bin/ssh-agent &
PID1=$!
exec /usr/bin/xbindkeys &
PID2=$!
exec /home/chris/.dropbox-dist/dropboxd &
PID3=$!
exec /home/chris/.dwm/timescript &
PID4=$!
exec redshift -l 40:-83 &
PID5=$!
/home/chris/.dwm/dwm
pkill $PID1 $PID2 $PID3 $PID4 $PID5
