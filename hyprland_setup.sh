#!/bin/bash
set -e

echo "🔹 Hyprland + Waybar + Mako + Wofi full setup (modern, TR klavye, autostart) - CachyOS/NVIDIA"

# -------------------------------
# Sistem paketleri
# -------------------------------
PKGS=(hyprland waybar mako wofi dolphin kitty brightnessctl pamixer ttf-jetbrains-mono-nerd nvidia nvidia-utils nvidia-settings egl-wayland)

for pkg in "${PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "📦 $pkg yüklenecek..."
        sudo pacman -S --noconfirm "$pkg"
    else
        echo "✔ $pkg zaten yüklü"
    fi
done

# -------------------------------
# Bibata çakışması kontrolü
# -------------------------------
if pacman -Qi bibata-cursor-theme-bin &>/dev/null; then
    echo "⚠ bibata-cursor-theme-bin bulundu, kaldırılıyor..."
    sudo pacman -R --noconfirm bibata-cursor-theme-bin
fi

if ! pacman -Qi bibata-cursor-theme &>/dev/null; then
    echo "📦 bibata-cursor-theme kuruluyor..."
    yay -S --noconfirm bibata-cursor-theme
else
    echo "✔ bibata-cursor-theme zaten yüklü"
fi

# -------------------------------
# Config dizinleri
# -------------------------------
mkdir -p ~/.config/{hypr,waybar,mako,wofi,autostart}

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
        middle_button_emulation = yes
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

bind = SUPER,1,workspace,1
bind = SUPER,2,workspace,2
bind = SUPER,3,workspace,3
bind = SUPER,4,workspace,4
bind = SUPER,5,workspace,5

exec-once = hyprctl setcursor Bibata-Modern-Ice 24
exec-once = brightnessctl set 50%
exec-once = ~/.config/autostart/startup.sh
exec-once = tlp start
EOF

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
# Mako Style (çalışır)
# -------------------------------
cat > ~/.config/mako/style.css <<'EOF'
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 12px;
}

window {
    background-color: rgba(46,52,64,0.95);
    color: #eceff4;
    border-radius: 14px;
    border: 2px solid rgba(129,161,193,0.8);
}

#app-name {
    color: #88c0d0;
}

#urgency {
    background-color: #bf616a;
    color: #eceff4;
}

#progress {
    background-color: #88c0d0;
}

#icon {
    max-size: 48px;
}
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

# -------------------------------
# Wofi Style (çalışır)
# -------------------------------
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
  "height": 30,
  "modules-left": ["workspaces", "custom/network-selector"],
  "modules-center": ["clock", "custom/weather"],
  "modules-right": [
    "cpu",
    "memory",
    "temperature",
    "disk",
    "pulseaudio",
    "network",
    "battery",
    "tray",
    "custom/playerctl",
    "custom/power"
  ],

  "clock": {
    "format": " {:%H:%M}   {:%d.%m.%Y}",
    "tooltip-format": "{:%A, %d %B %Y}"
  },

  "cpu": {
    "format": " {usage}%",
    "tooltip": true
  },

  "memory": {
    "format": " {used:0.1f}G/{total:0.1f}G",
    "tooltip": true
  },

  "temperature": {
    "critical-threshold": 80,
    "format": " {temperatureC}°C"
  },

  "disk": {
    "interval": 60,
    "format": " {free}G"
  },

  "pulseaudio": {
    "format": " {volume}%",
    "format-muted": " muted",
    "scroll-step": 5
  },

  "network": {
    "format-wifi": " {essid} ({signalStrength}%)",
    "format-ethernet": "󰈀 {ifname}",
    "format-disconnected": " Bağlantı yok",
    "tooltip": true
  },

  "battery": {
    "format": "{icon} {capacity}%",
    "format-icons": ["", "", "", "", ""],
    "interval": 30
  },

  "tray": {
    "spacing": 6
  },

  // 🌐 Ağ seçici (wofi + nmcli)
  "custom/network-selector": {
    "format": "",
    "tooltip": "Ağ seçici",
    "on-click": "nmcli device wifi rescan && nmcli device wifi list | wofi --dmenu | awk '{print $1}' | xargs -r -I{} nmcli device wifi connect {}",
    "interval": 0
  },

  // 🌦️ Hava durumu (İstanbul)
  "custom/weather": {
    "format": " {}",
    "interval": 600,
    "exec": "curl -s 'wttr.in/Istanbul?format=1'",
    "tooltip": "curl -s 'wttr.in/Istanbul?format=3'"
  },

  // 🎵 Müzik kontrolü
  "custom/playerctl": {
    "format": " {}",
    "exec": "playerctl metadata --format '{{artist}} - {{title}}' | cut -c1-30",
    "interval": 5,
    "on-click": "playerctl play-pause",
    "on-scroll-up": "playerctl next",
    "on-scroll-down": "playerctl previous"
  },

  // ⏻ Güç menüsü
  "custom/power": {
    "format": "⏻",
    "tooltip": "Kapat / Yeniden Başlat / Çıkış",
    "on-click": "wofi-power"
  }
}

EOF

cat > ~/.config/waybar/style.css <<'EOF'
/* Global */
* {
  font-family: "JetBrains Mono", monospace;
  font-size: 13px;
  border-radius: 10px;
  padding: 2px 6px;
  margin: 0 3px;
  transition: background 0.2s, color 0.2s;
}

/* Ana bar */
window#waybar {
  background: rgba(28, 28, 40, 0.92);
  border: 2px solid #3b82f6;
  color: rgba(255, 255, 255, 0.87);
  padding: 2px 4px;
}

/* Workspace */
#workspaces button {
  background: transparent;
  color: #888888;
  border-radius: 8px;
  padding: 0 8px;
}

#workspaces button.active {
  background: #3b82f6;
  color: #ffffff;
}

/* Saat */
#clock {
  background: rgba(60, 60, 80, 0.6);
  border: 1px solid #3b82f6;
  border-radius: 8px;
  padding: 2px 8px;
}

/* Sağ modüller */
#cpu, #memory, #temperature, #disk, #pulseaudio, #network,
#battery, #backlight, #tray, #custom-weather, #custom-playerctl,
#custom-power, #custom-network-selector {
  background: rgba(60, 60, 80, 0.6);
  border: 1px solid #3b82f6;
  border-radius: 8px;
  margin: 0 3px;
  padding: 2px 8px;
  transition: background 0.2s, color 0.2s;
}

/* Hover */
#cpu:hover, #memory:hover, #temperature:hover, #disk:hover, #pulseaudio:hover,
#network:hover, #battery:hover, #backlight:hover, #tray:hover,
#custom-weather:hover, #custom-playerctl:hover, #custom-power:hover,
#custom-network-selector:hover {
  background: rgba(59, 130, 246, 0.4);
  color: #ffffff;
}

/* Tooltip */
.tooltip {
  background: rgba(20, 20, 30, 0.9);
  color: #ffffff;
  border-radius: 8px;
  padding: 4px 8px;
  font-size: 12px;
}

/* Weather */
#custom-weather {
  background: #5e81ac;
  color: #fff;
  padding: 0 10px;
  margin: 0 3px;
  border-radius: 6px;
}

/* Playerctl */
#custom-playerctl {
  background: #a3be8c;
  color: #2e3440;
  padding: 0 10px;
  margin: 0 3px;
  border-radius: 6px;
  min-width: 120px;
}

/* Power */
#custom-power {
  background: #bf616a;
  color: #fff;
  font-weight: bold;
  padding: 0 10px;
  margin: 0 3px;
  border-radius: 6px;
}

/* Network selector */
#custom-network-selector {
  background: #89b4fa;
  color: #1e1e2e;
  font-weight: bold;
  padding: 0 12px;
  margin: 0 3px;
  border-radius: 6px;
}

EOF

# -------------------------------
# Autostart script
# -------------------------------
cat > ~/.config/autostart/startup.sh <<'EOF'
#!/bin/bash
killall mako || true
killall dunst || true
killall xfce4-notifyd || true

mako &
waybar &
EOF

chmod +x ~/.config/autostart/startup.sh

echo "✅ Kurulum tamamlandı! Hyprland + Waybar + Mako + Wofi artık modern, TR klavye ve tamamen çalışır durumda."
