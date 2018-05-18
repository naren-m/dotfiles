#!/usr/bin/env bash

git pull origin master;

source get_plugins.sh

function doIt() {
    # Backing up original files to backup folder in dotfiles
    mv ~/.bash_profile $PWD/backup/.bash_profile.orig 2>/dev/null
    mv ~/.bashrc $PWD/backup/.bashrc.orig 2>/dev/null
    mv ~/.vimrc $PWD/backup/.vimrc.orig 2>/dev/null
    mv ~/.zshrc $PWD/backup/.zshrc.orig 2>/dev/null

    mv ~/.aliases $PWD/backup/.aliases.orig 2>/dev/null
    mv ~/.aliases_work $PWD/backup/.aliases_work.orig 2>/dev/null
    mv ~/.aliases_mac $PWD/backup/.aliases_mac.orig 2>/dev/null
    mv ~/.aliases_docker $PWD/backup/.aliases_docker.orig 2>/dev/null
    mv ~/.aliases_kubectl $PWD/backup/.aliases_kubectl.orig 2>/dev/null

    mv ~/.deep_learning $PWD/backup/.deep_learning.orig 2>/dev/null
    mv ~/.tmux.conf $PWD/backup/.tmux.conf.orig 2>/dev/null
    mv ~/.vim/ $PWD/backup/.vim.orig 2>/dev/null

    # Create links for alias/sourcing files
    ln -s $PWD/zshrc ~/.zshrc
    ln -s $PWD/aliases/aliases ~/.aliases
    ln -s $PWD/aliases/aliases_work ~/.aliases_work
    ln -s $PWD/aliases/aliases_mac ~/.aliases_mac
    ln -s $PWD/aliases/aliases_docker ~/.aliases_docker
    ln -s $PWD/aliases/aliases_kubectl ~/.aliases_kubectl

    ln -s $PWD/aliases/deep_learning ~/.deep_learning

    ln -s $PWD/.bashrc ~/.bashrc
    ln -s $PWD/.bash_profile ~/.bash_profile
    ln -s $PWD/.tmux.conf ~/.tmux.conf

    if [ ! -f ~/.oh-my-zsh/themes/naren.zsh-theme  ];
    then
        ln -s $PWD/zsh_themes/naren.zsh-theme ~/.oh-my-zsh/themes/naren.zsh-theme
    fi

    # Vim setup
    ln -s $PWD/vi_conf/.vimrc ~/.vimrc
    cp -r $PWD/vi_conf/vim ~/.vim
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
