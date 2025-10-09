#!/bin/bash
set -e

echo "🔹 Hyprland Full Setup v2 (Waybar + Mako + Wofi + Power Menu + TR Keyboard + NVIDIA)"

# -------------------------------
# Gerekli Paketler
# -------------------------------
PKGS=(
  hyprland waybar mako wofi dolphin kitty brightnessctl pamixer playerctl
  ttf-jetbrains-mono-nerd nvidia nvidia-utils nvidia-settings egl-wayland
  swww hyprlock power-profiles-daemon
)

for pkg in "${PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "📦 $pkg kuruluyor..."
        sudo pacman -S --noconfirm "$pkg"
    else
        echo "✔ $pkg zaten yüklü"
    fi
done

# Bibata çakışması
if pacman -Qi bibata-cursor-theme-bin &>/dev/null; then
    echo "⚠ bibata-cursor-theme-bin bulundu, kaldırılıyor..."
    sudo pacman -R --noconfirm bibata-cursor-theme-bin
fi
if ! pacman -Qi bibata-cursor-theme &>/dev/null; then
    yay -S --noconfirm bibata-cursor-theme
fi

# -------------------------------
# Diziler
# -------------------------------
mkdir -p ~/.config/{hypr,waybar,mako,wofi,autostart,waybar/scripts,local/bin}

# -------------------------------
# Hyprland Config
# -------------------------------
cat > ~/.config/hypr/hyprland.conf <<'EOF'
monitor=,preferred,auto,1
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_DRM_DEVICES,/dev/dri/card0
env = WLR_EGL_NO_MODIFIERS,1

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
    gaps_in = 5
    gaps_out = 15
    border_size = 2
    col.active_border = rgba(88c0d0ff)
    col.inactive_border = rgba(4c566aff)
    layout = dwindle
    allow_tearing = false
}

decoration {
    rounding = 12
    blur {
        enabled = yes
        size = 8
        passes = 2
        ignore_opacity = true
    }
    shadow {
        enabled = yes
        range = 20
        render_power = 3
        color = rgba(000000aa)
    }
}

animations {
    enabled = yes
    bezier = ease,0.4,0.02,0.26,1
    animation = windows,1,7,ease
    animation = border,1,10,ease
    animation = fade,1,7,ease
    animation = workspaces,1,6,ease
}

bind = ,XF86MonBrightnessUp,exec,brightnessctl set +10%
bind = ,XF86MonBrightnessDown,exec,brightnessctl set 10%-
bind = ,XF86AudioRaiseVolume,exec,pamixer -i 5
bind = ,XF86AudioLowerVolume,exec,pamixer -d 5
bind = ,XF86AudioMute,exec,pamixer -t

bind = SUPER, Return, exec, kitty
bind = SUPER, D, exec, wofi --show drun
bind = SUPER, Q, killactive,
bind = SUPER, F, togglefloating,
bind = SUPER, E, exec, dolphin
bind = SUPER, V, exec, pavucontrol
bind = SUPER, B, exec, firefox
bind = SUPER, R, exec, hyprctl reload
bind = SUPER, Escape, exec, hyprctl dispatch exit
bind = SUPER, L, exec, ~/.local/bin/powermenu.sh

bind = SUPER,1,workspace,1
bind = SUPER,2,workspace,2
bind = SUPER,3,workspace,3
bind = SUPER,4,workspace,4
bind = SUPER,5,workspace,5

exec-once = hyprctl setcursor Bibata-Modern-Ice 24
exec-once = brightnessctl set 50%
exec-once = ~/.config/autostart/startup.sh
exec-once = tlp start
exec-once = powerprofilesctl set balanced
exec-once = swww init && swww img ~/Resimler/wallpaper.jpg --transition-type fade
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

# -------------------------------
# Audio Animation Script
# -------------------------------
cat > ~/.config/waybar/scripts/audio-anim.sh <<'EOF'
#!/bin/bash
while true; do
    if playerctl status 2>/dev/null | grep -q "Playing"; then
        echo '{"text": "󰕾 ~~~", "tooltip": "Playing"}'
    else
        echo '{"text": "󰖁", "tooltip": "Muted"}'
    fi
    sleep 1
done
EOF
chmod +x ~/.config/waybar/scripts/audio-anim.sh

# -------------------------------
# Mako Config
# -------------------------------
cat > ~/.config/mako/config <<'EOF'
font=JetBrainsMono Nerd Font 12
background-color=#2e3440cc
text-color=#eceff4
border-color=#81a1c1
border-radius=14
border-size=2
padding=12
margin=20
width=360
height=120
max-visible=5
default-timeout=6000
icons=1
max-icon-size=48

[app-name]
text-color=#88c0d0

[urgency=high]
background-color=#bf616acc
text-color=#eceff4
border-color=#bf616a
default-timeout=0
EOF

# -------------------------------
# Wofi Config
# -------------------------------
cat > ~/.config/wofi/config <<'EOF'
show=drun
term=kitty
prompt=Search...
hide_scroll=true
insensitive=true
width=45%
height=55%
EOF

cat > ~/.config/wofi/style.css <<'EOF'
window {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
    background-color: rgba(46,52,64,0.95);
    color: #eceff4;
    border-radius: 14px;
    border: 2px solid rgba(129,161,193,0.8);
}

#entry {
    padding: 6px 10px;
    border-radius: 8px;
}

#entry:selected {
    background-color: #81a1c1;
    color: #2e3440;
}
EOF

# -------------------------------
# Waybar Config
# -------------------------------
cat > ~/.config/waybar/config.jsonc <<'EOF'
{
  "layer": "top",
  "position": "top",
  "height": 34,
  "modules-left": ["hyprland/workspaces", "hyprland/window"],
  "modules-center": ["clock"],
  "modules-right": ["custom/audio", "pulseaudio", "backlight", "battery", "network", "tray"],

  "custom/audio": {
    "format": "{}",
    "exec": "~/.config/waybar/scripts/audio-anim.sh",
    "return-type": "json",
    "interval": 1
  },

  "clock": { "format": " {:%H:%M}   {:%d.%m.%Y}" },
  "battery": { "format": "{icon} {capacity}%", "format-icons": ["","","","",""] },
  "backlight": { "format": " {percent}%" },
  "pulseaudio": { "format": "{icon} {volume}%", "format-muted": " 0%", "format-icons": {"default":["",""]} },
  "network": { "format-wifi": " {essid}", "format-ethernet": " {ifname}", "format-disconnected": "" }
}
EOF

cat > ~/.config/waybar/style.css <<'EOF'
* {
  font-family: "JetBrainsMono Nerd Font", monospace;
  font-size: 13px;
}
window#waybar {
  background: rgba(46,52,64,0.75);
  backdrop-filter: blur(6px);
  color: #eceff4;
  border-bottom: 1px solid #3b4252;
  transition: background 0.3s ease;
}
#workspaces button { padding: 0 8px; color: #88c0d0; }
#workspaces button.focused { background-color: #81a1c1; border-radius: 10px; color: #2e3440; }
#clock,#battery,#backlight,#pulseaudio,#network,#tray,#custom-audio { padding: 0 10px; }
EOF

# -------------------------------
# Autostart
# -------------------------------
cat > ~/.config/autostart/startup.sh <<'EOF'
#!/bin/bash
killall mako waybar dunst xfce4-notifyd || true
mako &
waybar &
EOF
chmod +x ~/.config/autostart/startup.sh

echo "✅ Hyprland Full Setup v2 tamamlandı! Yeniden oturum açarak keyfini çıkar hocam 🔥"
