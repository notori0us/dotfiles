setxkbmap dvorak
wmname LG3D &
#xset fp+ /usr/share/fonts/terminus

if ! pidof ssh-agent > /dev/null
then
	/usr/bin/ssh-agent &
fi

if ! pidof xbindkeys > /dev/null
then
	/usr/bin/xbindkeys &
fi

if ! pidof dropbox > /dev/null
then
	/home/chris/.dropbox-dist/dropboxd &
fi

if ! pidof timescript > /dev/null
then
	/home/chris/.dwm/timescript &
fi

if ! pidof redshift > /dev/null
then
	redshift -l 40:-83 &
fi


/home/chris/.dwm/dwm
