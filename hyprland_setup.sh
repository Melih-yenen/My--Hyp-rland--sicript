#!/bin/bash
set -e

# =============================================
# 🔹 Hyprland Full Setup v5.0 (Melih Edition)
# =============================================

LOG_FILE="$HOME/hyprland_setup_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🚀 Hyprland Full Setup v5.0 başlatıldı"
echo "📜 Log kaydı: $LOG_FILE"

# -------------------------------
# Gerekli Paketler
# -------------------------------
PKGS=(
  hyprland waybar mako wofi dolphin kitty brightnessctl pamixer playerctl
  ttf-jetbrains-mono-nerd power-profiles-daemon swww hyprlock
  pipewire wireplumber
)

echo "📦 Gerekli paketler yükleniyor..."
for pkg in "${PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "📦 $pkg kuruluyor..."
        sudo pacman -S --noconfirm "$pkg"
    else
        echo "✔ $pkg zaten yüklü"
    fi
done

# -------------------------------
# GPU Algılama
# -------------------------------
GPU_TYPE="unknown"
if lspci | grep -qi nvidia; then
    GPU_TYPE="nvidia"
elif lspci | grep -qi amd; then
    GPU_TYPE="amd"
elif lspci | grep -qi intel; then
    GPU_TYPE="intel"
fi
echo "🎮 GPU algılandı: $GPU_TYPE"

# -------------------------------
# NVIDIA Ek Paketleri
# -------------------------------
if [[ "$GPU_TYPE" == "nvidia" ]]; then
    echo "🟢 NVIDIA sürücüleri yükleniyor..."
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings egl-wayland
fi

# -------------------------------
# PipeWire Servisleri
# -------------------------------
echo "🔊 PipeWire servisleri etkinleştiriliyor..."
if systemctl --user list-unit-files | grep -q "pipewire.service"; then
    echo "🧠 Kullanıcı bazlı pipewire etkinleştiriliyor..."
    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
else
    echo "🧠 Sistem bazlı pipewire etkinleştiriliyor..."
    sudo systemctl enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
fi

sudo systemctl enable --now power-profiles-daemon.service || true

# -------------------------------
# Tema Seçimi
# -------------------------------
echo ""
echo "🎨 Tema seç (1-Nord, 2-Catppuccin, 3-Dracula)"
read -rp "Seçimin (1/2/3): " THEME
case $THEME in
    1) THEME_NAME="nord" ;;
    2) THEME_NAME="catppuccin" ;;
    3) THEME_NAME="dracula" ;;
    *) THEME_NAME="nord" ;;
esac
echo "✨ Seçilen tema: $THEME_NAME"

# -------------------------------
# Config Dizini + Yedekleme
# -------------------------------
CONFIG_DIRS=(hypr waybar mako wofi local/bin waybar/scripts)
for dir in "${CONFIG_DIRS[@]}"; do
    mkdir -p "$HOME/.config/$dir"
done

for dir in hypr waybar mako wofi; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$HOME/.config/${dir}_backup_$(date +%H%M%S)"
        echo "📦 $dir dizini yedeklendi."
    fi
done

# -------------------------------
# Hyprland Sürüm Tespiti
# -------------------------------
HYPR_VERSION=$(hyprctl version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
if [[ -z "$HYPR_VERSION" ]]; then
    HYPR_VERSION="0.5.0"
    echo "⚠️ Hyprland sürümü algılanamadı, varsayılan $HYPR_VERSION kullanılacak."
else
    echo "📦 Hyprland sürümü: $HYPR_VERSION"
fi

# -------------------------------
# DECORATION BLOĞU (Sürüm Uyumlu)
# -------------------------------
if [[ "$HYPR_VERSION" =~ ^0\.4[0-9] ]]; then
    DECORATION_BLOCK=$(cat <<EOF
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
    DECORATION_BLOCK=$(cat <<EOF
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

# -------------------------------
# Hyprland Config
# -------------------------------
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprland.conf <<EOF
# ======================================
# Hyprland Config - $THEME_NAME Teması
# ======================================

monitor=,preferred,auto,1
env = WLR_NO_HARDWARE_CURSORS,1

$( [[ "$GPU_TYPE" == "nvidia" ]] && echo "env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_DRM_DEVICES,/dev/dri/card0
env = WLR_EGL_NO_MODIFIERS,1" )

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
    col.active_border = rgba(88c0d0ff)
    col.inactive_border = rgba(4c566aff)
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

exec-once = hyprctl setcursor Bibata-Modern-Ice 24
exec-once = swww init && swww img ~/Resimler/wallpaper.jpg --transition-type fade
exec-once = waybar &
exec-once = mako &
EOF

# -------------------------------
# Power Menu Script
# -------------------------------
cat > ~/.local/bin/powermenu.sh <<'EOF'
#!/bin/bash
chosen=$(echo -e " Power Off\n Reboot\n Lock\n Logout" | wofi --dmenu --prompt "Power Menu")
case "$chosen" in
    " Power Off") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    " Lock") hyprlock ;;
    " Logout") hyprctl dispatch exit ;;
esac
EOF
chmod +x ~/.local/bin/powermenu.sh

echo ""
echo "✅ Hyprland Full Setup v5.0 başarıyla tamamlandı!"
echo "📜 Log dosyası: $LOG_FILE"
echo "💡 Yeniden oturum açarak Hyprland’in tadını çıkar hocam 🔥"
