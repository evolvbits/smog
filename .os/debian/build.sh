#!/usr/bin/env bash

# Author: William C. Canin <https://williamcanin.github.io>

set -euo pipefail

# ----- Config -----
NAME="smog"
VERSION="$1"
REPO="evolvbits/smog"
ARCH="amd64"
BASE_URL="https://github.com/${REPO}"
BIN_NAME="${NAME}-${VERSION}-linux-x86_64"
DEB_DIR="${NAME}_${VERSION}_${ARCH}"
BIN_URL="${BASE_URL}/releases/download/v${VERSION}/${BIN_NAME}"
LICENSE_URL="${BASE_URL}/raw/main/LICENSE"
TMP_DIR=$(mktemp -d)
REQUIRED=("curl")

# ----- Libs -----
title () {
  printf "\e[0;35m[ %s\e[0m\n" "$1 ]"
}

info () {
  printf "\e[0;36m-> %s\e[0m\n" "$1"
}

warning () {
  printf "\e[0;33m! %s\e[0m\n" "$1"
}

finish () {
  printf "\e[0;32m* %s\e[0m\n" "$1"
}

error () {
  printf "\e[0;31mx %s\e[0m\n" "$1"
}

main() {

  # ----- Ignore root user -----
  [ "$EUID" -eq 0 ] && { error "Do not run as root."; exit 1; }

  # ----- OS check -----
  [[ "$(uname -s)" != "Linux" ]] && {
    error "Linux only."
    exit 1
  }

  # ----- ARCH Check -----
  [[ "$(dpkg --print-architecture)" != "amd64" ]] && {
    error "Only amd64 supported."
    exit 1
  }

  # ----- Required check -----
  for bin in "${REQUIRED[@]}"; do
    command -v "$bin" >/dev/null || {
      error "Missing dependency: $bin"
      exit 1
    }
  done

  # ----- Cleanup -----
  rm -rf "$DEB_DIR"
  mkdir -p "$DEB_DIR/DEBIAN" \
           "$DEB_DIR/usr/bin" \
           "$DEB_DIR/usr/share/licenses/$NAME"

  # ----- Download -----
  title "Downloading binary..."
  curl -fL "$BIN_URL" -o "tmp/$BIN_NAME"

  title "Downloading LICENSE..."
  curl -fL "$LICENSE_URL" -o "tmp/LICENSE"

  [ -s "$TMP_DIR/$BIN_NAME" ] || { error "Binary download failed"; exit 1; }

  # ----- Install files -----
  title "Install files..."
  install -Dm755 "tmp/$BIN_NAME" \
    "$DEB_DIR/usr/bin/$NAME"

  install -Dm644 "tmp/LICENSE" \
    "$DEB_DIR/usr/share/licenses/$NAME/LICENSE"


  # ----- Control file -----
  cat > "$DEB_DIR/DEBIAN/control" <<EOF
Package: $NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: William Canin <seu@email.com>
Depends: libc6
Description: Turn data into unreadable noise.
 A CLI tool that transforms input data into unreadable noise.
EOF

  # ----- Build -----
  title "Building a .deb package..."
  dpkg-deb --build "$DEB_DIR"

  # ----- Cleanup temp -----
  rm -rf "$TMP_DIR"

  finish "Done! ${DEB_DIR}.deb"
}


if [ -z "${1:-}" ]; then
  warning "Usage: $0 <version>"
  exit 1
fi

main "$1"