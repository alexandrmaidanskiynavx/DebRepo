#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PKG="$1"
REPO_DIR="/repo"
INCOMING="$REPO_DIR/incoming"

echo ">>> Update and install tools..."
apt-get update -qq
apt-get install -y -qq apt-rdepends apt-utils dpkg-dev ca-certificates

mkdir -p "$INCOMING"
TMP="$(mktemp -d /tmp/debfetch.XXXX)"
cd "$TMP"

echo ">>> Gathering dependency list for $PKG"
apt-rdepends "$PKG" | grep -v '^ ' | sort -u > deps.txt

echo ">>> Downloading packages..."
while read p; do
  echo "Downloading: $p"
  apt-get download "$p" || echo "⚠️ Failed to download $p"
done < deps.txt

echo ">>> Moving .deb files to incoming..."
shopt -s nullglob
mv -v ./*.deb "$INCOMING/" 2>/dev/null || true
shopt -u nullglob

echo ">>> Clean up"
rm -rf "$TMP"

echo "✅ Done. .deb files placed in $INCOMING"
