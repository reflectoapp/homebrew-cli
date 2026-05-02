#!/usr/bin/env sh
# Reflecto CLI installer.
#
# Detects platform + architecture, downloads the matching binary from the
# latest release, verifies its sha256 against the manifest, and installs to
# /usr/local/bin (falling back to ~/.local/bin if /usr/local isn't writable).
#
# Manual install: download from https://github.com/reflectoapp/reflecto-binaries/releases.

set -eu

REPO="reflectoapp/reflecto-binaries"
RELEASES_API="https://api.github.com/repos/${REPO}/releases/latest"
RELEASES_DL="https://github.com/${REPO}/releases/download"
BINARY_NAME="reflecto"

# ─── helpers ───────────────────────────────────────────────────────────────
say() { printf "  %s\n" "$1"; }
err() { printf "  ✗ %s\n" "$1" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || err "missing required command: $1"
}

# ─── detect platform + arch ────────────────────────────────────────────────
require_cmd uname
require_cmd curl

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) os_token="darwin" ;;
  Linux)  os_token="linux"  ;;
  *)      err "Unsupported OS: $OS. Windows users: download from https://github.com/${REPO}/releases manually." ;;
esac

case "$ARCH" in
  arm64|aarch64) arch_token="arm64" ;;
  x86_64|amd64)  arch_token="x64" ;;
  *) err "Unsupported architecture: $ARCH" ;;
esac

asset="${BINARY_NAME}-${os_token}-${arch_token}"

# ─── pick install dir ──────────────────────────────────────────────────────
if [ -w /usr/local/bin ] 2>/dev/null; then
  install_dir="/usr/local/bin"
elif [ "$(id -u)" -eq 0 ]; then
  install_dir="/usr/local/bin"
else
  install_dir="$HOME/.local/bin"
  mkdir -p "$install_dir"
fi

# ─── resolve latest release ────────────────────────────────────────────────
say "Fetching latest release tag…"
require_cmd grep
require_cmd cut

# Avoid jq dependency: parse "tag_name" with grep/cut.
tag="$(curl -fsSL "$RELEASES_API" | grep '"tag_name":' | head -1 | cut -d'"' -f4)"
[ -n "$tag" ] || err "Could not resolve latest release tag from $RELEASES_API"
say "Latest release: $tag"

# ─── download binary + manifest ───────────────────────────────────────────
require_cmd mktemp
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

say "Downloading $asset…"
curl -fsSL -o "$tmp/$asset" "$RELEASES_DL/$tag/$asset"

say "Downloading sha256sums.txt…"
curl -fsSL -o "$tmp/sha256sums.txt" "$RELEASES_DL/$tag/sha256sums.txt"

# ─── verify sha256 ─────────────────────────────────────────────────────────
expected="$(grep "  $asset\$" "$tmp/sha256sums.txt" | cut -d' ' -f1)"
[ -n "$expected" ] || err "$asset not found in sha256sums.txt"

if command -v sha256sum >/dev/null 2>&1; then
  actual="$(sha256sum "$tmp/$asset" | cut -d' ' -f1)"
elif command -v shasum >/dev/null 2>&1; then
  actual="$(shasum -a 256 "$tmp/$asset" | cut -d' ' -f1)"
else
  err "missing sha256sum / shasum — install one first"
fi

[ "$expected" = "$actual" ] || err "sha256 mismatch — expected $expected got $actual"
say "✓ sha256 verified"

# ─── install ───────────────────────────────────────────────────────────────
chmod +x "$tmp/$asset"
mv "$tmp/$asset" "$install_dir/$BINARY_NAME"
say "✓ Installed: $install_dir/$BINARY_NAME"

# ─── post-install hints ────────────────────────────────────────────────────
case "$os_token" in
  darwin)
    say ""
    say "macOS: the binary is unsigned. On first run, Gatekeeper may block it."
    say "If so, run once:"
    say "    xattr -d com.apple.quarantine $install_dir/$BINARY_NAME"
    say ""
    ;;
esac

# Warn if install_dir isn't on PATH.
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    say "Note: $install_dir is not on your PATH. Add this to your shell rc:"
    say "    export PATH=\"$install_dir:\$PATH\""
    say ""
    ;;
esac

say "Try:  $BINARY_NAME pair"
