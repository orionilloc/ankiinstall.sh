#!/bin/bash
# This is a simple script meant to speed up the download and deployment of Anki on a new Linux machine.

# This unsightly piece of command substitution uses curl to find the latest version of Anki based upon repository tags found in the HTTP response (which seem to be robust and accurate for now). It takes way too long, and there is certainly a better way. Whitespace and newline characters are removed so that output can be inserted into additional commands.
current_anki_release=$(curl -s https://github.com/ankitects/anki/releases/latest 2>&1 | grep "location" | cut -d ' ' -f 3 | awk -F / '{print $NF}' | tr -d '\r')

# Ensures that Anki isn't already installed on this machine.
if command -v anki &> /dev/null; then
    echo "Anki is already installed on this machine!"
    exit
fi

# Installs dependencies for Anki.
echo "Installing dependencies..."
sudo apt update && sudo apt install -y libxcb-xinerama0 libxcb-cursor0 zstd
if [[ $? -ne 0 ]]; then
    echo "Failed to install dependencies."
    exit
fi

# Moves shell to the Downloads directory and grabs the latest Anki release with the wget utility.
echo "Downloading the latest Anki release..."
cd ~/Downloads
wget https://github.com/ankitects/anki/releases/download/"$current_anki_release"/anki-"$current_anki_release"-linux-qt6.tar.zst
if [[ $? -ne 0 ]]; then
    echo "Failed to download Anki. Please check your network connection and try again."
    exit
fi

# Check if the download was successful
if [[ ! -f anki-"$current_anki_release"-linux-qt6.tar.zst ]]; then
    echo "Downloaded file not found."
    exit
fi

# Untar the file and execute the installation shell script.
echo "Extracting Anki and running the installation script..."
tar xaf anki-"$current_anki_release"-linux-qt6.tar.zst
if [[ $? -ne 0 ]]; then
    echo "Failed to extract the Anki archive."
    exit
fi

cd anki-"$current_anki_release"-linux-qt6

# Run the installation script if it exists
if [[ -f install.sh ]]; then
    sudo ./install.sh
    if [[ $? -ne 0 ]]; then
        echo "Installation failed."
        exit
    fi
    echo "Anki installation complete!"
else
    echo "Installation script not found."
    exit
fi
