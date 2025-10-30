#!/bin/bash
# Hyprland Full Setup v6 (Melih Edition)
# Hazırlayan: Melih Yenen (MelihOS)
# Kullanım: chmod +x hypr_v6.sh && ./hypr_v6.sh
set -euo pipefail
IFS=$'\n\t'

########################
# Log ve Environment
########################
LOG_FILE="$HOME/hyprland_setup_v6_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo -e "\n🌌 MelihOS Hyprland Installer v6 — Designed by Melih Yenen"
echo "🧠 Akıllı yapılandırma sistemi başlatılıyor..."
echo "📜 Log dosyası: $LOG_FILE"
echo ""

########################
# Yardımcı fonksiyonlar
########################
command_exists() { command -v "$1" &>/dev/null; }

confirm() {
  local prompt="$1"
  read -rp "$prompt (e/h): " ans
  case "$ans" in
    e|E) return 0 ;;
    *) return 1 ;;
  esac
}

safe_mkdir() {
  local dir="$1"
  mkdir -p "$dir"
  chmod 700 "$dir" 2>/dev/null || true
}

########################
# Paket listesi & kurulum
########################
PKGS=(
  hyprland waybar mako wofi dolphin kitty brightnessctl pamixer playerctl
  ttf-jetbrains-mono-nerd power-profiles-daemon swww hyprlock
  pipewire wireplumber pavucontrol
)

EXTRA_PKGS=(
  grim slurp swappy network-manager-applet blueman fastfetch
)

echo "📦 Gerekli paketler kontrol ediliyor..."
to_install=()
for pkg in "${PKGS[@]}"; do
  if ! pacman -Qi "$pkg" &>/dev/null; then
    to_install+=("$pkg")
  fi
done

if [ ${#to_install[@]} -gt 0 ]; then
  echo "📦 Aşağıdaki paketler kurulacak: ${to_install[*]}"
  sudo pacman -Syu --noconfirm "${to_install[@]}"
else
  echo "✔ Tüm temel paketler zaten yüklü"
fi

########################
# GPU Algılama & Sürücü
########################
GPU_TYPE="unknown"
if lspci | grep -qi nvidia; then
    GPU_TYPE="nvidia"
elif lspci | grep -qi amd; then
    GPU_TYPE="amd"
elif lspci | grep -qi intel; then
    GPU_TYPE="intel"
fi
echo "🎮 GPU algılandı: $GPU_TYPE"

if [[ "$GPU_TYPE" == "nvidia" ]]; then
  echo "🟢 NVIDIA sürücüleri kontrol ediliyor..."
  if ! pacman -Qi nvidia &>/dev/null; then
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings egl-wayland
  fi
fi

########################
# PipeWire / servislere başlat
########################
echo "🔊 PipeWire servisleri etkinleştiriliyor..."
if systemctl --user list-unit-files | grep -q "pipewire.service"; then
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
else
  sudo systemctl enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
fi
sudo systemctl enable --now power-profiles-daemon.service || true

########################
# Tema Seçimi ve Renk Hafızası
########################
echo ""
echo "🎨 Tema seç (1-Nord, 2-Catppuccin, 3-Dracula, 4-Otomatik rastgele)"
read -rp "Seçimin (1/2/3/4): " THEME_CHOICE || THEME_CHOICE=1

case $THEME_CHOICE in
  1) THEME_NAME="nord" ;;
  2) THEME_NAME="catppuccin" ;;
  3) THEME_NAME="dracula" ;;
  4) THEME_NAME="random" ;;
  *) THEME_NAME="nord" ;;
esac

case $THEME_NAME in
  nord)
    BAR_COLOR="#88c0d0"
    ACCENT_COLOR="#5e81ac"
    BG_COLOR="#2e3440"
    ;;
  catppuccin)
    BAR_COLOR="#b4befe"
    ACCENT_COLOR="#cba6f7"
    BG_COLOR="#1f1d2e"
    ;;
  dracula)
    BAR_COLOR="#bd93f9"
    ACCENT_COLOR="#ff79c6"
    BG_COLOR="#282a36"
    ;;
  random)
    RAND() { printf '#%02x%02x%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)); }
    BAR_COLOR="$(RAND)"; ACCENT_COLOR="$(RAND)"; BG_COLOR="$(RAND)"
    THEME_NAME="custom-random"
    ;;
esac

echo "✨ Seçilen tema: $THEME_NAME"
echo "🎯 Tema renkleri: BAR=$BAR_COLOR ACCENT=$ACCENT_COLOR BG=$BG_COLOR"

########################
# Config dizinleri & yedekleme
########################
CONFIG_DIRS=(hypr waybar mako wofi local/bin waybar/scripts hyprlock)
for dir in "${CONFIG_DIRS[@]}"; do
  safe_mkdir "$HOME/.config/$dir"
done

for dir in hypr waybar mako wofi; do
  if [ -d "$HOME/.config/$dir" ]; then
    backup="$HOME/.config/${dir}_backup_$(date +%Y%m%d_%H%M%S)"
    cp -r "$HOME/.config/$dir" "$backup"
    echo "📦 $dir yedeklendi -> $backup"
  fi
done

########################
# Hyprland sürüm tespiti
########################
HYPR_VERSION=""
if command_exists hyprctl; then
  HYPR_VERSION=$(hyprctl version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true)
fi
if [[ -z "$HYPR_VERSION" ]]; then
  HYPR_VERSION="0.5.0"
  echo "⚠️ Hyprland sürümü algılanamadı, varsayılan $HYPR_VERSION kullanılacak."
else
  echo "📦 Hyprland sürümü: $HYPR_VERSION"
fi

########################
# DECORATION BLOĞU
########################
if [[ "$HYPR_VERSION" =~ ^0\.4[0-9] ]]; then
    DECORATION_BLOCK=$(cat <<'EOF'
decoration {
    rounding 12
    blur 1
    blur_size 8
    blur_passes 2
    drop_shadow 1
}
EOF
)
else
    DECORATION_BLOCK=$(cat <<'EOF'
decoration {
    rounding = 12
    blur {
        enabled = yes
        size = 8
        passes = 2
    }
    shadow {
        enabled = yes
        range = 20
        color = rgba(000000aa)
    }
}
EOF
)
fi

########################
# WALLPAPER: klasör + rastgele seçim
########################
WALLPAPER_DIR="$HOME/Resimler/Wallpapers"
safe_mkdir "$WALLPAPER_DIR"

shopt -s nullglob
images=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif} 2>/dev/null || true)
shopt -u nullglob

if [ ${#images[@]} -eq 0 ]; then
  echo "📁 $WALLPAPER_DIR dizininde wallpaper bulunamadı."
  if confirm "Örnek bir wallpaper oluşturulsun mu?"; then
    if command_exists convert; then
      convert -size 1920x1080 xc:"$BG_COLOR" "$WALLPAPER_DIR/default_wallpaper.png"
      echo "🖼️ Örnek wallpaper oluşturuldu: $WALLPAPER_DIR/default_wallpaper.png"
      WALLPAPER="$WALLPAPER_DIR/default_wallpaper.png"
    else
      echo "⚠️ imagemagick (convert) yok — placeholder resmi oluşturulamadı. Lütfen manuel wallpaper ekle."
      WALLPAPER=""
    fi
  else
    WALLPAPER=""
  fi
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
fi

########################
# Hyprland config yazımı
########################
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
cat > "$HYPR_CONF" <<EOF
# ======================================
# Hyprland Config - $THEME_NAME Teması (Melih v6)
# Generated: $(date)
# ======================================

monitor=,preferred,auto,1
env = WLR_NO_HARDWARE_CURSORS,1

$( [[ "$GPU_TYPE" == "nvidia" ]] && cat <<'NV'
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_DRM_DEVICES,/dev/dri/card0
env = WLR_EGL_NO_MODIFIERS,1
NV
)

input {
    kb_layout = tr
    follow_mouse = 1
    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        scroll_factor = 0.6
        drag_lock = yes
    }
}

general {
    gaps_in = 6
    gaps_out = 15
    border_size = 2
    col.active_border = $BAR_COLOR
    col.inactive_border = $BG_COLOR
    layout = dwindle
}

$DECORATION_BLOCK

animations {
    enabled = yes
    animation = windows,1,7,default
    animation = fade,1,7,default
    animation = workspaces,1,6,default
}

bind = SUPER, Return, exec, kitty
bind = SUPER, D, exec, wofi --show drun
bind = SUPER, E, exec, dolphin
bind = SUPER, L, exec, ~/.local/bin/powermenu.sh
bind = SUPER, Q, killactive,
bind = SUPER, F, togglefloating,
bind = SUPER, R, exec, hyprctl reload
bind = SUPER, Escape, exec, hyprctl dispatch exit

bind = XF86MonBrightnessUp, exec, brightnessctl set +10%
bind = XF86MonBrightnessDown, exec, brightnessctl set 10%-
bind = XF86AudioRaiseVolume, exec, pamixer -i 5
bind = XF86AudioLowerVolume, exec, pamixer -d 5
bind = XF86AudioMute, exec, pamixer -t

exec-once = hyprctl setcursor Bibata-Modern-Ice 24
EOF

if [[ -n "$WALLPAPER" ]]; then
  echo "exec-once = swww init && swww img \"$WALLPAPER\" --transition-type fade" >> "$HYPR_CONF"
fi

cat >> "$HYPR_CONF" <<EOF
exec-once = waybar &
exec-once = mako &
EOF

echo "📝 Hyprland konfig yazıldı -> $HYPR_CONF"

########################
# powermenu.sh
########################
safe_mkdir "$HOME/.local/bin"
cat > "$HOME/.local/bin/powermenu.sh" <<'EOF'
#!/bin/bash
chosen=$(echo -e " Power Off\n Reboot\n Lock\n Logout" | wofi --dmenu --prompt "Power Menu")
case "$chosen" in
    " Power Off") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Lock") hyprlock ;;
    " Logout") hyprctl dispatch exit ;;
esac
EOF
chmod +x "$HOME/.local/bin/powermenu.sh"
echo "🔌 Power menu script oluşturuldu -> ~/.local/bin/powermenu.sh"

########################
# hyprlock konfig
########################
HYPRLOCK_CONF="$HOME/.config/hyprlock/hyprlock.conf"
cat > "$HYPRLOCK_CONF" <<EOF
# Hyprlock - Melih v6
background {
    path = ${WALLPAPER:-$HOME/Resimler/lockscreen.jpg}
    blur_passes = 2
}
text = "🔒 Kilitli — Hoş geldin hocam"
font = "JetBrainsMono Nerd Font 14"
EOF
echo "🔒 hyprlock konfig oluşturuldu -> $HYPRLOCK_CONF"

########################
# Waybar config & style
########################
WAYBAR_CONF_DIR="$HOME/.config/waybar"
safe_mkdir "$WAYBAR_CONF_DIR"
cat > "$WAYBAR_CONF_DIR/config" <<EOF
{
  "layer": "top",
  "position": "top",
  "modules-left": ["sway/workspaces", "sway/mode"],
  "modules-center": ["custom/clock"],
  "modules-right": ["pulseaudio", "battery", "cpu", "memory", "network"]
}
EOF

cat > "$WAYBAR_CONF_DIR/style.css" <<EOF
* {
    font-family: "JetBrains Mono", "JetBrainsMono Nerd Font", monospace;
    font-size: 12px;
}
window#waybar {
    background: rgba(30,30,46,0.7);
    color: $BAR_COLOR;
}
#clock {
    color: $ACCENT_COLOR;
    font-weight: 600;
}
.module {
    padding: 6px;
    min-height: 24px;
}
EOF

safe_mkdir "$HOME/.config/waybar/scripts"
cat > "$HOME/.config/waybar/scripts/clock" <<'EOF'
#!/bin/bash
date +"%a %d %b %H:%M"
EOF
chmod +x "$HOME/.config/waybar/scripts/clock"

echo "🎛️ Waybar konfig + stil oluşturuldu -> $WAYBAR_CONF_DIR"

########################
# Mako config (basit)
########################
MAKO_CONF="$HOME/.config/mako/config"
safe_mkdir "$(dirname "$MAKO_CONF")"
cat > "$MAKO_CONF" <<EOF
# Mako notifications - Melih v6
geometry = "300x"
timeout = 5000
max-visible = 3
font = "JetBrains Mono 11"
EOF
echo "🔔 Mako konfig oluşturuldu -> $MAKO_CONF"

########################
# Ek araçlar kurulumu (opsiyonel)
########################
echo ""
if confirm "Ek araçları (grim/slurp/swappy/network-manager-applet/blueman/fastfetch) kurmak ister misin?"; then
  extras_to_install=()
  for pkg in "${EXTRA_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      extras_to_install+=("$pkg")
    fi
  done
  if [ ${#extras_to_install[@]} -gt 0 ]; then
    echo "📦 Ek paketler kuruluyor: ${extras_to_install[*]}"
    sudo pacman -S --noconfirm "${extras_to_install[@]}"
  else
    echo "✔ Ek araçlar zaten yüklü"
  fi
fi

########################
# Sistem servisleri (kullanıcı bazlı)
########################
if systemctl --user list-unit-files | grep -q "pipewire.service"; then
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
fi

########################
# Final: ASCII art ve mesaj
########################
echo ""
cat <<'ASCIIART'
 ███╗   ██╗██╗   ██╗██████╗ ██████╗  █████╗ ███╗   ██╗██████╗ 
 ████╗  ██║██║   ██║██╔══██╗██╔══██╗██╔══██║████╗  ██║██╔══██╗
 ██╔██╗ ██║██║   ██║██████╔╝██║  ██║███████║██╔██╗ ██║██║  ██║
 ██║╚██╗██║██║   ██║██╔══██╗██║  ██║██╔══██║██║╚██╗██║██║  ██║
 ██║ ╚████║╚██████╔╝██║  ██║██████╔╝██║  ██║██║ ╚████║██████╔╝
 ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
ASCIIART

echo "✨ Hyprland v6 Melih Edition kurulumu tamamlandı hocam!"
echo "📜 Log dosyası: $LOG_FILE"
echo "💡 Sistemi yeniden oturum açarak veya Hyprland'i yeniden başlatarak (hyprctl reload) değişiklikleri uygulayabilirsin."
echo ""
echo "🔎 Notlar:"
echo "- Waybar stil -> ~/.config/waybar/style.css"
echo "- Hyprland conf -> $HYPR_CONF"
echo "- hyprlock conf -> $HYPRLOCK_CONF"
echo "- powermenu -> ~/.local/bin/powermenu.sh"
echo ""
