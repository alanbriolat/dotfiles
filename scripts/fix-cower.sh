#/bin/bash

DIR=$(mktemp -d)

pushd "$DIR"
echo "Entering build directory... ($DIR)"
echo "Fetching package tarball..."
wget "https://aur.archlinux.org/packages/co/cower/cower.tar.gz"
tar xvf cower.tar.gz
pushd cower
echo "Building package..."
makepkg -s
echo "Installing package..."
sudo pacman -U cower-*.pkg.tar.xz
popd
popd
echo "Removing build directory..."
rm -rf "$DIR"
echo "Done!"
