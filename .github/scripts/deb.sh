#!/bin/bash

PREFIX="/data/data/com.termux/files/usr"
HOME_DIR="/data/data/com.termux/files/home"
NAME="flash-termux"
VERSION=$(cat deb/share/.flash_version)
OUT_DIR="${GITHUB_WORKSPACE}/out"
DEB_NAME="${NAME}_${VERSION}.deb"

if [ -z "$GITHUB_WORKSPACE" ]; then
    OUT_DIR="out"
fi

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}/deb${PREFIX}/bin"
mkdir -p "${OUT_DIR}/deb${HOME_DIR}/${NAME}"
mkdir -p "${OUT_DIR}/deb/DEBIAN"

install -v -m 755 src/flash "${OUT_DIR}/deb${PREFIX}/bin/"
install -v -m 755 src/flash-extract "${OUT_DIR}/deb${PREFIX}/bin/"
install -v -m 755 src/flash-execute "${OUT_DIR}/deb${PREFIX}/bin/"

cp -v deb/dpkg-conf/* "${OUT_DIR}/deb/DEBIAN/"

install -v -m 644 deb/share/.flash_version "${OUT_DIR}/deb${HOME_DIR}/${NAME}/"

chmod -R 755 "${OUT_DIR}/deb/DEBIAN"
find "${OUT_DIR}/deb${PREFIX}/bin" -type f -exec chmod 755 {} \;

cd "${OUT_DIR}/deb"
dpkg-deb -Zxz -b . "${OUT_DIR}/${DEB_NAME}"

echo "=== Package Structure ==="
dpkg -c "${OUT_DIR}/${DEB_NAME}"
echo "=== Package Metadata ==="
dpkg -I "${OUT_DIR}/${DEB_NAME}"

if [ -n "$GITHUB_WORKSPACE" ]; then
    echo "deb_path=${OUT_DIR}/${DEB_NAME}" >> $GITHUB_OUTPUT
fi

echo "=== Build Complete ==="
echo "Package: ${OUT_DIR}/${DEB_NAME}"
