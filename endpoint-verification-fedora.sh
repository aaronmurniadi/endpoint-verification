#!/bin/sh
set -eo pipefail

# Created and tested on Fedora 35

# Check requirements for unpacking/installing
echo 'Checking for programs needed for unpack & installation'
which ar > /dev/null
which cksum > /dev/null
which cp > /dev/null
which curl > /dev/null
which grep > /dev/null
which rm > /dev/null
which sed > /dev/null
which tar > /dev/null
which install > /dev/null
ls /usr/bin/uname > /dev/null
ls /usr/bin/sed > /dev/null

echo 'Checking for stuff needed by Google scripts'
ls /bin/echo > /dev/null
ls /bin/grep > /dev/null
ls /usr/bin/cut > /dev/null
ls /bin/cat > /dev/null
ls /bin/mountpoint > /dev/null
ls /bin/lsblk > /dev/null
ls /bin/udevadm > /dev/null
ls /usr/bin/awk > /dev/null
ls /usr/bin/tr > /dev/null
ls /usr/bin/printf > /dev/null
ls /proc/cmdline > /dev/null
ls /proc/mounts > /dev/null

# check for gsettings OR dconf
ls /usr/bin/gsettings > /dev/null || ls /usr/bin/dconf > /dev/null
ls /sys/class/dmi/id/product_serial > /dev/null
ls /sys/class/dmi/id/product_name > /dev/null
ls /bin/hostname > /dev/null
ls /sys/class/net/*/address > /dev/null

# Clear old and make new 'unpacked' directory
echo 'Creating directory to unpack .deb'
test ! -d unpacked || rm -rf unpacked
mkdir unpacked

# Download endpoint-verification.deb package from Google
echo 'Downloading .deb (unstable version - it is simpler)'
echo 'Downloading https://packages.cloud.google.com/apt/dists/endpoint-verification-unstable/main/binary-amd64/Packages' >>unpacked/download-log.txt
curl https://packages.cloud.google.com/apt/dists/endpoint-verification-unstable/main/binary-amd64/Packages >unpacked/Packages 2>>unpacked/download-log.txt || echo 'failed - check unpacked/download-log.txt'
DEB_URL="https://packages.cloud.google.com/apt/$(grep Filename unpacked/Packages | sed -e 's/Filename: //g' | grep 'endpoint-verification_')"
curl -o unpacked/endpoint-verification.deb "${DEB_URL}" 2>>unpacked/download-log.txt || echo 'failed - check unpacked/download-log.txt'

# Unpack endpoint-verification.deb to 'unpack' directory
mkdir -p unpacked/endpoint-verification
pushd unpacked/endpoint-verification >/dev/null
echo 'Unpacking endpoint-verification.deb'
ar x ../endpoint-verification.deb
mkdir ../control ../data
echo 'Unpacking control.tar.gz'
cd ../control
tar -zxf ../endpoint-verification/control.tar.gz
echo 'Unpacking data.tar.gz'
cd ../data
tar -zxf ../endpoint-verification/data.tar.gz

# Copy files to respective directories
USER_HOME=$(eval echo ~${SUDO_USER})
cp ./etc/opt/chrome/native-messaging-hosts/com.google.endpoint_verification.api_helper.json $USER_HOME/.config/google-chrome/NativeMessagingHosts/com.google.endpoint_verification.api_helper.json
cp ./opt/google/endpoint-verification/bin/apihelper /opt/google/endpoint-verification/bin/apihelper
cp ./opt/google/endpoint-verification/bin/device_state.sh /opt/google/endpoint-verification/bin/device_state.sh

# Give back permission of 'unpacked' directory to $SUDO_USER
chown -R $SUDO_USER ../../unpacked