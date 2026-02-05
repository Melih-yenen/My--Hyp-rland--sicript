# My‑Hyprland‑Script

## Overview

**My‑Hyprland‑Script** is a structured and reproducible setup script designed to deploy a complete **Hyprland Wayland desktop environment** on **Arch‑based Linux distributions**. The project focuses on **stability, consistency, and NVIDIA compatibility**, while keeping the system clean and easy to maintain.

This repository is intended for users who want a **ready‑to‑use Hyprland environment** without manually configuring every component from scratch.

---

## Target Platform

* Arch Linux & Arch‑based distributions (tested on CachyOS)
* NVIDIA GPUs (primary focus)
* Wayland session
* Users familiar with terminal‑based installation workflows

> ⚠️ The script is optimized for NVIDIA systems. AMD/Intel users may need to adjust driver‑specific sections.

---

## Key Features

* Automated Hyprland installation and configuration
* Preconfigured Waybar status bar
* Wofi application launcher
* Mako notification daemon
* Terminal and file manager integration
* Keyboard layout configuration (TR support)
* Organized `~/.config` structure
* Minimal, clean, and performance‑oriented setup

---

## Installation

Clone the repository and execute the setup script:

```bash
git clone https://github.com/Melih-yenen/My--Hyp-rland--sicript.git
cd My--Hyp-rland--sicript
chmod +x hyprland_setup.sh
./hyprland_setup.sh
```

The script will:

* Install required packages
* Configure Hyprland and related components
* Place configuration files in the appropriate directories

A system reboot is recommended after installation.

---

## Components Installed

The setup includes, but is not limited to:

* **Hyprland** – Wayland compositor
* **Waybar** – Status bar
* **Wofi** – Application launcher
* **Mako** – Notification system
* **Kitty** – Terminal emulator
* **Dolphin** – File manager

All components are configured to work together seamlessly.

---

## Repository Structure

```
My--Hyp-rland--sicript/
├── hyprland_setup.sh   # Main installation script
├── README.md           # Project documentation
├── LICENSE             # GPL‑3.0 license
└── config/             # Configuration files (if present)
```

---

## Customization

After installation, you can customize the environment by editing configuration files located in:

```
~/.config/hypr/
~/.config/waybar/
~/.config/wofi/
~/.config/mako/
```

Hyprland allows extensive customization for keybindings, animations, window rules, and monitors.

---

## License

This project is licensed under the **GNU General Public License v3.0 (GPL‑3.0)**.

You are free to use, modify, and distribute this project under the terms of the license.

---

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a new feature branch
3. Commit your changes with clear messages
4. Open a Pull Request

Please ensure changes are consistent with the project’s goals and coding style.

---

## Author

**Melih Yenen**
GitHub: [https://github.com/Melih-yenen](https://github.com/Melih-yenen)

---

## Disclaimer

This script modifies system configuration and installs packages automatically. Review the script before running it on a production system. Use at your own responsibility.

---

**Hyprland • Wayland • Clean • Minimal • Efficient**
