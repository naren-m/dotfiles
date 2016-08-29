#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

echo "Cloning oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/dotfiles/.oh-my-zsh

echo "Cloning zsh syntax highlighting "
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/dotfiles/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


function doIt() {
        cp ~/.bash_profile ~/.bash_profile.orig 2>/dev/null
        cp ~/.bashrc ~/.bashrc.orig 2>/dev/null
        cp ~/.vimrc ~/.vimrc.orig 2>/dev/null
        cp ~/.zshrc ~/.zshrc.orig 2>/dev/null

        cp -r ~/.vim/ ~/.vim.orig 2>/dev/null

	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude ".aliases_work" \
		--exclude "README.md" \
		-avh --no-perms . ~;
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

