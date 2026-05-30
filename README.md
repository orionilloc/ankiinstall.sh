## ankiinstall.sh

This Bash script automates the end-to-end process of installing the latest version of **Anki** on a Debian-based Linux system (like Ubuntu or Debian). It handles dependency resolution, version fetching, and execution of the official installation binaries.

---

### Features

- **Dynamic Versioning:** Queries the GitHub API for the latest release tag, extracting only the major.minor version (e.g. `25.09`) to match the launcher archive naming convention.
- **Dependency Management:** Automatically installs required system libraries (`libxcb`, `zstd`, etc.) via `apt` to ensure the Qt6 interface runs correctly.
- **Pre-installation Checks:** Verifies if Anki is already present on the system to prevent redundant or conflicting installations.
- **Error Handling:** Includes exit codes at every major step (dependency installation, download, extraction, installation) to provide clear feedback if something goes wrong.
- **Clean Workflow:** Downloads, extracts, and executes the official `install.sh` from the Anki launcher archive in a single pass.

---

### Prerequisites

- **Operating System:** Debian, Ubuntu, or any derivative using the `apt` package manager.
- **Utilities:** `curl`, `wget`, and `tar` (usually pre-installed).
- **Privileges:** `sudo` access is required for installing dependencies and the final application binary.

---

### Usage

1. **Download or clone the script:**

```bash
git clone https://github.com/orionilloc/ankiinstall.sh.git
```

2. **Make it executable:**

```bash
chmod +x ankiinstall.sh
```

3. **Run the script:**

```bash
./ankiinstall.sh
```

---

### Installation Workflow

1. **Version Check:** Queries the GitHub API for the latest release tag and trims it to major.minor.
2. **Duplicate Check:** Confirms the `anki` command is not already in your `$PATH`.
3. **Dependency Install:** Installs `libxcb-xinerama0`, `libxcb-cursor0`, and `zstd` via `apt`.
4. **Download:** Pulls the launcher `.tar.zst` archive into `~/Downloads`.
5. **Extraction:** Unpacks the Zstandard-compressed archive.
6. **Finalize:** Navigates into the extracted directory and runs the official `sudo ./install.sh`.
