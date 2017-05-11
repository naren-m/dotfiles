#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

source ~/dotfiles/get_plugins.sh
function doIt() {
#        cp ~/.bash_profile ~/.bash_profile.orig 2>/dev/null
#        cp ~/.bashrc ~/.bashrc.orig 2>/dev/null
#        cp ~/.vimrc ~/.vimrc.orig 2>/dev/null
#        cp ~/.zshrc ~/.zshrc.orig 2>/dev/null
#        cp -r ~/.vim/ ~/.vim.orig 2>/dev/null

	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "get_plugins.sh" \
		--exclude ".aliases_work" \
		--exclude "README.md" \
		--exclude "z" \
		--exclude "zsh-autosuggestions" \
		--exclude "zsh_themes" \
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

echo "Setting up the theme"
ln -s ~/dotfiles/zsh_themes/naren.zsh-theme ~/.oh-my-zsh/themes/naren.zsh-theme

echo "Copying zsh-autosuggestions (fish-like) "
cp -r zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
