#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_PATH="${1:-/Applications/MacTorrServer.app}"
OUTPUT_DIR="${2:-$PROJECT_DIR/dist}"
DMG_PATH="$OUTPUT_DIR/MacTorrServer-1.0.0.dmg"
STAGING_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

if [[ ! -d "$APP_PATH" ]]; then
    printf 'App not found: %s\nBuild and install it first with: bash scripts/install-app.sh\n' "$APP_PATH" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
mkdir -p "$STAGING_DIR/MacTorrServer"
cp -R "$APP_PATH" "$STAGING_DIR/MacTorrServer/MacTorrServer.app"
ln -s /Applications "$STAGING_DIR/MacTorrServer/Applications"

hdiutil create \
    -volname "MacTorrServer" \
    -srcfolder "$STAGING_DIR/MacTorrServer" \
    -format UDZO \
    -ov \
    "$DMG_PATH" >/dev/null

printf 'Created: %s\n' "$DMG_PATH"
