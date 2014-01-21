#!/usr/local/bin/bash

# script to systematically
# a) back up the current dotfiles that conflict with the ones here
# b) create symlinks from this folder back

# step a)
mkdir ~/backup;

echo "is set up" >> already_set_up

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

# install skybison
if [ -z $(find "$PWD/.vim/bundle" -name "skybison") ]
then
	git clone https://github.com/paradigm/SkyBison.git;
	mkdir .vim/bundle
	mkdir .vim/bundle/skybison;
	mv SkyBison/plugin .vim/bundle/skybison/plugin;

	rm -rf SkyBison;
fi

# make dwm
cd .dwm;
make
cd ..;
