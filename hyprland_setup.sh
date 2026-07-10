#!/bin/bash
# Hyprland Full Setup v6 (Melih Edition - Multi-Language Interactive)
# Hazırlayan: Melih Yenen (MelihOS)
# Kullanım: chmod +x hypr_v6.sh && ./hypr_v6.sh
set -euo pipefail
IFS=$'\n\t'

########################
# Dil Seçimi (Language Selection)
########################
echo "🌐 Lütfen bir dil seçin / Please select a language / 请选择语言 / कृपया भाषा चुनें / Seleccione un idioma / Choisissez une langue:"
echo "1) Türkçe"
echo "2) English"
echo "3) 中文 (Mandarin)"
echo "4) हिन्दी (Hindi)"
echo "5) Español"
echo "6) Français"
read -rp "Seçim / Choice (1-6): " LANG_CHOICE || LANG_CHOICE=1

case $LANG_CHOICE in
  2) # English
    YES_KEY="yY"
    PROMPT_YN="(y/n)"
    MSG_WELCOME="🌌 MelihOS Hyprland Installer v6 — Designed by Melih Yenen"
    MSG_INIT="🧠 Smart configuration system starting..."
    MSG_LOG="📜 Log file:"
    MSG_PKG_CHECK="📦 Checking required packages..."
    MSG_PKG_INSTALL="📦 The following packages will be installed:"
    MSG_PKG_OK="✔ All basic packages are already installed"
    MSG_GPU="🎮 GPU detected:"
    MSG_NVIDIA="🟢 Checking NVIDIA drivers..."
    MSG_PIPEWIRE="🔊 Enabling PipeWire services..."
    MSG_THEME="🎨 Choose theme (1-Nord, 2-Catppuccin, 3-Dracula, 4-Auto random)"
    MSG_THEME_PROMPT="Your choice (1/2/3/4): "
    MSG_THEME_SELECTED="✨ Selected theme:"
    MSG_THEME_COLORS="🎯 Theme colors:"
    MSG_BACKUP="📦 Backed up ->"
    MSG_HYPR_FAIL="⚠️ Hyprland version could not be detected, defaulting to"
    MSG_HYPR_VER="📦 Hyprland version:"
    MSG_WALL_NOTFOUND="📁 No wallpaper found in directory"
    MSG_WALL_ASK="Do you want to create a sample wallpaper?"
    MSG_WALL_CREATED="🖼️ Sample wallpaper created:"
    MSG_WALL_FAIL="⚠️ imagemagick (convert) missing — placeholder not created. Please add manually."
    MSG_CONF_WRITTEN="📝 Configuration written ->"
    MSG_TOOLS_ASK="Do you want to install additional tools (grim/slurp/swappy/etc)?"
    MSG_TOOLS_OK="✔ Additional tools are already installed"
    MSG_DONE="✨ Hyprland v6 Melih Edition installation completed!"
    MSG_REBOOT_NOTE="💡 You can apply changes by logging out and in again or reloading Hyprland."
    MSG_NOTES="🔎 Notes:"
    MSG_LANG_NOTE="- 🌎 Languages -> You can switch layouts with Alt + Shift."
    ;;
  3) # Chinese (Mandarin)
    YES_KEY="yY"
    PROMPT_YN="(y/n)"
    MSG_WELCOME="🌌 MelihOS Hyprland 安装程序 v6 — 由 Melih Yenen 设计"
    MSG_INIT="🧠 智能配置系统启动中..."
    MSG_LOG="📜 日志文件:"
    MSG_PKG_CHECK="📦 正在检查必需的包..."
    MSG_PKG_INSTALL="📦 将安装以下包:"
    MSG_PKG_OK="✔ 所有基本包均已安装"
    MSG_GPU="🎮 检测到 GPU:"
    MSG_NVIDIA="🟢 正在检查 NVIDIA 驱动..."
    MSG_PIPEWIRE="🔊 正在启用 PipeWire 服务..."
    MSG_THEME="🎨 选择主题 (1-Nord, 2-Catppuccin, 3-Dracula, 4-自动随机)"
    MSG_THEME_PROMPT="您的选择 (1/2/3/4): "
    MSG_THEME_SELECTED="✨ 已选主题:"
    MSG_THEME_COLORS="🎯 主题颜色:"
    MSG_BACKUP="📦 已备份 ->"
    MSG_HYPR_FAIL="⚠️ 无法检测 Hyprland 版本，将使用默认值"
    MSG_HYPR_VER="📦 Hyprland 版本:"
    MSG_WALL_NOTFOUND="📁 目录中未找到壁纸"
    MSG_WALL_ASK="是否要创建示例壁纸？"
    MSG_WALL_CREATED="🖼️ 示例壁纸已创建:"
    MSG_WALL_FAIL="⚠️ 缺少 imagemagick (convert) — 无法创建占位符。请手动添加。"
    MSG_CONF_WRITTEN="📝 配置文件已写入 ->"
    MSG_TOOLS_ASK="是否要安装其他工具 (grim/slurp/swappy 等)？"
    MSG_TOOLS_OK="✔ 附加工具已安装"
    MSG_DONE="✨ Hyprland v6 Melih 版安装完成！"
    MSG_REBOOT_NOTE="💡 重新登录或重新加载 Hyprland 即可应用更改。"
    MSG_NOTES="🔎 注意事项:"
    MSG_LANG_NOTE="- 🌎 语言 -> 使用 Alt + Shift 切换键盘布局。"
    ;;
  4) # Hindi
    YES_KEY="yY"
    PROMPT_YN="(y/n)"
    MSG_WELCOME="🌌 MelihOS Hyprland इंस्टॉलर v6 — Melih Yenen द्वारा डिज़ाइन किया गया"
    MSG_INIT="🧠 स्मार्ट कॉन्फ़िगरेशन सिस्टम शुरू हो रहा है..."
    MSG_LOG="📜 लॉग फ़ाइल:"
    MSG_PKG_CHECK="📦 आवश्यक पैकेजों की जाँच की जा रही है..."
    MSG_PKG_INSTALL="📦 निम्नलिखित पैकेज इंस्टॉल किए जाएंगे:"
    MSG_PKG_OK="✔ सभी बुनियादी पैकेज पहले से इंस्टॉल हैं"
    MSG_GPU="🎮 GPU का पता चला:"
    MSG_NVIDIA="🟢 NVIDIA ड्राइवरों की जाँच की जा रही है..."
    MSG_PIPEWIRE="🔊 PipeWire सेवाओं को सक्षम किया जा रहा है..."
    MSG_THEME="🎨 थीम चुनें (1-Nord, 2-Catppuccin, 3-Dracula, 4-ऑटो रैंडम)"
    MSG_THEME_PROMPT="आपकी पसंद (1/2/3/4): "
    MSG_THEME_SELECTED="✨ चयनित थीम:"
    MSG_THEME_COLORS="🎯 थीम के रंग:"
    MSG_BACKUP="📦 बैकअप किया गया ->"
    MSG_HYPR_FAIL="⚠️ Hyprland संस्करण का पता नहीं चला, डिफ़ॉल्ट का उपयोग किया जा रहा है"
    MSG_HYPR_VER="📦 Hyprland संस्करण:"
    MSG_WALL_NOTFOUND="📁 निर्देशिका में कोई वॉलपेपर नहीं मिला"
    MSG_WALL_ASK="क्या आप एक नमूना वॉलपेपर बनाना चाहते हैं?"
    MSG_WALL_CREATED="🖼️ नमूना वॉलपेपर बनाया गया:"
    MSG_WALL_FAIL="⚠️ imagemagick (convert) गायब है — प्लेसहोल्डर नहीं बनाया जा सका। कृपया मैन्युअल रूप से जोड़ें।"
    MSG_CONF_WRITTEN="📝 कॉन्फ़िगरेशन लिखा गया ->"
    MSG_TOOLS_ASK="क्या आप अतिरिक्त टूल (grim/slurp/swappy आदि) इंस्टॉल करना चाहते हैं?"
    MSG_TOOLS_OK="✔ अतिरिक्त उपकरण पहले से ही स्थापित हैं"
    MSG_DONE="✨ Hyprland v6 Melih संस्करण की स्थापना पूरी हुई!"
    MSG_REBOOT_NOTE="💡 आप लॉग आउट और इन करके या Hyprland को पुनः लोड करके परिवर्तनों को लागू कर सकते हैं।"
    MSG_NOTES="🔎 टिप्पणियाँ:"
    MSG_LANG_NOTE="- 🌎 भाषाएँ -> आप Alt + Shift के साथ लेआउट बदल सकते हैं।"
    ;;
  5) # Español
    YES_KEY="sS"
    PROMPT_YN="(s/n)"
    MSG_WELCOME="🌌 Instalador MelihOS Hyprland v6 — Diseñado por Melih Yenen"
    MSG_INIT="🧠 Iniciando sistema de configuración inteligente..."
    MSG_LOG="📜 Archivo de registro:"
    MSG_PKG_CHECK="📦 Comprobando paquetes requeridos..."
    MSG_PKG_INSTALL="📦 Se instalarán los siguientes paquetes:"
    MSG_PKG_OK="✔ Todos los paquetes básicos ya están instalados"
    MSG_GPU="🎮 GPU detectada:"
    MSG_NVIDIA="🟢 Comprobando controladores NVIDIA..."
    MSG_PIPEWIRE="🔊 Habilitando servicios PipeWire..."
    MSG_THEME="🎨 Elige tema (1-Nord, 2-Catppuccin, 3-Dracula, 4-Aleatorio)"
    MSG_THEME_PROMPT="Tu elección (1/2/3/4): "
    MSG_THEME_SELECTED="✨ Tema seleccionado:"
    MSG_THEME_COLORS="🎯 Colores del tema:"
    MSG_BACKUP="📦 Respaldo creado ->"
    MSG_HYPR_FAIL="⚠️ No se detectó versión de Hyprland, usando predeterminada"
    MSG_HYPR_VER="📦 Versión de Hyprland:"
    MSG_WALL_NOTFOUND="📁 No se encontraron fondos en el directorio"
    MSG_WALL_ASK="¿Desea crear un fondo de pantalla de muestra?"
    MSG_WALL_CREATED="🖼️ Fondo de muestra creado:"
    MSG_WALL_FAIL="⚠️ imagemagick (convert) no encontrado — no se creó la imagen. Añada una manualmente."
    MSG_CONF_WRITTEN="📝 Configuración escrita ->"
    MSG_TOOLS_ASK="¿Desea instalar herramientas adicionales (grim/slurp/swappy/etc)?"
    MSG_TOOLS_OK="✔ Las herramientas adicionales ya están instaladas"
    MSG_DONE="✨ ¡Instalación de Hyprland v6 Melih Edition completada!"
    MSG_REBOOT_NOTE="💡 Puede aplicar los cambios cerrando sesión o recargando Hyprland."
    MSG_NOTES="🔎 Notas:"
    MSG_LANG_NOTE="- 🌎 Idiomas -> Puede cambiar el diseño del teclado con Alt + Shift."
    ;;
  6) # Français
    YES_KEY="oO"
    PROMPT_YN="(o/n)"
    MSG_WELCOME="🌌 Installateur MelihOS Hyprland v6 — Conçu par Melih Yenen"
    MSG_INIT="🧠 Démarrage du système de configuration intelligent..."
    MSG_LOG="📜 Fichier journal:"
    MSG_PKG_CHECK="📦 Vérification des paquets requis..."
    MSG_PKG_INSTALL="📦 Les paquets suivants seront installés:"
    MSG_PKG_OK="✔ Tous les paquets de base sont déjà installés"
    MSG_GPU="🎮 GPU détecté:"
    MSG_NVIDIA="🟢 Vérification des pilotes NVIDIA..."
    MSG_PIPEWIRE="🔊 Activation des services PipeWire..."
    MSG_THEME="🎨 Choisissez le thème (1-Nord, 2-Catppuccin, 3-Dracula, 4-Aléatoire)"
    MSG_THEME_PROMPT="Votre choix (1/2/3/4): "
    MSG_THEME_SELECTED="✨ Thème sélectionné:"
    MSG_THEME_COLORS="🎯 Couleurs du thème:"
    MSG_BACKUP="📦 Sauvegardé ->"
    MSG_HYPR_FAIL="⚠️ Version de Hyprland non détectée, utilisation par défaut"
    MSG_HYPR_VER="📦 Version de Hyprland:"
    MSG_WALL_NOTFOUND="📁 Aucun fond d'écran trouvé dans le répertoire"
    MSG_WALL_ASK="Voulez-vous créer un fond d'écran d'exemple ?"
    MSG_WALL_CREATED="🖼️ Fond d'écran d'exemple créé:"
    MSG_WALL_FAIL="⚠️ imagemagick (convert) introuvable — image non créée. Veuillez ajouter manuellement."
    MSG_CONF_WRITTEN="📝 Configuration écrite ->"
    MSG_TOOLS_ASK="Voulez-vous installer des outils supplémentaires (grim/slurp/swappy/etc) ?"
    MSG_TOOLS_OK="✔ Les outils supplémentaires sont déjà installés"
    MSG_DONE="✨ Installation de Hyprland v6 Melih Edition terminée !"
    MSG_REBOOT_NOTE="💡 Vous pouvez appliquer les changements en vous reconnectant ou en rechargeant Hyprland."
    MSG_NOTES="🔎 Notes :"
    MSG_LANG_NOTE="- 🌎 Langues -> Vous pouvez changer la disposition avec Alt + Shift."
    ;;
  *) # 1) Türkçe (Default)
    YES_KEY="eE"
    PROMPT_YN="(e/h)"
    MSG_WELCOME="🌌 MelihOS Hyprland Installer v6 — Designed by Melih Yenen"
    MSG_INIT="🧠 Akıllı yapılandırma sistemi başlatılıyor..."
    MSG_LOG="📜 Log dosyası:"
    MSG_PKG_CHECK="📦 Gerekli paketler kontrol ediliyor..."
    MSG_PKG_INSTALL="📦 Aşağıdaki paketler kurulacak:"
    MSG_PKG_OK="✔ Tüm temel paketler zaten yüklü"
    MSG_GPU="🎮 GPU algılandı:"
    MSG_NVIDIA="🟢 NVIDIA sürücüleri kontrol ediliyor..."
    MSG_PIPEWIRE="🔊 PipeWire servisleri etkinleştiriliyor..."
    MSG_THEME="🎨 Tema seç (1-Nord, 2-Catppuccin, 3-Dracula, 4-Otomatik rastgele)"
    MSG_THEME_PROMPT="Seçimin (1/2/3/4): "
    MSG_THEME_SELECTED="✨ Seçilen tema:"
    MSG_THEME_COLORS="🎯 Tema renkleri:"
    MSG_BACKUP="📦 Yedeklendi ->"
    MSG_HYPR_FAIL="⚠️ Hyprland sürümü algılanamadı, varsayılan kullanılacak:"
    MSG_HYPR_VER="📦 Hyprland sürümü:"
    MSG_WALL_NOTFOUND="📁 Dizininde wallpaper bulunamadı:"
    MSG_WALL_ASK="Örnek bir wallpaper oluşturulsun mu?"
    MSG_WALL_CREATED="🖼️ Örnek wallpaper oluşturuldu:"
    MSG_WALL_FAIL="⚠️ imagemagick (convert) yok — placeholder resmi oluşturulamadı. Lütfen manuel ekle."
    MSG_CONF_WRITTEN="📝 Konfigürasyon yazıldı ->"
    MSG_TOOLS_ASK="Ek araçları (grim/slurp/swappy/network-manager-applet vb.) kurmak ister misin?"
    MSG_TOOLS_OK="✔ Ek araçlar zaten yüklü"
    MSG_DONE="✨ Hyprland v6 Melih Edition kurulumu tamamlandı hocam!"
    MSG_REBOOT_NOTE="💡 Sistemi yeniden oturum açarak veya Hyprland'i yeniden başlatarak değişiklikleri uygulayabilirsin."
    MSG_NOTES="🔎 Notlar:"
    MSG_LANG_NOTE="- 🌎 Diller -> Alt + Shift ile klavye dilleri arası geçiş yapabilirsin."
    ;;
esac

########################
# Log ve Environment
########################
LOG_FILE="$HOME/hyprland_setup_v6_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo -e "\n$MSG_WELCOME"
echo "$MSG_INIT"
echo "$MSG_LOG $LOG_FILE"
echo ""

########################
# Yardımcı fonksiyonlar
########################
command_exists() { command -v "$1" &>/dev/null; }

confirm() {
  local prompt="$1"
  read -rp "$prompt $PROMPT_YN: " ans
  if [[ "$ans" == "["$YES_KEY"]"* ]]; then
    return 0
  else
    return 1
  fi
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
  pipewire wireplumber pavucontrol noto-fonts noto-fonts-cjk noto-fonts-indic
)

EXTRA_PKGS=(
  grim slurp swappy network-manager-applet blueman fastfetch
)

echo "$MSG_PKG_CHECK"
to_install=()
for pkg in "${PKGS[@]}"; do
  if ! pacman -Qi "$pkg" &>/dev/null; then
    to_install+=("$pkg")
  fi
done

if [ ${#to_install[@]} -gt 0 ]; then
  echo "$MSG_PKG_INSTALL ${to_install[*]}"
  sudo pacman -Syu --noconfirm "${to_install[@]}"
else
  echo "$MSG_PKG_OK"
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
echo "$MSG_GPU $GPU_TYPE"

if [[ "$GPU_TYPE" == "nvidia" ]]; then
  echo "$MSG_NVIDIA"
  if ! pacman -Qi nvidia &>/dev/null; then
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings egl-wayland
  fi
fi

########################
# PipeWire / servislere başlat
########################
echo "$MSG_PIPEWIRE"
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
echo "$MSG_THEME"
read -rp "$MSG_THEME_PROMPT" THEME_CHOICE || THEME_CHOICE=1

case $THEME_CHOICE in
  1) THEME_NAME="nord" ;;
  2) THEME_NAME="catppuccin" ;;
  3) THEME_NAME="dracula" ;;
  4) THEME_NAME="random" ;;
  *) THEME_NAME="nord" ;;
esac

case $THEME_NAME in
  nord) BAR_COLOR="#88c0d0"; ACCENT_COLOR="#5e81ac"; BG_COLOR="#2e3440" ;;
  catppuccin) BAR_COLOR="#b4befe"; ACCENT_COLOR="#cba6f7"; BG_COLOR="#1f1d2e" ;;
  dracula) BAR_COLOR="#bd93f9"; ACCENT_COLOR="#ff79c6"; BG_COLOR="#282a36" ;;
  random)
    RAND() { printf '#%02x%02x%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)); }
    BAR_COLOR="$(RAND)"; ACCENT_COLOR="$(RAND)"; BG_COLOR="$(RAND)"
    THEME_NAME="custom-random"
    ;;
esac

echo "$MSG_THEME_SELECTED $THEME_NAME"
echo "$MSG_THEME_COLORS BAR=$BAR_COLOR ACCENT=$ACCENT_COLOR BG=$BG_COLOR"

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
    cp -r "$HOME/.config/$dir" "$backup" 2>/dev/null || true
    echo "$MSG_BACKUP ~/.config/$dir -> $backup"
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
  echo "$MSG_HYPR_FAIL $HYPR_VERSION."
else
  echo "$MSG_HYPR_VER $HYPR_VERSION"
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
  echo "$MSG_WALL_NOTFOUND $WALLPAPER_DIR"
  if confirm "$MSG_WALL_ASK"; then
    if command_exists convert; then
      convert -size 1920x1080 xc:"$BG_COLOR" "$WALLPAPER_DIR/default_wallpaper.png"
      echo "$MSG_WALL_CREATED $WALLPAPER_DIR/default_wallpaper.png"
      WALLPAPER="$WALLPAPER_DIR/default_wallpaper.png"
    else
      echo "$MSG_WALL_FAIL"
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
# Hyprland Config - $THEME_NAME
# Generated: $(date)
# ======================================

monitor=,preferred,auto,1

cursor {
    no_hardware_cursors = true
}

$( [[ "$GPU_TYPE" == "nvidia" ]] && cat <<'NV'
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_DRM_DEVICES,/dev/dri/card0
env = WLR_EGL_NO_MODIFIERS,1
NV
)

input {
    # 5 Major Languages + Turkish Layouts. Switch: Alt+Shift
    kb_layout = tr,us,es,fr
    kb_options = grp:alt_shift_toggle

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
    col.active_border = rgb(${BAR_COLOR//#/})
    col.inactive_border = rgb(${BG_COLOR//#/})
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

echo "$MSG_CONF_WRITTEN $HYPR_CONF"

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
echo "$MSG_CONF_WRITTEN ~/.local/bin/powermenu.sh"

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

label {
    monitor =
    text = 🔒 | Hoş geldin | Welcome | 你好 | नमस्ते | Hola | Bonjour
    color = rgba(255, 255, 255, 1.0)
    font_size = 20
    font_family = JetBrainsMono Nerd Font
    position = 0, 100
    halign = center
    valign = center
}
EOF
echo "$MSG_CONF_WRITTEN $HYPRLOCK_CONF"

########################
# Waybar config & style 
########################
WAYBAR_CONF_DIR="$HOME/.config/waybar"
safe_mkdir "$WAYBAR_CONF_DIR"

cat > "$WAYBAR_CONF_DIR/config" <<EOF
{
  "layer": "top",
  "position": "top",
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["custom/clock"],
  "modules-right": ["pulseaudio", "battery", "cpu", "memory", "network"],
  
  "custom/clock": {
    "exec": "$WAYBAR_CONF_DIR/scripts/clock",
    "interval": 60,
    "tooltip": false
  }
}
EOF

cat > "$WAYBAR_CONF_DIR/style.css" <<EOF
@define-color bar_color $BAR_COLOR;
@define-color accent_color $ACCENT_COLOR;

* {
    font-family: "JetBrains Mono", "JetBrainsMono Nerd Font", monospace;
    font-size: 12px;
}
window#waybar {
    background: rgba(30,30,46,0.7);
    color: @bar_color;
}
#custom-clock {
    color: @accent_color;
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

echo "$MSG_CONF_WRITTEN $WAYBAR_CONF_DIR"

########################
# Mako config
########################
MAKO_CONF="$HOME/.config/mako/config"
safe_mkdir "$(dirname "$MAKO_CONF")"
cat > "$MAKO_CONF" <<EOF
# Mako notifications
geometry = "300x"
timeout = 5000
max-visible = 3
font = "JetBrains Mono 11"
EOF
echo "$MSG_CONF_WRITTEN $MAKO_CONF"

########################
# Ek araçlar kurulumu
########################
echo ""
if confirm "$MSG_TOOLS_ASK"; then
  extras_to_install=()
  for pkg in "${EXTRA_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      extras_to_install+=("$pkg")
    fi
  done
  if [ ${#extras_to_install[@]} -gt 0 ]; then
    echo "$MSG_PKG_INSTALL ${extras_to_install[*]}"
    sudo pacman -S --noconfirm "${extras_to_install[@]}"
  else
    echo "$MSG_TOOLS_OK"
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

echo "$MSG_DONE"
echo "$MSG_LOG $LOG_FILE"
echo "$MSG_REBOOT_NOTE"
echo ""
echo "$MSG_NOTES"
echo "- Waybar style -> ~/.config/waybar/style.css"
echo "- Hyprland conf -> $HYPR_CONF"
echo "- Hyprlock conf -> $HYPRLOCK_CONF"
echo "- Powermenu -> ~/.local/bin/powermenu.sh"
echo "$MSG_LANG_NOTE"
echo ""
