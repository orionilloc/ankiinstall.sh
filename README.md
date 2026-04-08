## ankiinstall.sh

This Bash script automates the end-to-end process of installing the latest version of **Anki** on a Debian-based Linux system (like Ubuntu or Debian). It handles dependency resolution, version fetching, and execution of the official installation binaries.

---

### Features

* **Dynamic Versioning:** Uses `curl` to scrape the GitHub API for the most recent stable release tag, ensuring you don't have to manually update the download URL.
* **Dependency Management:** Automatically installs required system libraries (`libxcb`, `zstd`, etc.) via `apt` to ensure the Qt6 interface runs correctly.
* **Pre-installation Checks:** Verifies if Anki is already present on the system to prevent redundant or conflicting installations.
* **Error Handling:** Includes exit points at every major step (Download, Extraction, Installation) to provide feedback if a network or permission error occurs.
* **Clean Workflow:** Downloads, extracts, and executes the official `install.sh` from the Anki archive in a single pass.

---

### Prerequisites

* **Operating System:** Debian, Ubuntu, or any derivative using the `apt` package manager.
* **Utilities:** `curl`, `wget`, and `tar` (usually pre-installed).
* **Privileges:** `sudo` access is required for installing dependencies and the final application binary.

---

### Usage

1.  **Download or create the script:**
    Save the code to a file named `install_anki.sh`.

2.  **Make it executable:**
    ```bash
    chmod +x install_anki.sh
    ```

3.  **Run the script:**
    ```bash
    ./install_anki.sh
    ```

---

### Installation Workflow

The script follows these logical steps:

1.  **Version Check:** Fetches the latest release tag from GitHub.
2.  **Duplicate Check:** Confirms the `anki` command is not already in your `$PATH`.
3.  **Apt Update:** Installs `libxcb-xinerama0`, `libxcb-cursor0`, and `zstd`.
4.  **Download:** Pulls the `.tar.zst` archive into your `~/Downloads` folder.
5.  **Extraction:** Unpacks the Zstandard-compressed archive.
6.  **Finalize:** Navigates into the extracted folder and runs the official `sudo ./install.sh`.

---

> [!NOTE]
> This script is designed for the **Qt6** version of Anki. If your hardware requires the older Qt5 version for compatibility reasons, the download URL inside the script would need to be adjusted accordingly.
