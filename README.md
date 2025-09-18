Hyprland Full Setup Script (CachyOS / NVIDIA)

This script installs and configures a complete Hyprland environment with Waybar, Mako, Wofi, and modern settings on a TR keyboard layout. It is designed for NVIDIA laptops on CachyOS/Arch Linux. It also includes autostart scripts, modern themes, and optional utilities like Dolphin and Kitty.

Features

Installs essential packages: Hyprland, Waybar, Mako, Wofi, Dolphin, Kitty, brightness and volume control utilities.

Resolves Bibata cursor theme conflicts automatically.

Sets  TR keyboard layout.

Configures Hyprland with modern decoration, blur, shadows, and animations.

Configures Mako notifications with a modern, clean style.

Configures Wofi app launcher with modern CSS styling.

Configures Waybar with modern theme and modules (clock, battery, audio, network, tray).

Autostart script for launching Mako and Waybar.

Prepares directories if not exist, overwriting configs if they do.

Installation
1.
Download the script 
2.
Make it executable:chmod +x hyprland_setup.sh
3.
Run the script:./hyprland_setup.sh
File Structure Created:
~/.config/hypr/hyprland.conf         # Hyprland configuration
~/.config/mako/config                # Mako notification config
~/.config/mako/style.css             # Mako CSS styling
~/.config/wofi/config                # Wofi launcher config
~/.config/wofi/style.css             # Wofi CSS styling
~/.config/waybar/config.jsonc        # Waybar config
~/.config/waybar/style.css           # Waybar CSS
~/.config/waybar/scripts/audio-anim.sh # Audio animation script (optional)
~/.config/autostart/startup.sh       # Autostart script for Hyprland components
Script Sections Explained 

System Packages Installation
Checks if the required packages are installed. Installs them if missing.

Bibata Cursor Conflict Resolution
Removes bibata-cursor-theme-bin if exists, and installs bibata-cursor-theme.

Config Directories Setup
Creates ~/.config/hypr, ~/.config/waybar, ~/.config/mako, ~/.config/wofi, and ~/.config/autostart directories.

Hyprland Config
Sets monitor, environment variables, input settings (TR keyboard), window gaps, borders, layout, decoration (blur, shadow), animations, and keybindings.

Mako Config and CSS
Sets fonts, colors, border, padding, margins, max visible notifications, and urgency styles.

Wofi Config and CSS
Configures launcher mode, terminal, search prompt, size, and style.

Waybar Config and CSS
Sets position, height, modules, and module formatting. Custom styles for workspaces, clock, battery, backlight, audio, network, and tray.

Audio Animation Script
Optional script to show audio playback animations in Waybar. (Make executable automatically.)

Autostart Script
Kills any previous notification daemons and starts Mako and Waybar.
