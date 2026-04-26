#!/usr/bin/env sh

set -eu

# ===== UI =====
info()    { printf "\033[0;36m-> %s\033[0m\n" "$1"; }
error()   { printf "\033[0;31mx %s\033[0m\n" "$1"; }
success() { printf "\033[0;32m* %s\033[0m\n" "$1"; }

# ===== Check =====
if ! command -v makepkg >/dev/null 2>&1; then
  error "makepkg not found"
  exit 1
fi

CMD="${1:-install}"

case "$CMD" in
  build)
    info "Building package..."
    makepkg -sf --noconfirm
    success "Build complete"
    ;;

  install)
    info "Building and installing package..."
    makepkg -sfi --noconfirm
    success "Install complete"
    ;;

  clean)
    info "Cleaning build files..."
    rm -rf pkg src ./*.pkg.tar.* LICENSE smog-*
    success "Clean complete"
    ;;

  *)
    error "Unknown command: $CMD"
    printf "Usage: %s [build|install|clean]\n" "$0"
    exit 1
    ;;
esac