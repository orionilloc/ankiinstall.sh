#!/bin/bash
# This a simmple script meant to speed up the download and deployment of Anki on a new Linux machine.

# This unsightly piece of command substitution uses curl to find the latest version of Anki based upon repository tags found in the HTTP response (which seem to be robust and accurate for now). It takes way too long and there is certainly a better way. Whitespace and newline characters are removed so that output can be inserted into additional commands.
current_anki_release=$(curl -v  https://github.com/ankitects/anki/releases/latest 2>&1  | grep "location" | cut -d ' ' -f 3 | awk -F / '{print $NF}'| tr -d '\r')

# Ensures that Anki isn't already installed on this machine.
if command -v anki &> /dev/null; then
    echo "Anki is already installed on this machine!"
fi

# Installs dependencies based on the distribution.
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            sudo apt update && sudo apt install -y libxcb-xinerama0 libxcb-cursor0 zstd
            ;;
        fedora)
            sudo dnf install -y libxcb-xinerama0 libxcb-cursor0 zstd
            ;;
        arch)
            sudo pacman -Syu --noconfirm libxcb xcb-util-cursor zstd
            ;;
        *)
            echo "Unsupported distribution found: $ID"
            ;;
    esac
else
    echo "Unable to detect the OS. Please install dependencies manually."
fi

# Moves shell to the Downloads directory and grabs the latest Anki release.
cd ~/Downloads && wget https://github.com/ankitects/anki/releases/download/"$current_anki_release"/anki-"$current_anki_release"-linux-qt6.tar.zst

# Untars the file, changes directory to installation files, executes the installation shell script.
tar xaf anki-"$current_anki_release"-linux-qt6.tar.zst && cd anki-"$current_anki_release"-linux-qt6 && sudo ./install.sh

echo "Anki installation complete!"
