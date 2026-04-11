# Linux Environment Setup

This repository contains shell scripts to automate the installation and configuration of a personal development environment on either **Arch Linux** or **Debian-based** systems.

## Features

- **OS Support**: Interactive prompt to choose between Arch and Debian installation paths.
- **Core Utilities**: Installs essential terminal tools like `zsh` and `tmux`.
- **Development Tools**: Installs the LTS versions of Node.js, npm, and Golang.
- **Docker Setup**: Installs Docker, starts and enables the `docker.service`, and automatically adds the current user to the `docker` group.
- **Visual Studio Code**: 
  - *Debian*: Downloads and installs the official `.deb` package.
  - *Arch*: Clones and builds from the AUR.
- **Terminal Configuration**:
  - Installs Oh My Zsh.
  - Adds popular plugins: `zsh-autosuggestions` and `zsh-syntax-highlighting`.
  - Installs the Powerlevel10k theme.
  - Downloads and installs **Hack Nerd Font** for correct icon rendering.
  - Installs `colorls` (via RubyGems) for visually appealing directory listings.
- **Workflow Utilities**: Sets up ThePrimeagen's tmux-sessionizer.

## Prerequisites

Before running the setup, ensure you have the following files present in the same directory as `setup.sh`:

1. `docker_debian.sh`: A companion script required for installing Docker on Debian systems. I copied it from the docker site, look it up if you don't trust me.
2. `.zshrc`: Your custom Zsh configuration file. The script expects this to be present so it can move it to your home directory (`~/.zshrc`). The config I use is present in the repository, you may use it if you prefer.


## Usage

1. Open your terminal and navigate to the directory containing the scripts.
2. Make sure the scripts are executable:
   ```bash
   chmod +x setup.sh docker_debian.sh
   ```
3. Run the main setup script:
   ```bash
   ./setup.sh
   ```
4. Follow the interactive prompt to select your operating system:
   - Type `a` for Arch Linux
   - Type `d` for Debian

## Post-Installation

- **Docker**: You will need to log out and log back in (or restart your computer) for the `docker` group changes to take effect. This allows you to run Docker commands without `sudo`.
- **Terminal**: Ensure your terminal emulator's font is set to **Hack Nerd Font** (or set it as a fallback font) so the `colorls` icons display properly. Launch Zsh (or restart your terminal emulator) and the Powerlevel10k configuration wizard should automatically start if it hasn't been configured yet.

## Who is this for
- **Me**: I am currently trying out a lot of distros and am also too lazy to set them up the way I need manually.
- **Anyone else**: If you liked it, feel free to use. Just don't expect me to add stuff or not add stuff to it. If you want it your way, just fork it and change it.