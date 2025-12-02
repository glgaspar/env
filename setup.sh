#!/bin/bash

echo "Select type of Linux: "
echo "Arch (a)"
echo "Debian (d)"
read os

if [["$os" == "d"]];then
    echo "Debian selected!" 
    echo "Starting installation..."

    sudo apt update
    sudo apt upgrade
    sudo apt install zsh -y
    sudo apt install tmux
    sudo bash ./docker_debian.sh
    wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo apt install ./vscode.deb
elif [["$os" == "a"]];then
    echo "Arch selected!"
    echo "Starting installation..."

    sudo pacman -Syu
    sudo pacman -S git
    sudo pacman -S zsh
    sudo pacman -S tmux
    wget https://download.docker.com/linux/static/stable/x86_64/docker-29.1.1.tgz -qO- | tar xvfz - docker/docker --strip-components=1
    sudo cp -rp ./docker /usr/local/bin/ && rm -r ./docker
    sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst
    git clone https://aur.archlinux.org/visual-studio-code-bin.git
    cd visual-studio-code-bin
    makepkg -sri
    pacman -S ghostty
else
    echo "You chose poorly..."
    exit 1
fi

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

# terminal setup

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" #oh my zsh
# zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/ThePrimeagen/tmux-sessionizer.git
mv -f tmux-sessionizer ~/tmux-sessionizer
mv -f .zshrc ~/.zshrc