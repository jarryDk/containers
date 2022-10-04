#!/bin/bash

source ../../toolbox.sh

# Goto root of project
gotoProjectRoot

#########################################################################
#
# Work on image
#

# container1=$(buildah from "${1:-docker.io/jarrydk/fedora-adoptium-openjdk:19}")
container1=$(buildah from "${1:-jarrydk/fedora-adoptium-openjdk:19}")

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
BUILD_OPENJDK_NEXT_FOLDER=/opt/java/build-openjdk-next
OPENJDK_NEXT_FOLDER=/opt/java/openjdk-next

mkdir -p $BUILD_OPENJDK_NEXT_FOLDER
cd $BUILD_OPENJDK_NEXT_FOLDER
git clone https://github.com/openjdk/jdk.git
cd jdk
bash configure --with-version-date=$(date +"%Y-%m-%d") --with-vendor-name=JarryDk
make images

echo "Building OpenJdk is Done ..."

if [ ! -d $OPENJDK_NEXT_FOLDER ]; then
	mkdir -p $OPENJDK_NEXT_FOLDER
	echo "Destination folder $OPENJDK_NEXT_FOLDER was created ..."
fi

source $BUILD_OPENJDK_NEXT_FOLDER/jdk/build/linux-x86_64-server-release/images/jdk/release

echo "----------------------------------------"
echo "-- OpenJdk release"
echo "----------------------------------------"
echo "JAVA_VERSION      : $JAVA_VERSION"
echo "JAVA_VERSION_DATE : $JAVA_VERSION_DATE"
echo "IMPLEMENTOR       : $IMPLEMENTOR"
echo "SOURCE            : $SOURCE"
echo "----------------------------------------"

echo "Copy OpenJdk next to $OPENJDK_NEXT_FOLDER/jdk-$JAVA_VERSION ..."
cp -R $BUILD_OPENJDK_NEXT_FOLDER/jdk/build/linux-x86_64-server-release/images/jdk $OPENJDK_NEXT_FOLDER/jdk-$JAVA_VERSION
EOF

chmod +x build/config-build.sh

echo "Add config-build.sh to images"
buildah copy "$container1" build/config-build.sh /opt/java/config-build.sh

buildah config --cmd "/opt/java/config-build.sh" "$container1"

echo "Commit images"
buildah commit "$container1" ${2:-jarrydk/fedora-tools-to-build-jdk:1}
