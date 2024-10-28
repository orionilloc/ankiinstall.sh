#!/bin/bash
# This a simmple script meant to speed up the download and deployment of Anki on a new Linux machine.

# This unsightly piece of command substitution uses curl to find the latest version of Anki based upon repository tags found in the HTTP response (which seem to be robust and accurate for now). It takes way too long and there is certainly a better way. Whitespace and newline characters are removed so that output can be inserted into additional commands.
current_anki_release=$(curl -v  https://github.com/ankitects/anki/releases/latest 2>&1  | grep "location" | cut -d ' ' -f 3 | awk -F / '{print $NF}'| tr -d '\r')

# Ensures that Anki isn't already installed on this machine.
if [ -f usr/local/bin/anki ]; then
	echo "Anki already exists on this machine!" && exit 1
fi

# Installs dependencies for Anki.
sudo apt install libxcb-xinerama0 libxcb-cursor0 zstd

# Moves shell to the Downloads directory and grabs the latest Anki release via the wget utility.
cd ~/Downloads && wget https://github.com/ankitects/anki/releases/download/"$current_anki_release"/anki-"$current_anki_release"-linux-qt6.tar.zst

# Untars the file, changes directory to execute the installation shell script.
tar xaf Downloads/anki-"$current_anki_release"-linux-qt6.tar.zst && cd anki-"$current_anki_release"-linux-qt6 && sudo ./install.sh
