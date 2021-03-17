#!/bin/bash

#########################################################################
#
# Work on image
#

container1=$(buildah from "${1:-jarry-fedora-openjdk:15.0.2}")

## Get all updates 
buildah run "$container1" -- dnf update -y

## Install our devel tools
buildah run "$container1" -- dnf install \
	git \
	file \
	zip \
	unzip \
	pkgdiff \
	freetype-devel \
	cups-devel \
	libXtst-devel \
	libXt-devel \
	libXrender-devel \
	libXrandr-devel \
	libXi-devel \
	alsa-lib-devel \
	libffi-devel \
	autoconf \
	gcc-c++ \
	fontconfig-devel -y

cat > build/config-build.sh <<"EOF"
#!/bin/bash
cd /opt/java
git clone https://github.com/openjdk/jdk.git
cd jdk
bash configure --with-version-date=$(date +"%Y-%m-%d")
make images
if [ ! -d /opt/java/openjdk-17 ]; then
	mkdir -p /opt/java/openjdk-17
fi
cp -R /opt/java/jdk/build/linux-x86_64-server-release/images/jdk /opt/java/openjdk-17/jdk-17
EOF

chmod +x build/config-build.sh

echo "Add config-build.sh to images"
buildah copy "$container1" build/config-build.sh /opt/java/config-build.sh

buildah config --cmd "/opt/java/config-build.sh" "$container1"

echo "Commit images"
buildah commit "$container1" ${2:-jarry-fedora-tools-to-build-jdk:1}
