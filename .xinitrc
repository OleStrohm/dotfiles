#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	modmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge $userresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

setxkbmap -option "caps:super,numpad:microsoft"

#xrandr | grep DP-0
#retstatus = $?
#if [ $retstatus -eq 0 ] &&
xrandr --output DP-0.8 --primary --output DP-0.1 --auto --right-of DP-0.8

session=${1:-awesome}

case $session in
	awesome ) exec awesome;;
	plasma  ) exec startplasma-x11;;
    gnome   ) exec gnome-session;;
	*       ) exec awesome;;
esac
