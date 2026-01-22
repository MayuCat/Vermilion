#!/bin/bash

set -ouex pipefail

### Install basic packages
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/terra-release.repo
dnf5 -y install -- enablerepo=terra-release \
        discord \
        wireshark \
        strawberry


### Copr stuff
# Wezterm
dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 -y copr disable wezfurlong/wezterm-nightly
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:wezfurlong:wezterm-nightly install wezterm

# lazygit
dnf5 -y copr enable dejan/lazygit
dnf5 -y copr disable dejan/lazygit
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:dejan:lazygit install lazygit

### Install Docker
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf -y install --enablerepo=docker-ce-stable \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    docker-model-plugin


### Install VSCodium
tee /etc/yum.repos.d/vscodium.repo << 'EOF'
[vscodium]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/vscodium.repo
dnf5 -y install --enablerepo=vscodium \
        codium


### Uninstall Strawberry Flatpak
flatpak uninstall org.strawberrymusicplayer.strawberry

### Enabling System Unit File's
systemctl enable docker.socket
systemctl enable podman.socket