#!/bin/bash
echo "=== Cấu hình Fedora Desktop tự động ==="

# =========================================================================
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

# =========================================================================
# 2. Tạo script first boot - chạy sau lần reboot đầu tiên - Anaconda
# =========================================================================
mkdir -p /usr/local/bin/

cat << 'EOF' > /usr/local/bin/fedora-firstboot.sh
#!/bin/bash

# Ghi log để theo dõi tiến trình cài đặt
exec > /var/log/fedora-firstboot.log 2>&1
echo "=== Kích hoạt tiến trình cài đặt tự động ==="

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

# Tạm ngắt PackageKit tránh hệ thống update gây lỗi
systemctl stop packagekit.service 2>/dev/null
systemctl mask packagekit.service 2>/dev/null

# Kiểm tra kết nối mạng thông suốt mới tiến hành
until ping -c 1 opendns.com &>/dev/null; do
    echo "Đang chờ mạng hoàn chỉnh..."
    sleep 5
done

# -------------------------------------------------------------------------
# Quá trình cài đặt
# -------------------------------------------------------------------------
echo "--- Đang cài đặt các công cụ tải file cơ bản ---"
dnf install wget curl -y

# =========================================================================
# Cấu hình giao diện và hình nền desktop
# =========================================================================

echo "--- Đang cấu hình giao diện cho desktop---"
mkdir -p /etc/skel/.config/
mkdir -p /usr/share/backgrounds/custom/

# Tải cấu hình từ link
curl -sL "https://coresystem.vn/files/kde-config.txt" -o /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc

# Ép thanh panel luôn bám vào màn hình chính mặc định
echo -e "\n[Containments][1]\nscreen=0" >> /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc

#Cấu hình power profile
echo "--- Đang cấu hình Power Profile ---"
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
floating=0
shell=org.kde.plasma.desktop

[PlasmaViews][Panel 2][Defaults]
thickness=38

PLSHLL

# Phân quyền /etc/skel
chmod 644 /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc
chmod 644 /etc/skel/.config/plasmashellrc
chmod 644 /etc/skel/.config/powermanagementprofilesrc
chmod 644 /etc/skel/.config/kscreenlockerrc

echo "--- Đang cài đặt ứng dụng hệ thống ---"

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

echo "--- Đang cài đặt bộ font Microsoft ---"
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

echo "--- Chuyển đổi bộ FFMPEG & Codecs hỗ trợ MP4 ---"

dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf install gstreamer1-plugins-ugly gstreamer1-plugins-bad-freeworld -y
dnf install cockpit cups cups-filters -y
systemctl start cockpit.socket
systemctl start cups

echo "--- Đang cài đặt các ứng dụng Flatpak---"

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.videolan.VLC org.onlyoffice.desktopeditors io.github.peazip.PeaZip io.github.vikdevelop.SaveDesktop com.super_productivity.SuperProductivity com.github.PintaProject.Pinta io.github.faridjaff.StickyNotesCanvas org.inkscape.Inkscape com.github.phase1geo.minder -y

# Hoàn trả kiểm soát dnf database lại cho PackageKit
systemctl unmask packagekit.service 2>/dev/null
systemctl start packagekit.service 2>/dev/null

echo "--- Thiết lập định danh alias cho hệ thống ---"

cat << 'ALIASEON' > /etc/profile.d/system-alias.sh
alias hc='history -c && clear'
alias hce='history -c && exit'
alias system-update='sudo dnf update'
alias system-upgrade='sudo dnf upgrade'
alias system-info='fastfetch -s Title:Separator:Host:OS:BIOS:TPM:Kernel:Uptime:Display:CPU:GPU:PhysicalDisk:PhysicalMemory:Memory:Swap:Disk:Battery:PowerAdapter:Locale:Break:Colors'
ALIASEON

chmod 644 /etc/profile.d/system-alias.sh

echo "=== Hoàn thành cài đặt. Khởi động lại hệ thống ==="
systemctl disable fedora-firstboot.service
rm -f /etc/systemd/system/fedora-firstboot.service
rm -f /usr/local/bin/fedora-firstboot.sh

reboot
EOF

chmod +x /usr/local/bin/fedora-firstboot.sh

# =========================================================================
# 3. Đăng ký systemd cho lần chạy cài đặt tự động
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
