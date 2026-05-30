#!/usr/bin/env bash

# Command substitution using curl to query for the latest version, grabbing major/minor release from the "tag_name" value
current_anki_release=$(curl -s https://api.github.com/repos/ankitects/anki/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | cut -d '.' -f 1,2)
  
# Ensure that Anki isn't already installed
if command -v anki &> /dev/null; then
    echo "Anki is already installed on this machine!"
    exit 1
fi

# Install dependencies for Anki
echo "Installing dependencies..."
sudo apt update && sudo apt install -y libxcb-xinerama0 libxcb-cursor0 zstd
if [[ $? -ne 0 ]]; then
    echo "Failed to install dependencies."
    exit 2
fi

# Move shell to the invoked user's ~/Downloads directory and grabs the latest Anki release with the wget utility
echo "Downloading the latest Anki release..."
cd ~/Downloads
wget https://github.com/ankitects/anki/releases/download/"$current_anki_release"/anki-launcher-"$current_anki_release"-linux.tar.zst
if [[ $? -ne 0 ]]; then
    echo "Failed to download Anki. Please check your network connection and try again."
    exit 2
fi

# Check if the download was successful
if [[ ! -f anki-launcher-"$current_anki_release"-linux.tar.zst ]]; then
    echo "Downloaded file not found."
    exit 2
fi

# Untar the file and execute the installation shell script
echo "Extracting Anki and running the installation script..."
tar xaf anki-launcher-"$current_anki_release"-linux.tar.zst
if [[ $? -ne 0 ]]; then
    echo "Failed to extract the Anki archive."
    exit 2
fi

cd anki-launcher-"$current_anki_release"-linux

# Run the installation script if it exists
if [[ -f install.sh ]]; then
    sudo ./install.sh
    if [[ $? -ne 0 ]]; then
        echo "Installation failed."
        exit 2
    fi
    echo "Anki installation is now complete!"
else
    echo "Installation script not found."
    exit 2
fi
