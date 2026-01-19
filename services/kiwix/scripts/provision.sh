#!/bin/bash

TGTDIR="${1:-/usr/local/bin}"
VERSION="${VERSION:-3.1.2-4}"
MACHINE="${MACHINE:-$(uname -m)}"
URL="${URL:-"https://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-${MACHINE}-${VERSION}.tar.gz"}"
DLPATH=${DLPATH:-/tmp}
FILE="$DLPATH/${URL##*/}"

# Install kiwix-tools from binary tarball
set -x -e
wget -O "$FILE" "$URL"
tar -xvf "$FILE" -C "$TGTDIR" --strip-components 1
rm -f "$FILE"
