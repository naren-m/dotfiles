
echo "Cloning oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "Cloning zsh-syntax-highlighting "
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


echo "Cloning zsh-autosuggestions (fish-like) "
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Cloning z for quick navigation through folders"
git clone https://github.com/rupa/z.git ~/dotfiles/z

# Vim plugins

echo "Cloning nerdTree for vim"
git clone https://github.com/scrooloose/nerdtree ~/dotfiles/.vim/bundle/nerdtree
