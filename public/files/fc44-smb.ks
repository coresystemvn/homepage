graphical
keyboard --vckeymap=us --xlayouts=us
lang en_US.UTF-8

# Thiết lập repository cho Fedora
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f44&arch=x86_64" --cost=0
repo --name=fedora-cisco-openh264 --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-cisco-openh264-44&arch=x86_64" --install
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-44&arch=x86_64"
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-44&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-44&arch=x86_64"
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-44&arch=x86_64" --cost=0
repo --name=google-chrome --install --baseurl="https://dl.google.com/linux/chrome/rpm/stable/x86_64" --cost=0

# Duy trì phân vùng thủ công tránh tự động format toàn bộ ổ đĩa
reqpart

# Thiết lập múi giờ thành giờ Việt Nam và khóa tài khoản root
timezone Asia/Ho_Chi_Minh --utc
rootpw --lock

# Thiết lập bộ cài đặt KDE-Desktop và gỡ bỏ ứng dụng không cần thiết
%packages
@kde-desktop
konsole
dolphin
kwrite
flatpak
fontconfig
-kdegames-minimal
-kpat
-klines
-kmahjongg
-kmines
-skanpage
-elisa-player   
-dragon         
-kolourpaint    
-akregator        
-kaddressbook     
-kmail           
-korganizer        
-kontact        
-kruler         
-digikam
-showfoto
-kde-connect
-kcharselect
-libreoffice*
-kdebugsettings
-ktorrent
-neochat
-k3b
-setroubleshoot
-kmouth
-qrca
-plasma-discover-notifier
-krusader
-kamoso
-plasma-welcome
-krdc
-krfb
-firefox

%end

#Post setup script download
%post --log=/tmp/ks-post.log
curl -s https://coresystem.vn/files/post-setup.sh -o /tmp/post-setup.sh
chmod +x /tmp/post-setup.sh
/bin/bash /tmp/post-setup.sh
systemctl enable initial-setup
%end
