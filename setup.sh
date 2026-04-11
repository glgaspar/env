#!/bin/bash

echo "Select type of Linux: "
echo "Arch (a)"
echo "Debian (d)"
read os

if [[ "$os" == "d" ]];then
    echo "Debian selected!" 
    echo "Starting installation..."

    sudo apt update
    sudo apt upgrade
    sudo apt install zsh -y
    sudo apt install -y tmux fontconfig wget unzip
    sudo bash ./docker_debian.sh
    wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo apt install ./vscode.deb
    sudo apt install ruby-full

elif [[ "$os" == "a" ]];then
    echo "Arch selected!"
    echo "Starting installation..."

    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel git zsh tmux ruby ghostty fontconfig wget unzip

    echo "Installing Docker Desktop from AUR..."
    git clone https://aur.archlinux.org/docker-desktop.git
    cd docker-desktop
    makepkg -sri --noconfirm
    cd ..
    rm -rf docker-desktop

    git clone https://aur.archlinux.org/visual-studio-code-bin.git
    cd visual-studio-code-bin
    makepkg -sri --noconfirm
    cd ..
    rm -rf visual-studio-code-bin
else
    echo "You chose poorly..."
    exit 1
fi

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

# terminal setup

echo "Changing default shell to zsh"
sudo usermod -s $(which zsh) $USER

echo "Installing Hack Nerd Font for colorls icons"
rm -f ~/.local/share/fonts/*Hack*.ttf
wget -qO /tmp/Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
unzip -q -o /tmp/Hack.zip -d ~/.local/share/fonts/
rm /tmp/Hack.zip
fc-cache -f

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" #oh my zsh
# zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

sudo gem install colorls


git clone https://github.com/ThePrimeagen/tmux-sessionizer.git
mv -f tmux-sessionizer ~/tmux-sessionizer
mv -f .zshrc ~/.zshrc
