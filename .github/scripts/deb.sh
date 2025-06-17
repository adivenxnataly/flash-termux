#!/bin/bash

PREFIX="/data/data/com.termux/files/usr"
HOME_DIR="/data/data/com.termux/files/home"
NAME="flash-termux"
VERSION="1.0.0"
OUT_DIR="${GITHUB_WORKSPACE}/out"
COMMIT_HASH=$(git rev-parse --short HEAD)
DEB_NAME="${NAME}_${VERSION}-${COMMIT_HASH}.deb"

if [ -z "$GITHUB_WORKSPACE" ]; then
    OUT_DIR="out"
fi

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}/deb${PREFIX}/bin"
mkdir -p "${OUT_DIR}/deb${PREFIX}/lib/flash-termux/utils"
mkdir -p "${OUT_DIR}/deb${PREFIX}/share/${NAME}"
mkdir -p "${OUT_DIR}/deb/DEBIAN"

cp -v src/flash src/flash-extract src/flash-execute "${OUT_DIR}/deb${PREFIX}/bin/"
cp -v src/utils/* "${OUT_DIR}/deb${PREFIX}/lib/flash-termux/utils/"
cp -rv deb/dpkg-conf/* "${OUT_DIR}/deb/DEBIAN/"
sed -i "s/^Version: .*/Version: ${VERSION}-${COMMIT_HASH}/" "${OUT_DIR}/deb/DEBIAN/deb/dpkg-conf/control"
echo "${VERSION}-${COMMIT_HASH}" > "${OUT_DIR}/deb${HOME_DIR}/${NAME}/.flash_version"

chmod -R 755 "${OUT_DIR}/deb/DEBIAN"
chmod 755 "${OUT_DIR}/deb${PREFIX}/bin/flash"
chmod 755 "${OUT_DIR}/deb${PREFIX}/bin/flash-extract"
chmod 755 "${OUT_DIR}/deb${PREFIX}/bin/flash-execute"
find "${OUT_DIR}/deb${PREFIX}/lib/flash-termux/utils" -type f -exec chmod 644 {} \;

cd "${OUT_DIR}/deb"
dpkg-deb -Zxz -b . "${OUT_DIR}/${DEB_NAME}"

echo "=== Package Structure ==="
dpkg -c "${OUT_DIR}/${DEB_NAME}"
echo "=== Package Metadata ==="
dpkg -I "${OUT_DIR}/${DEB_NAME}"

if [ -n "$GITHUB_WORKSPACE" ]; then
    echo "deb_path=${OUT_DIR}/${DEB_NAME}" >> $GITHUB_OUTPUT
fi

echo "=== Finish Build ==="
echo "Package successfully built: ${OUT_DIR}/${DEB_NAME}"
