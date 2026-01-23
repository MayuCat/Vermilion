#!/bin/bash

set -ouex pipefail

### Install basic packages
dnf5 -y install --enablerepo='terra' \
        discord \
        wireshark \
        strawberry \
        libunity.x86_64


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

### Enabling System Unit File's
systemctl enable docker.socket
systemctl enable podman.socket

### Bling
dnf5 -y install fish
dnf5 -y copr enable atim/starship
dnf5 -y copr disable atim/starship
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:atim:starship install starship
# Fancy (From Bizzite <3)
HOME_URL="https://github.com/mayucat/vermilion"
echo "vermilion" | tee "/etc/hostname"

sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"Vermilion\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"Vermilion\"|
s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:matthias-adr:bizzite\"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"${HOME_URL}\"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="vermilion"|
EOF