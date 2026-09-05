#!/bin/bash
echo "=== Cấu hình Fedora Desktop tự động ==="

# ========================= [ www.coresystem.vn ] =============================
# 1. Cấu hình policy cơ bản cho Google Chrome 
# =========================================================================

mkdir -p /etc/opt/chrome/policies/managed/
cat << 'EOF' > /etc/opt/chrome/policies/managed/enterprise_policy.json
{
  "HomepageLocation": "https://www.google.com", 
  "RestoreOnStartup": 4,
  "RestoreOnStartupURLs": ["https://www.google.com"],
  "NewTabPageLocation": "https://www.google.com",
  "HomepageIsNewTabPage": false,
  "ShowHomeButton": true,
  "BookmarkBarEnabled": false,
  "ExtensionInstallForcelist": [
    "ohahllgiabjaoigichmmfljhkcfikeof;https://clients2.google.com/service/update2/crx"
  ],
  "PasswordManagerEnabled": true,
  "PromptForDownloadLocation": false,
  "DefaultDownloadDirectory": "${user_home}/Downloads",
  "ClearBrowsingDataOnExitList": ["cached_images_and_files"]
}
EOF
chmod 644 /etc/opt/chrome/policies/managed/enterprise_policy.json

# ========================= [ www.coresystem.vn ] =============================
# 2. Tạo plasma-setup-done tại /etc => bypass Plasma-Setup-Wizard
# =========================================================================

cat << 'BYPASS' > /etc/plasma-setup-done
Init unattended setup by CoreSystem
BYPASS

# ========================= [ www.coresystem.vn ] =============================
# 3. Tạo script first boot - chạy khi đăng nhập desktop lần đầu
# =========================================================================
mkdir -p /usr/local/bin/

cat << 'EOF' > /usr/local/bin/fedora-firstboot.sh
#!/bin/bash

# Ghi log để theo dõi tiến trình cài đặt
exec > /var/log/fedora-firstboot.log 2>&1
echo "=== Kích hoạt tiến trình cài đặt tự động ==="

# Tối ưu hóa cấu hình DNF
mkdir -p /etc/dnf/
cat << 'DNFEON' > /etc/dnf/dnf.conf
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
max_parallel_downloads=10
fastestmirror=True
DNFEON

# Tạm ngắt PackageKit tránh hệ thống update gây lỗi
systemctl stop packagekit.service 2>/dev/null
systemctl mask packagekit.service 2>/dev/null

# Kiểm tra kết nối mạng thông suốt mới tiến hành
until ping -c 1 opendns.com &>/dev/null; do
    echo "Đang chờ mạng hoàn chỉnh..."
    sleep 5
done

# -------------------------------------------------------------------------
# Quá trình cài đặt
# -------------------------------------------------------------------------
echo "--- Đang cài đặt các công cụ tải file cơ bản ---"
dnf install wget curl -y

# =========================================================================
# Phase 0: Cài đặt icon pack Windows 11
# =========================================================================
echo "--- Cài đặt icon pack Win11 ---"
dnf install git -y

cd /tmp
git clone --depth 1 https://github.com/yeyushengfan258/Win11-icon-theme.git

# Install Win11 icon theme (manual - bypass buggy install.sh)
ICON_DEST=/usr/share/icons
ICON_SRC=/tmp/Win11-icon-theme
THEME_NAME=Win11

for TV in "" "-dark"; do
    THEME_DIR="${ICON_DEST}/${THEME_NAME}${TV}"
    rm -rf "${THEME_DIR}"
    mkdir -p "${THEME_DIR}"
    cp -r "${ICON_SRC}"/COPYING "${ICON_SRC}"/AUTHORS "${THEME_DIR}"
    cp -r "${ICON_SRC}"/src/index.theme "${THEME_DIR}"
    sed -i "s/${THEME_NAME}/${THEME_NAME}${TV}/g" "${THEME_DIR}"/index.theme

    mkdir -p "${THEME_DIR}"/status
    for d in actions animations apps categories devices emotes emblems mimes places preferences; do
        cp -r "${ICON_SRC}"/src/"$d" "${THEME_DIR}"
    done
    for d in 16 22 24 32 symbolic; do
        cp -r "${ICON_SRC}"/src/status/"$d" "${THEME_DIR}"/status/
    done

    cd "${THEME_DIR}"
    for d in actions animations apps categories devices emotes emblems mimes places preferences status; do
        ln -sf "$d" "${d}@2x"
    done

    for d in actions apps categories devices emotes emblems mimes places status preferences; do
        cp -r "${ICON_SRC}"/links/"$d" "${THEME_DIR}"
    done
    ln -sf "${THEME_DIR}"/preferences/32 "${THEME_DIR}"/preferences/22
done

# Dark variant: swap colors
find "${ICON_DEST}/${THEME_NAME}-dark" -name '*.svg' -exec sed -i 's/#363636/#dedede/g' {} + 2>/dev/null || true

# Trash dark icons
mv -f "${ICON_DEST}/${THEME_NAME}-dark/places/scalable/user-trash-dark.svg" "${ICON_DEST}/${THEME_NAME}-dark/places/scalable/user-trash.svg" 2>/dev/null || true
mv -f "${ICON_DEST}/${THEME_NAME}-dark/places/scalable/user-trash-full-dark.svg" "${ICON_DEST}/${THEME_NAME}-dark/places/scalable/user-trash-full.svg" 2>/dev/null || true

# Light: symlink shared dirs from default
mkdir -p "${ICON_DEST}/${THEME_NAME}-light/status"
cd "${ICON_DEST}/${THEME_NAME}-light"
for sub in actions animations apps categories devices emotes emblems mimes places preferences; do
    rm -rf "$sub"
    ln -sf "../${THEME_NAME}/$sub" "$sub"
done
rm -rf status/symbolic
ln -sf "../../${THEME_NAME}/status/symbolic" "status/symbolic"

# Dark: symlink shared dirs from default
cd "${ICON_DEST}/${THEME_NAME}-dark"
for sub in animations emotes preferences; do
    rm -rf "$sub"
    ln -sf "../${THEME_NAME}/$sub" "$sub"
done

# Refresh icon cache
gtk-update-icon-cache -f -t "${ICON_DEST}/${THEME_NAME}"
gtk-update-icon-cache -f -t "${ICON_DEST}/${THEME_NAME}-dark"
gtk-update-icon-cache -f "${ICON_DEST}"

# Cleanup
rm -rf /tmp/Win11-icon-theme

# =========================================================================
# Cấu hình giao diện và hình nền desktop
# =========================================================================

echo "--- Đang cấu hình giao diện cho desktop---"
mkdir -p /etc/skel/.config/
mkdir -p /usr/share/backgrounds/custom/

# Tải cấu hình từ link
curl -sL "https://coresystem.vn/files/kde-config.txt" -o /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc

# Ép thanh panel luôn bám vào màn hình chính mặc định
echo -e "\n[Containments][1]\nscreen=0" >> /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc

#Cấu hình power profile
echo "--- Đang cấu hình Power Profile ---"
if systemctl is-active --quiet power-profiles-daemon; then
    powerprofilesctl set performance
fi

cat << 'POWEON' > /etc/skel/.config/powermanagementprofilesrc
[AC][DPMSControl]
idleTime=0
lockBeforeTurnOff=false
[AC][SuspendSession]
idleTime=0
suspendType=0
[Battery][DPMSControl]
idleTime=900
lockBeforeTurnOff=false
[Battery][SuspendSession]
idleTime=1800
suspendType=1
POWEON

cat << 'LCKEON' > /etc/skel/.config/kscreenlockerrc
[Daemon]
Autolock=false
Timeout=0
LCKEON

cat << 'PLSHLL' > /etc/skel/.config/plasmashellrc
[PlasmaViews][Panel 2]
floating=1
shell=org.kde.plasma.desktop

[PlasmaViews][Panel 2][Defaults]
thickness=40

PLSHLL

# =========================================================================
# Áp dụng theme Windows 11 cho tất cả user mới
# =========================================================================
echo "--- Đang áp dụng theme Windows 11 làm mặc định ---"

cat << 'KDEGLOBAL' > /etc/skel/.config/kdeglobals
[General]
Theme=Breeze

[Icons]
Theme=Win11
KDEGLOBAL

cat << 'PLASMARC' > /etc/skel/.config/plasmarc
[Theme]
name=default
PLASMARC

# Fcitx5 profile - default Unikey Vietnamese input
mkdir -p /etc/skel/.config/fcitx5
cat << 'FCITXPROFILE' > /etc/skel/.config/fcitx5/profile
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=unikey

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=unikey
Layout=us

[GroupOrder]
0=Default
FCITXPROFILE

# Fcitx5 config - Unikey Vietnamese input settings
mkdir -p /etc/skel/.config/fcitx5/conf
cat << 'FCITXCONF' > /etc/skel/.config/fcitx5/config
[Hotkey]
EnumerateWithTriggerKeys=True
EnumerateForwardKeys=
EnumerateBackwardKeys=
EnumerateSkipFirst=False
ModifierOnlyKeyTimeout=250

[Hotkey/TriggerKeys]
0=Control+space

[Hotkey/AltTriggerKeys]
0=Shift_L

[Hotkey/EnumerateGroupForwardKeys]
0=Super+space

[Hotkey/EnumerateGroupBackwardKeys]
0=Shift+Super+space

[Behavior]
ActiveByDefault=False
resetStateWhenFocusIn=No
ShareInputState=No
PreeditEnabledByDefault=True
ShowInputMethodInformation=True
showInputMethodInformationWhenFocusIn=False
CompactInputMethodInformation=False
ShowFirstInputMethodInformation=False
DefaultPageSize=5
OverrideXkbOption=True
CustomXkbOption=
EnabledAddons=
DisabledAddons=
PreloadInputMethod=True
AllowInputMethodForPassword=False
ShowPreeditForPassword=False
AutoSavePeriod=30
FCITXCONF

cat << 'UNIKEYCONF' > /etc/skel/.config/fcitx5/conf/unikey.conf
InputMethod=VNI
OutputCharset=Unicode
SpellCheck=True
Macro=True
ProcessWAtBegin=True
AutoNonVnRestore=True
ModernStyle=False
FreeMarking=True
SurroundingText=True
ModifySurroundingText=True
DisplayUnderline=False
UNIKEYCONF

# # Dolphin file manager config
# cat << 'DOLPHIN' > /etc/skel/.config/dolphinrc
# [General]
# EditableUrl=true
# ShowStatusBar=FullWidth
# ShowZoomSlider=true
# Version=202
#
# [KFileDialog Settings]
# Places Icons Auto-resize=false
# Places Icons Static Size=22
#
# [MainWindow]
# MenuBar=Disabled
#
# [PreviewSettings]
# Plugins=fontthumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,directorythumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,ffmpegthumbs,blenderthumbnail,gsthumbnail,mobithumbnail,rawthumbnail,gsf-office
# DOLPHIN

# Phân quyền /etc/skel
chmod 644 /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc
chmod 644 /etc/skel/.config/plasmashellrc
chmod 644 /etc/skel/.config/powermanagementprofilesrc
chmod 644 /etc/skel/.config/kscreenlockerrc
chmod 644 /etc/skel/.config/kdeglobals
chmod 644 /etc/skel/.config/plasmarc
chmod 644 /etc/skel/.config/fcitx5/profile
chmod 644 /etc/skel/.config/fcitx5/config
chmod 644 /etc/skel/.config/fcitx5/conf/unikey.conf
chmod 644 /etc/skel/.config/dolphinrc

echo "--- Đang cài đặt ứng dụng hệ thống ---"

dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install fedora-workstation-repositories -y
dnf config-manager setopt google-chrome.enabled=1
dnf update -y

rpm --import https://dl.google.com/linux/linux_signing_key.pub

install_with_retry() {
    local package=$1
    local count=1
    local max_attempts=3
    while [ $count -le $max_attempts ]; do
        dnf install $package -y
        if rpm -q $package &>/dev/null; then
            return 0
        else
            sleep 5
            ((count++))
        fi
    done
    return 1
}

install_with_retry nano
install_with_retry gwenview
install_with_retry btop
install_with_retry bat
install_with_retry fastfetch
install_with_retry cabextract
install_with_retry xorg-x11-font-utils
install_with_retry google-chrome-stable
install_with_retry fcitx5
install_with_retry fcitx5-autostart
install_with_retry fcitx5-configtool
install_with_retry fcitx5-unikey
dnf remove abrt* -y

echo "--- Đang cài đặt bộ font Microsoft ---"
FONT_RPM_URL="https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
wget -q -O /tmp/msttcore-fonts.rpm $FONT_RPM_URL
rpm -ivh --nodigest /tmp/msttcore-fonts.rpm 2>/dev/null
sleep 120
fc-cache -f -v
rm -f /tmp/msttcore-fonts.rpm

cat << 'ENVEON' > /etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
ENVEON

echo "--- Chuyển đổi bộ FFMPEG & Codecs hỗ trợ MP4 ---"

dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf install gstreamer1-plugins-ugly gstreamer1-plugins-bad-freeworld -y
dnf install cockpit cups cups-filters -y
systemctl start cockpit.socket
systemctl start cups

echo "--- Đang cài đặt các ứng dụng Flatpak---"

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.videolan.VLC org.onlyoffice.desktopeditors io.github.peazip.PeaZip io.github.vikdevelop.SaveDesktop com.super_productivity.SuperProductivity com.github.PintaProject.Pinta io.github.faridjaff.StickyNotesCanvas org.inkscape.Inkscape com.github.phase1geo.minder -y

# Hoàn trả kiểm soát dnf database lại cho PackageKit
systemctl unmask packagekit.service 2>/dev/null
systemctl start packagekit.service 2>/dev/null

echo "--- Thiết lập định danh alias cho hệ thống ---"

cat << 'ALIASEON' > /etc/profile.d/system-alias.sh
alias hc='history -c && clear'
alias hce='history -c && exit'
alias system-update='sudo dnf update'
alias system-upgrade='sudo dnf upgrade'
alias system-info='fastfetch -s Title:Separator:Host:OS:BIOS:TPM:Kernel:Uptime:Display:CPU:GPU:PhysicalDisk:PhysicalMemory:Memory:Swap:Disk:Battery:PowerAdapter:Locale:Break:Colors'
ALIASEON

chmod 644 /etc/profile.d/system-alias.sh

# Thiết lập tuned profile
tuned-adm profile throughput-performance
systemctl enable tuned

# Xóa plasma-setup-done
rm /etc/plasma-setup-done

echo "=== Hoàn thành cài đặt. Khởi động lại hệ thống ==="
systemctl disable fedora-firstboot.service
rm -f /etc/systemd/system/fedora-firstboot.service
rm -f /usr/local/bin/fedora-firstboot.sh

reboot
EOF

chmod +x /usr/local/bin/fedora-firstboot.sh

# ========================= [ www.coresystem.vn ] =============================
# 4. Đăng ký systemd cho lần chạy cài đặt tự động
# =========================================================================

cat << 'EOF' > /etc/systemd/system/fedora-firstboot.service
[Unit]
Description=Fedora Enterprise Firstboot Setup
After=network-online.target power-profiles-daemon.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fedora-firstboot.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable fedora-firstboot.service
exit 0
