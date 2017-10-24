#!/usr/bin/env bash

git pull origin master;

source get_plugins.sh

function doIt() {
	cp ~/.bash_profile $PWD/backup/.bash_profile.orig 2>/dev/null
	cp ~/.bashrc $PWD/backup/.bashrc.orig 2>/dev/null
	cp ~/.vimrc $PWD/backup/.vimrc.orig 2>/dev/null
	cp ~/.zshrc $PWD/backup/.zshrc.orig 2>/dev/null
	cp -r ~/.vim/ $PWD/backup/.vim.orig 2>/dev/null

	# Create links for alias/sourcing files
	ln -s $PWD/.aliases ~/.aliases
	ln -s $PWD/.aliases_work ~/.aliases_work
	ln -s $PWD/.aliases_mac ~/.aliases_mac
	ln -s $PWD/.docker_aliases ~/.docker_aliases

	ln -s $PWD/.deep_learning ~/.deep_learning

	ln -s $PWD/.bashrc ~/.bashrc
	ln -s $PWD/.bash_profile ~/.bash_profile

	echo "Setting up the theme"
	ln -s $PWD/zsh_themes/naren.zsh-theme ~/.oh-my-zsh/themes/naren.zsh-theme

	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
