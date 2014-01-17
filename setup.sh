#!/bin/bash

# script to systematically
# a) back up the current dotfiles that conflict with the ones here
# b) create symlinks from this folder back

# step a)
mkdir ~/backup;

for dotfile in .*
do
	if [ "." != "$dotfile" -a ".." != "$dotfile" ]
	then

		if [ -n "$(find ~ -maxdepth 1 -name "$dotfile")" ]
		then
			mv "$HOME/$dotfile" "$HOME/backup/$dotfile"
		fi

	# steb b)
	ln -s "$PWD/$dotfile" "$HOME/$dotfile"
	fi

done
