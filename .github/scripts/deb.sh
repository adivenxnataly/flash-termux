#!/bin/bash
set -e

PREFIX="/data/data/com.termux/files/usr"
VERSION=$(cat deb/share/.flash_version)
OUT_DIR="${GITHUB_WORKSPACE}/out"
DEB_NAME="flash-termux_${VERSION}.deb"

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}/deb${PREFIX}/bin"
mkdir -p "${OUT_DIR}/deb${PREFIX}/share/flash-termux"
mkdir -p "${OUT_DIR}/deb/DEBIAN"

install -m 755 src/flash "${OUT_DIR}/deb${PREFIX}/bin/"
install -m 755 src/flash-extract "${OUT_DIR}/deb${PREFIX}/bin/"
install -m 755 src/flash-execute "${OUT_DIR}/deb${PREFIX}/bin/"

install -m 644 deb/share/.flash_version "${OUT_DIR}/deb${PREFIX}/share/flash-termux/"

sed "s/\$(cat ..\/share\/.flash_version)/${VERSION}/" \
    deb/dpkg-conf/control > "${OUT_DIR}/deb/DEBIAN/control"

cat > "${OUT_DIR}/deb/DEBIAN/postinst" <<EOF
#!/bin/sh
termux-setup-storage
mkdir -p \$HOME/flash-termux/logs
EOF
chmod 755 "${OUT_DIR}/deb/DEBIAN/postinst"

dpkg-deb -b "${OUT_DIR}/deb" "${OUT_DIR}/${DEB_NAME}"

echo "=== Package Contents ==="
dpkg -c "${OUT_DIR}/${DEB_NAME}"
echo "=== Package Metadata ==="
dpkg -I "${OUT_DIR}/${DEB_NAME}"

if [ -n "$GITHUB_WORKSPACE" ]; then
    echo "deb_path=${OUT_DIR}/${DEB_NAME}" >> $GITHUB_OUTPUT
fi

echo "Package built: ${OUT_DIR}/${DEB_NAME}"
