#!/bin/bash

set -ouex pipefail

### Install basic packages
dnf5 -y install --enablerepo='terra' \
        discord.x86_64 \
        vencord-installer-discord-stable.x86_64 \
        strawberry \
        libunity.x86_64 
        
### Re-add QEMU because bazzite thought virtualization is only for dev work
dnf5 -y install \
        libvirt \
        qemu \
        qemu-img \
        guestfs-tools \
        qemu-kvm

### Re-add ROCM cuz lol see above
dnf5 -y install \
        rocm-hip \
        rocm-opencl\
        rocm-clinfo

dnf5 -y --setopt=install_weak_deps=False install \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo \
        rocm-smi

### Copr stuff
# Wezterm
dnf5 -y copr enable wezfurlong/wezterm-nightly
dnf5 -y copr disable wezfurlong/wezterm-nightly
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:wezfurlong:wezterm-nightly install wezterm

# lazygit
dnf5 -y copr enable dejan/lazygit
dnf5 -y copr disable dejan/lazygit
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:dejan:lazygit install lazygit

### Bling
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
