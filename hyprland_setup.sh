#!/bin/bash
# Hyprland Full Setup v10.1 (Melih Edition - Multi-Distro & Pure Global)
# Developer: Melih Yenen (MelihOS) & AI Development Partner
# Usage: chmod +x hypr_v10.sh && ./hypr_v10.sh
set -euo pipefail
IFS=$'\n\t'

########################
# Distro Detection and Configuration
########################
DISTRO="unknown"
PKG_MAN="unknown"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        arch|artix|manjaro)
            DISTRO="arch"
            PKG_MAN="pacman"
            ;;
        ubuntu|debian|pop|mint)
            DISTRO="debian"
            PKG_MAN="apt"
            ;;
        fedora|rhel|centos)
            DISTRO="fedora"
            PKG_MAN="dnf"
            ;;
        *)
            # Fallback check using ID_LIKE for derivatives (e.g., elementaryOS)
            if echo "${ID_LIKE:-}" | grep -qi "debian"; then DISTRO="debian"; PKG_MAN="apt";
            elif echo "${ID_LIKE:-}" | grep -qi "arch"; then DISTRO="arch"; PKG_MAN="pacman";
            elif echo "${ID_LIKE:-}" | grep -qi "fedora"; then DISTRO="fedora"; PKG_MAN="dnf";
            fi
            ;;
    esac
fi

########################
# Localization (UI Strings & Messages)
########################
# Initial automatic language detection based on environment
SYS_LANG=${LANG[-2]:-en}
export LANG_MODE=$([[ "$SYS_LANG" == "tr" ]] && echo "tr" || echo "en")

# Dictionary containing all localized strings for the user interface
msg() {
    local key="$1"
    case "$LANG_MODE" in
        tr)
            case "$key" in
                title) echo "🌌 MelihOS Hyprland Yükleyici v10.1 (Multi-Distro) — Melih Yenen" ;;
                init_sys) echo "🧠 Akıllı yapılandırma sistemi ve optimizasyonlar başlatılıyor..." ;;
                log_file) echo "📜 Log dosyası" ;;
                lang_sel_title) echo "Language / Dil Seçimi:" ;;
                lang_sel_prompt) echo "Select language / Dil seçin [Mevcut: $LANG_MODE]" ;;
                distro_detect) echo "🐧 Algılanan Dağıtım Ailesi" ;;
                distro_err) echo "❌ Desteklenmeyen dağıtım! Bu betik Arch, Debian/Ubuntu ve Fedora destekler." ;;
                update_sys) echo "🔄 Sistem depoları güncelleniyor..." ;;
                install_yay) echo "AUR Yardımcısı (yay) bulunamadı. Kuruluyor..." ;;
                yay_success) echo "yay başarıyla kuruldu!" ;;
                chk_pkgs) echo "📦 Gerekli paketler kontrol ediliyor..." ;;
                install_list) echo "📦 Aşağıdaki paketler kurulacak" ;;
                pkgs_installed) echo "✔ Tüm temel paketler zaten yüklü" ;;
                gpu_detect) echo "🎮 GPU algılandı" ;;
                nv_warn) echo "🟢 NVIDIA sürücüleri kontrol ediliyor..." ;;
                nv_grub) echo "NVIDIA kullanıcıları için hatırlatma: GRUB parametrelerine 'nvidia-drm.modeset=1' eklemeyi unutmayın." ;;
                theme_prompt) echo "🎨 Tema seç (1-Nord, 2-Catppuccin Mocha, 3-Dracula, 4-Otomatik Rastgele)" ;;
                theme_choice) echo "Seçimin" ;;
                theme_selected) echo "✨ Seçilen tema" ;;
                backup_msg) echo "📦 Mevcut yapılandırma yedeklendi" ;;
                hypr_ver) echo "📦 Hyprland sürümü" ;;
                hypr_ver_err) echo "⚠️ Hyprland sürümü algılanamadı, varsayılan kullanılacak." ;;
                wp_warn) echo "📁 Klasörde duvar kağıdı bulunamadı. Düz renkli bir tane üretiliyor..." ;;
                write_conf) echo "📝 Hyprland konfigürasyonu optimize edilerek yazıldı" ;;
                lock_msg) echo "🔒 Şık hyprlock kilit ekranı oluşturuldu" ;;
                waybar_msg) echo "🎛️ Waybar konfigürasyonu modern ikonlarla güncellendi" ;;
                extra_prompt) echo "Ek araçları ve masaüstü portal bileşenlerini kurmak ister misiniz? (Tavsiye Edilir)" ;;
                extra_install) echo "📦 Ek paketler kuruluyor" ;;
                extra_ok) echo "✔ Tüm ek araçlar zaten yüklü." ;;
                sddm_prompt) echo "SDDM Giriş Yöneticisini sistem servisi olarak etkinleştirmek ister misiniz?" ;;
                sddm_warn) echo "SDDM zaten aktif veya şu an etkinleştirilemedi." ;;
                audio_msg) echo "🔊 Ses servisleri kullanıcı düzeyinde yapılandırılıyor..." ;;
                final_success) echo "✨ Hyprland v10.1 (Multi-Distro) kurulumu başarıyla tamamlandı hocam!" ;;
                final_reboot) echo "💡 Değişikliklerin tam oturması için bilgisayarı yeniden başlatmanı öneririm." ;;
                final_binds) echo "🔎 Kısayol Hatırlatıcı:" ;;
                bind_term) echo "➔  [SUPER + Return]  -> Terminal (Kitty)" ;;
                bind_menu) echo "➔  [SUPER + D]       -> Uygulama Menüsü (Wofi)" ;;
                bind_power) echo "➔  [SUPER + L]       -> Güç Menüsü (Çıkış/Kapatma)" ;;
                bind_close) echo "➔  [SUPER + Q]       -> Aktif Pencereyi Kapat" ;;
                lock_ph) echo "Şifreni gir Melih hocam..." ;;
                lock_welcome) echo "Hoş geldin hocam, sistem güvende." ;;
                powermenu_title) echo "Sistem Eylemi" ;;
                pm_lock) echo "🔒 Kilitle" ;;
                pm_reboot) echo "🔄 Yeniden Başlat" ;;
                pm_poweroff) echo "🛑 Kapat" ;;
                pm_logout) echo "🚪 Oturumu Kapat" ;;
                wb_muted) echo "🔇 Susturuldu" ;;
                wb_disconnected) echo "⚠ Bağlantı Yok" ;;
            esac
            ;;
        en|*)
            case "$key" in
                title) echo "🌌 MelihOS Hyprland Installer v10.1 (Multi-Distro) — Designed by Melih Yenen" ;;
                init_sys) echo "🧠 Smart configuration system and optimizations starting..." ;;
                log_file) echo "📜 Log file" ;;
                lang_sel_title) echo "Language Selection:" ;;
                lang_sel_prompt) echo "Select language [Current: $LANG_MODE]" ;;
                distro_detect) echo "🐧 Detected Distro Family" ;;
                distro_err) echo "❌ Unsupported distribution! This script supports Arch, Debian/Ubuntu, and Fedora." ;;
                update_sys) echo "🔄 Updating package repositories..." ;;
                install_yay) echo "AUR Helper (yay) not found. Installing..." ;;
                yay_success) echo "yay installed successfully!" ;;
                chk_pkgs) echo "📦 Checking required packages..." ;;
                install_list) echo "📦 The following packages will be installed" ;;
                pkgs_installed) echo "✔ All core packages are already installed" ;;
                gpu_detect) echo "🎮 GPU detected" ;;
                nv_warn) echo "🟢 Checking NVIDIA drivers..." ;;
                nv_grub) echo "Reminder for NVIDIA users: Do not forget to add 'nvidia-drm.modeset=1' to your GRUB parameters." ;;
                theme_prompt) echo "🎨 Choose Theme (1-Nord, 2-Catppuccin Mocha, 3-Dracula, 4-Auto Random)" ;;
                theme_choice) echo "Your choice" ;;
                theme_selected) echo "✨ Selected theme" ;;
                backup_msg) echo "📦 Existing configuration backed up to" ;;
                hypr_ver) echo "📦 Hyprland version" ;;
                hypr_ver_err) echo "⚠️ Hyprland version not detected, using default." ;;
                wp_warn) echo "📁 No wallpaper found in folder. Generating a solid color background..." ;;
                write_conf) echo "📝 Hyprland configuration optimized and written to" ;;
                lock_msg) echo "🔒 Sleek hyprlock screen configuration created at" ;;
                waybar_msg) echo "🎛️ Waybar configuration updated with modern icons at" ;;
                extra_prompt) echo "Do you want to install extra tools and desktop portal components? (Recommended)" ;;
                extra_install) echo "📦 Installing extra packages" ;;
                extra_ok) echo "✔ All extra tools are already installed." ;;
                sddm_prompt) echo "Do you want to enable SDDM Login Manager as a system service?" ;;
                sddm_warn) echo "SDDM is already active or could not be enabled right now." ;;
                audio_msg) echo "🔊 Configuring audio services at user level..." ;;
                final_success) echo "✨ Hyprland v10.1 (Multi-Distro) installation completed successfully!" ;;
                final_reboot) echo "💡 I recommend rebooting your system for changes to take full effect." ;;
                final_binds) echo "🔎 Keybindings Reminder:" ;;
                bind_term) echo "➔  [SUPER + Return]  -> Terminal (Kitty)" ;;
                bind_menu) echo "➔  [SUPER + D]       -> Application Menu (Wofi)" ;;
                bind_power) echo "➔  [SUPER + L]       -> Power Menu (Exit/Shutdown)" ;;
                bind_close) echo "➔  [SUPER + Q]       -> Close Active Window" ;;
                lock_ph) echo "Enter your password..." ;;
                lock_welcome) echo "Welcome back, system is secure." ;;
                powermenu_title) echo "System Action" ;;
                pm_lock) echo "🔒 Lock" ;;
                pm_reboot) echo "🔄 Reboot" ;;
                pm_poweroff) echo "🛑 Power Off" ;;
                pm_logout) echo "🚪 Log Out" ;;
                wb_muted) echo "🔇 Muted" ;;
                wb_disconnected) echo "⚠ Disconnected" ;;
            esac
            ;;
    esac
}

########################
# Logging and Color Definitions
########################
LOG_FILE="$HOME/hyprland_setup_v10_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

NC='\033[0m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Interactive Language Choice
echo -e "${CYAN}Language / Dil Seçimi:${NC}"
echo "1) English (en)"
echo "2) Türkçe (tr)"
read -rp "Select language / Dil seçin [Current: $LANG_MODE]: " lang_input || lang_input=""
if [[ "$lang_input" == "1" ]]; then LANG_MODE="en"; fi
if [[ "$lang_input" == "2" ]]; then LANG_MODE="tr"; fi

echo ""
echo -e "${CYAN}$(msg title)${NC}"
log_info "$(msg init_sys)"
log_info "$(msg log_file): $LOG_FILE"

# Stop script execution if distro is not recognized
if [ "$DISTRO" == "unknown" ]; then
    log_error "$(msg distro_err)"
    exit 1
fi
log_success "$(msg distro_detect): ${DISTRO^^} ($PKG_MAN)"

########################
# Helper Functions
########################
command_exists() { command -v "$1" &>/dev/null; }

# Abstraction for localized confirmation prompts (Yes/No vs Evet/Hayır)
confirm() {
  local prompt="$1"
  local yes_no=$([[ "$LANG_MODE" == "tr" ]] && echo "(e/h)" || echo "(y/n)")
  read -rp "$prompt $yes_no: " ans
  case "$ans" in
    e|E|y|Y) return 0 ;;
    *) return 1 ;;
  esac
}

safe_mkdir() {
  local dir="$1"
  mkdir -p "$dir"
  chmod 700 "$dir" 2>/dev/null || true
}

# Distro-agnostic package installer function
install_packages() {
    local pkgs_to_install=("$@")
    if [ ${#pkgs_to_install[@]} -eq 0 ]; then return 0; fi
    
    case "$PKG_MAN" in
        pacman)
            if command_exists yay; then
                yay -S --noconfirm "${pkgs_to_install[@]}"
            else
                sudo pacman -S --noconfirm "${pkgs_to_install[@]}"
            fi
            ;;
        apt)
            sudo apt-get update -y
            sudo apt-get install -y "${pkgs_to_install[@]}"
            ;;
        dnf)
            sudo dnf install -y "${pkgs_to_install[@]}"
            ;;
    esac
}

########################
# Package Name Mapping per Distribution
########################
# Resolves different naming conventions across Arch, Debian/Ubuntu, and Fedora
if [ "$DISTRO" == "arch" ]; then
    CORE_LIST=(hyprland waybar mako wofi dolphin kitty brightnessctl pamixer playerctl ttf-jetbrains-mono-nerd power-profiles-daemon swww hyprlock pipewire wireplumber pavucontrol polkit-gnome qt5-wayland qt6-wayland)
    EXTR_LIST=(grim slurp swappy network-manager-applet blueman fastfetch xdg-desktop-portal-hyprland btop sddm)
elif [ "$DISTRO" == "debian" ]; then
    CORE_LIST=(hyprland waybar mako-notifier wofi dolphin kitty brightnessctl pamixer playerctl fonts-font-awesome power-profiles-daemon swww hyprlock pipewire wireplumber pavucontrol polkit-gnome-1 qt5-wayland qt6-wayland)
    EXTR_LIST=(grim slurp swappy network-manager-gnome blueman fastfetch xdg-desktop-portal-hyprland btop sddm)
elif [ "$DISTRO" == "fedora" ]; then
    CORE_LIST=(hyprland waybar mako wofi dolphin kitty brightnessctl pamixer playerctl jetbrains-mono-fonts power-profiles-daemon swww hyprlock pipewire wireplumber pavucontrol polkit-gnome qt5-qtwayland qt6-qtwayland)
    EXTR_LIST=(grim slurp swappy network-manager-applet blueman fastfetch xdg-desktop-portal-hyprland btop sddm)
fi

########################
# AUR Helper Installation (Arch Specific)
########################
if [ "$DISTRO" == "arch" ] && ! command_exists yay; then
  log_warn "$(msg install_yay)"
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  log_success "$(msg yay_success)"
fi

########################
# Core Package Installation Phase
########################
log_info "$(msg chk_pkgs)"
to_install=()
for pkg in "${CORE_LIST[@]}"; do
  # Cross-distro package presence verification query
  if { [ "$PKG_MAN" == "pacman" ] && ! pacman -Qi "$pkg" &>/dev/null; } || \
     { [ "$PKG_MAN" == "apt" ] && ! dpkg -s "$pkg" &>/dev/null; } || \
     { [ "$PKG_MAN" == "dnf" ] && ! rpm -q "$pkg" &>/dev/null; }; then
       to_install+=("$pkg")
  fi
done

if [ ${#to_install[@]} -gt 0 ]; then
  log_info "$(msg install_list): ${to_install[*]}"
  install_packages "${to_install[@]}"
else
  log_success "$(msg pkgs_installed)"
fi

########################
# GPU Detection & Driver Optimization
########################
GPU_TYPE="unknown"
if lspci | grep -qi nvidia; then GPU_TYPE="nvidia";
elif lspci | grep -qi amd; then GPU_TYPE="amd";
elif lspci | grep -qi intel; then GPU_TYPE="intel"; fi
log_success "$(msg gpu_detect): $GPU_TYPE"

if [[ "$GPU_TYPE" == "nvidia" ]]; then
  log_warn "$(msg nv_warn)"
  if [ "$DISTRO" == "arch" ] && ! pacman -Qi nvidia &>/dev/null; then
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings egl-wayland
  elif [ "$DISTRO" == "debian" ]; then
    sudo apt-get install -y nvidia-driver-bin nvidia-visual-profiler || log_warn "NVIDIA drivers couldn't be auto-installed. Please check non-free repos."
  elif [ "$DISTRO" == "fedora" ]; then
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda || log_warn "NVIDIA drivers require RPM Fusion repo on Fedora."
  fi
  log_warn "$(msg nv_grub)"
fi

########################
# Theme Selection & Color Memory Configuration
########################
echo ""
echo -e "$(msg theme_prompt)"
read -rp "$(msg theme_choice) (1/2/3/4): " THEME_CHOICE || THEME_CHOICE=1

case $THEME_CHOICE in
  1) THEME_NAME="nord"; BAR_COLOR="#88c0d0"; ACCENT_COLOR="#5e81ac"; BG_COLOR="#2e3440"; TEXT_COLOR="#eceff4" ;;
  2) THEME_NAME="catppuccin"; BAR_COLOR="#cba6f7"; ACCENT_COLOR="#89b4fa"; BG_COLOR="#1e1e2e"; TEXT_COLOR="#cdd6f4" ;;
  3) THEME_NAME="dracula"; BAR_COLOR="#bd93f9"; ACCENT_COLOR="#ff79c6"; BG_COLOR="#282a36"; TEXT_COLOR="#f8f8f2" ;;
  4) RANDOM_COLOR() { printf '#%02x%02x%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)); }
     THEME_NAME="custom-random"; BAR_COLOR="$(RANDOM_COLOR)"; ACCENT_COLOR="$(RANDOM_COLOR)"; BG_COLOR="$(RANDOM_COLOR)"; TEXT_COLOR="#ffffff" ;;
  *) THEME_NAME="nord"; BAR_COLOR="#88c0d0"; ACCENT_COLOR="#5e81ac"; BG_COLOR="#2e3440"; TEXT_COLOR="#eceff4" ;;
esac
log_success "$(msg theme_selected): $THEME_NAME"

########################
# Config Directories & Automated Backups
########################
CONFIG_DIRS=(hypr waybar mako wofi local/bin hyprlock)
for dir in "${CONFIG_DIRS[@]}"; do safe_mkdir "$HOME/.config/$dir"; done

for dir in hypr waybar mako wofi hyprlock; do
  if [ -d "$HOME/.config/$dir" ] && [ "$(ls -A "$HOME/.config/$dir")" ]; then
    backup="$HOME/.config/${dir}_backup_$(date +%Y%m%d_%H%M%S)"
    cp -r "$HOME/.config/$dir" "$backup"
    log_info "$(msg backup_msg) -> $backup"
  fi
done

########################
# Wallpaper Management Setup
########################
WALLPAPER_DIR="$HOME/Resimler/Wallpapers"
safe_mkdir "$WALLPAPER_DIR"

shopt -s nullglob
images=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif})
shopt -u nullglob

if [ ${#images[@]} -eq 0 ]; then
  log_warn "$(msg wp_warn)"
  WALLPAPER="$WALLPAPER_DIR/default_wallpaper.png"
  if command_exists convert; then convert -size 1920x1080 xc:"$BG_COLOR" "$WALLPAPER"
  else touch "$WALLPAPER" || true; fi
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)
fi

########################
# Hyprland Main Configuration Writing
########################
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
cat > "$HYPR_CONF" <<EOF
monitor=,preferred,auto,1

exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1

env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland;xcb
env = GDK_BACKEND,wayland,x11

$( [[ "$GPU_TYPE" == "nvidia" ]] && cat <<'NV'
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
NV
)

input {
    kb_layout = $( [[ "$LANG_MODE" == "tr" ]] && echo "tr" || echo "us" )
    follow_mouse = 1
    touchpad { natural_scroll = yes; tap-to-click = yes; scroll_factor = 0.6; }
}

general {
    gaps_in = 5; gaps_out = 10; border_size = 2
    col.active_border = rgb(${BAR_COLOR//#/}) rgb(${ACCENT_COLOR//#/}) 45deg
    col.inactive_border = rgb(${BG_COLOR//#/})
    layout = dwindle
}

decoration {
    rounding = 12
    blur { enabled = yes; size = 8; passes = 2; new_optimizations = yes; }
    shadow { enabled = yes; range = 20; color = rgba(000000aa); }
}

animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 5, myBezier
    animation = windowsOut, 1, 5, default, popup 80%
    animation = border, 1, 10, default
    animation = fade, 1, 5, default
    animation = workspaces, 1, 5, default, slide
}

dwindle { pseudotile = yes; preserve_split = yes; }

bind = SUPER, Return, exec, kitty
bind = SUPER, D, exec, wofi --show drun
bind = SUPER, E, exec, dolphin
bind = SUPER, L, exec, bash \$HOME/.local/bin/powermenu.sh
bind = SUPER, Q, killactive,
bind = SUPER, F, togglefloating,
bind = SUPER, Space, fullscreen,
bind = SUPER, R, exec, hyprctl reload
bind = SUPER, Escape, exec, hyprctl dispatch exit

bind = SUPER, left, movefocus, l
bind = SUPER, right, movefocus, r
bind = SUPER, up, movefocus, u
bind = SUPER, down, movefocus, d

binde = , XF86MonBrightnessUp, exec, brightnessctl set +5%
binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
binde = , XF86AudioRaiseVolume, exec, pamixer -i 5
binde = , XF86AudioLowerVolume, exec, pamixer -d 5
bind = , XF86AudioMute, exec, pamixer -t

exec-once = swww-daemon || swww init
$( [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]] && echo "exec-once = swww img \"$WALLPAPER\" --transition-type fade" )
exec-once = waybar & mako & nm-applet --indicator & blueman-applet &
EOF

log_success "$(msg write_conf) -> $HYPR_CONF"

########################
# Powermenu Script & Hyprlock Configuration Generation
########################
safe_mkdir "$HOME/.local/bin"
cat > "$HOME/.local/bin/powermenu.sh" <<EOF
#!/bin/bash
chosen=\$(echo -e "$(msg pm_lock)\n$(msg pm_reboot)\n$(msg pm_poweroff)\n$(msg pm_logout)" | wofi --dmenu --dropdown-gap 10 --prompt "$(msg powermenu_title)")
case "\$chosen" in
    "$(msg pm_lock)") hyprlock ;;
    "$(msg pm_reboot)") systemctl reboot ;;
    "$(msg pm_poweroff)") systemctl poweroff ;;
    "$(msg pm_logout)") hyprctl dispatch exit ;;
esac
EOF
chmod +x "$HOME/.local/bin/powermenu.sh"

HYPRLOCK_CONF="$HOME/.config/hyprlock/hyprlock.conf"
cat > "$HYPRLOCK_CONF" <<EOF
background { monitor = ; path = ${WALLPAPER}; blur_passes = 3; blur_size = 7; noise = 0.0117; }
input-field {
    monitor = ; size = 250, 50; outline_thickness = 3; dots_size = 0.2; dots_spacing = 0.6; dots_center = true
    outer_color = rgb(${BAR_COLOR//#/}); inner_color = rgb(${BG_COLOR//#/}); font_color = rgb(${TEXT_COLOR//#/})
    fade_on_empty = false; placeholder_text = <i>$(msg lock_ph)</i>; position = 0, -50; halign = center; valign = center
}
label { monitor = ; text = cmd[update:1000] echo "\$(date +'%H:%M')"; color = rgb(${BAR_COLOR//#/}); font_size = 80; font_family = JetBrainsMono Nerd Font Bold; position = 0, 150; halign = center; valign = center; }
label { monitor = ; text = $(msg lock_welcome); color = rgb(${TEXT_COLOR//#/}); font_size = 16; font_family = JetBrainsMono Nerd Font; position = 0, 50; halign = center; valign = center; }
EOF
log_success "$(msg lock_msg) -> $HYPRLOCK_CONF"

########################
# Waybar Structural and Style Configurations
########################
WAYBAR_CONF_DIR="$HOME/.config/waybar"
cat > "$WAYBAR_CONF_DIR/config" <<EOF
{
    "layer": "top", "position": "top", "mod": "dock", "exclusive": true, "height": 30,
    "modules-left": ["hyprland/workspaces", "hyprland/mode"], "modules-center": ["clock"], "modules-right": ["cpu", "memory", "pulseaudio", "battery", "network", "tray"],
    "hyprland/workspaces": { "disable-scroll": true, "all-outputs": true, "on-click": "activate" },
    "clock": { "format": "🕒 {:%H:%M - %A, %d %B}" },
    "cpu": { "format": "  {usage}%" }, "memory": { "format": "  {used:0.1f}G" },
    "pulseaudio": { "format": "{icon} {volume}%", "format-muted": "$(msg wb_muted)", "format-icons": { "default": ["🔈", "🔉", "🔊"] }, "on-click": "pavucontrol" },
    "battery": { "states": { "warning": 30, "critical": 15 }, "format": "{icon} {capacity}%", "format-icons": ["🔋"] },
    "network": { "format-wifi": "  {essid}", "format-ethernet": "🔌 {ifname}", "format-disconnected": "$(msg wb_disconnected)" },
    "tray": { "icon-size": 16, "spacing": 10 }
}
EOF

cat > "$WAYBAR_CONF_DIR/style.css" <<EOF
* { border: none; border-radius: 0; font-family: "JetBrainsMono Nerd Font", monospace; font-size: 13px; }
window#waybar { background-color: rgba(${BG_COLOR//#/}, 0.85); border-bottom: 2px solid $BAR_COLOR; color: $TEXT_COLOR; }
#workspaces button { padding: 0 5px; background-color: transparent; color: $TEXT_COLOR; }
#workspaces button.focused { background-color: $ACCENT_COLOR; color: $BG_COLOR; }
#clock, #cpu, #memory, #pulseaudio, #battery, #network, #tray { padding: 0 10px; margin: 4px 2px; border-radius: 4px; background-color: rgba(255, 255, 255, 0.1); }
#clock { color: $BAR_COLOR; font-weight: bold; }
EOF
log_success "$(msg waybar_msg)"

########################
# Mako Notification Daemon Config
########################
MAKO_CONF="$HOME/.config/mako/config"
cat > "$MAKO_CONF" <<EOF
max-visible=3
font=JetBrainsMono Nerd Font 10
background-color=${BG_COLOR}dd
text-color=${TEXT_COLOR}
border-color=${BAR_COLOR}
border-size=2
border-radius=8
default-timeout=5000
EOF

########################
# Optional Extra Tools and Components Phase
########################
echo ""
if confirm "$(msg extra_prompt)"; then
  extras_to_install=()
  for pkg in "${EXTR_LIST[@]}"; do
    if { [ "$PKG_MAN" == "pacman" ] && ! pacman -Qi "$pkg" &>/dev/null; } || \
       { [ "$PKG_MAN" == "apt" ] && ! dpkg -s "$pkg" &>/dev/null; } || \
       { [ "$PKG_MAN" == "dnf" ] && ! rpm -q "$pkg" &>/dev/null; }; then
         extras_to_install+=("$pkg")
    fi
  done
  install_packages "${extras_to_install[@]}"
  
  if command_exists sddm; then
     if confirm "$(msg sddm_prompt)"; then sudo systemctl enable sddm.service --now || log_warn "$(msg sddm_warn)"; fi
  fi
fi

########################
# PipeWire User-Level Systemd Services Initialization
########################
log_info "$(msg audio_msg)"
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true

########################
# Final Banner and Keybindings Report
########################
echo -e "${CYAN}"
cat <<'ASCIIART'
 ███╗   ██╗██╗   ██╗██████╗ ██████╗  █████╗ ███╗   ██╗██████╗ 
 ████╗  ██║██║   ██║██╔══██╗██╔══██╗██╔══██║████╗  ██║██╔══██╗
 ██╔██╗ ██║██║   ██║██████╔╝██║  ██║███████║██╔██╗ ██║██║  ██║
 ██║╚██╗██║██║   ██║██╔══██╗██║  ██║██╔══██║██║╚██╗██║██║  ██║
 ██║ ╚████║╚██████╔╝██║  ██║██████╔╝██║  ██║██║ ╚████║██████╔╝
 ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
ASCIIART
echo -e "${NC}"
log_success "$(msg final_success)"
log_info "$(msg final_reboot)"
echo ""
log_info "$(msg final_binds)"
log_info "$(msg bind_term)"
log_info "$(msg bind_menu)"
log_info "$(msg bind_power)"
log_info "$(msg bind_close)"
echo ""
