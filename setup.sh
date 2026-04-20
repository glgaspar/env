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
    sudo apt install -y tmux fontconfig wget unzip curl

    echo "Installing latest Go..."
    GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1 | tr -d '\r')
    wget -qO /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
    rm -f /tmp/go.tar.gz

    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    sudo bash ./docker_debian.sh
    wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo apt install ./vscode.deb
    sudo apt install ruby-full

elif [[ "$os" == "a" ]];then
    echo "Arch selected!"
    echo "Starting installation..."

    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel git zsh tmux ruby ghostty fontconfig wget unzip nodejs-lts-krypton npm go

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

echo "Are you using Grub? (y/n)"
read grub
if [[ "$grub" == "y" ]]; then
    git clone https://github.com/vinceliuice/grub2-themes.git
    cd grub2-themes
    sudo ./install.sh -b -t tela vimix
    cd ..
    rm -rf grub2-themes
fi

echo "Do you want to install the latest version of Neovim? (y/n)"
read nvim
if [[ "$nvim" == "y" ]]; then
    if [[ "$os" == "d" ]]; then
        sudo apt install -y neovim
    elif [[ "$os" == "a" ]]; then
        sudo pacman -S --needed --noconfirm neovim
    fi
fi

echo "Do you want to install the latest version of Lazygit? (y/n)"
read lazygit
if [[ "$lazygit" == "y" ]]; then
    if [[ "$os" == "d" ]]; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin/
        rm lazygit.tar.gz

    elif [[ "$os" == "a" ]]; then
        sudo pacman -S lazygit
    fi
fi

echo "Installation complete! Please restart your terminal to apply changes."