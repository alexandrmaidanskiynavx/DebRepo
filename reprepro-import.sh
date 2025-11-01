#!/usr/bin/env bash
set -euo pipefail

REPO="/home/alexandr/Debrepo"
INCOMING="$REPO/incoming"

if [ ! -d "$INCOMING" ]; then
  echo "No incoming folder: $INCOMING"
  exit 1
fi

shopt -s nullglob
for f in "$INCOMING"/*.deb; do
  echo "Including $f ..."
  reprepro -b "$REPO" includedeb bookworm "$f"
  mkdir -p "$REPO/processed"
  mv -v "$f" "$REPO/processed/" || true
done
shopt -u nullglob

echo "Exporting indices..."
reprepro -b "$REPO" export

echo "Done."
