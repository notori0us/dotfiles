#!/bin/bash

# script to systematically
# a) remove symlinks
# a) restore from backup

# step a)

rm already_set_up

for file in $HOME/backup/.*
do

	dotfile=$(echo "$file" | rev | cut -d"/" -f1-1 | rev)

	if [ "." != "$dotfile" -a ".." != "$dotfile" ]
	then
		if [ -n "$(find . -maxdepth 1 -name "$dotfile")" ]
		then
			rm "$HOME/$dotfile";
			mv "$HOME/backup/$dotfile" "$HOME/$dotfile";
		fi
	fi
done
