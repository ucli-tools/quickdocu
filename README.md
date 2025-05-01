# QuickDocu - Docusaurus Config Splitter

## Table of Contents
- [QuickDocu - Docusaurus Config Splitter](#quickdocu---docusaurus-config-splitter)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Installation](#installation)
    - [Option 1: Using Make (Recommended)](#option-1-using-make-recommended)
    - [Option 2: Manual Installation](#option-2-manual-installation)
  - [Usage](#usage)
    - [Using Make Commands](#using-make-commands)
    - [Direct Script Usage](#direct-script-usage)
    - [Commands](#commands)
  - [File Structure](#file-structure)
  - [How It Works](#how-it-works)
  - [Requirements](#requirements)
  - [Notes](#notes)
  - [License](#license)

---

## Introduction

**QuickDocu** is a Bash script designed to simplify the management of Docusaurus configuration files. It automatically splits a monolithic `docusaurus.config.ts` file into modular JSON components, making it easier to maintain and organize your Docusaurus project configuration.

---

## Features

- **Automated Configuration Extraction**: Extracts `navbar`, `footer`, and `main` configurations from `docusaurus.config.ts`.
- **Modular JSON Files**: Creates separate JSON files (`navbar.json`, `footer.json`, `main.json`) for better organization.
- **Preserves Original Functionality**: Generates a new `docusaurus.config.ts` that imports the modular JSON files while maintaining all original settings.
- **Easy Installation**: Supports system-wide installation for global usage.
- **User-Friendly**: Provides clear color-coded output for better readability.

---

## Installation

### Option 1: Using Make (Recommended)
```bash
git clone https://github.com/mik-tf/quickdocu.git
cd quickdocu
make build
```

### Option 2: Manual Installation
1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/mik-tf/quickdocu/main/quickdocu.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x quickdocu.sh
   ```
3. Install system-wide (requires `sudo`):
   ```bash
   sudo ./quickdocu.sh install
   ```

---

## Usage

### Using Make Commands
- **Install QuickDocu**:
  ```bash
  make build
  ```
- **Reinstall/Rebuild QuickDocu**:
  ```bash
  make rebuild
  ```
- **Uninstall QuickDocu**:
  ```bash
  make delete
  ```

### Direct Script Usage
- Run QuickDocu in any directory containing a `docusaurus.config.ts` file:
  ```bash
  quickdocu
  ```
- Alternatively, use the script directly without installation:
  ```bash
  ./quickdocu.sh
  ```

### Commands
- **Split Configuration**:
  ```bash
  quickdocu split
  ```
- **Install QuickDocu**:
  ```bash
  sudo quickdocu install
  ```
- **Uninstall QuickDocu**:
  ```bash
  sudo quickdocu uninstall
  ```
- **Display Help**:
  ```bash
  quickdocu help
  ```

---

## File Structure

After running QuickDocu, your project will have the following structure:

```
your-docusaurus-project/
├── docusaurus.config.ts         # New modular config file
├── docusaurus.config.ts.archive # Original config file (backup)
└── cfg/
    ├── navbar.json              # Navigation bar configuration
    ├── footer.json              # Footer configuration
    └── main.json                # Main site configuration
```

---

## How It Works

1. **Validation**: The script checks for the presence of `docusaurus.config.ts` in the current directory.
2. **Configuration Extraction**:
   - Extracts `navbar` configuration to `cfg/navbar.json`.
   - Extracts `footer` configuration to `cfg/footer.json`.
   - Extracts `main` configuration (title, tagline, favicon, etc.) to `cfg/main.json`.
3. **New Config File**: Generates a new `docusaurus.config.ts` that imports the modular JSON files.
4. **Backup**: Renames the original `docusaurus.config.ts` to `docusaurus.config.ts.archive`.

---

## Requirements

- **Node.js**: Required for parsing and extracting configuration.
- **Docusaurus Project**: A valid Docusaurus project with a `docusaurus.config.ts` file.
- **Make**: Optional, for using Makefile commands.
- **sudo Privileges**: Required for system-wide installation.

---

## Notes

- **Backup**: Always back up your original configuration file before running the script.
- **Custom Configurations**: If your `docusaurus.config.ts` contains custom sections, you may need to modify the script to handle them.
- **System-Wide Installation**: Requires `sudo` privileges for installation and uninstallation.

---

## License

This project is licensed under the **Apache 2.0 License**. See the [LICENSE](LICENSE) file for details.

---

For more information or to report issues, please visit the [GitHub repository](https://github.com/mik-tf/quickdocu).
