#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="MacTorrServer"
SYSTEM_APPLICATIONS_DIR="/Applications"
USER_APPLICATIONS_DIR="$(osascript -e 'POSIX path of (path to applications folder from user domain)')"
APPLICATIONS_DIR="$SYSTEM_APPLICATIONS_DIR"
STAGING_DIR="$(mktemp -d)"
ICON_BUILD_DIR="$STAGING_DIR/icon-build"
STAGING_APP="$STAGING_DIR/$APP_NAME.app"
TORRSERVER_URL="https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-darwin-arm64"

cleanup() {
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

if [[ ! -w "$SYSTEM_APPLICATIONS_DIR" ]]; then
    APPLICATIONS_DIR="$USER_APPLICATIONS_DIR"
    mkdir -p "$APPLICATIONS_DIR"
fi

cd "$PROJECT_DIR"
swift build -c release

mkdir -p "$ICON_BUILD_DIR"
xcrun actool \
    --compile "$ICON_BUILD_DIR" \
    --platform macosx \
    --minimum-deployment-target 26.0 \
    --app-icon AppIcon \
    --output-partial-info-plist "$ICON_BUILD_DIR/PartialInfo.plist" \
    --standalone-icon-behavior all \
    Resources/AppIcon.icon >/dev/null

mkdir -p "$STAGING_APP/Contents/MacOS" "$STAGING_APP/Contents/Resources"
cp .build/release/MacTorrServer "$STAGING_APP/Contents/MacOS/MacTorrServer"
cp Resources/Info.plist "$STAGING_APP/Contents/Info.plist"
cp "$ICON_BUILD_DIR/Assets.car" "$STAGING_APP/Contents/Resources/Assets.car"
cp "$ICON_BUILD_DIR/AppIcon.icns" "$STAGING_APP/Contents/Resources/AppIcon.icns"
curl --fail --location --retry 3 --output "$STAGING_APP/Contents/Resources/TorrServer" "$TORRSERVER_URL"
chmod 755 "$STAGING_APP/Contents/MacOS/MacTorrServer" "$STAGING_APP/Contents/Resources/TorrServer"

APP_PATH="$APPLICATIONS_DIR/$APP_NAME.app"
if [[ -e "$APP_PATH" ]]; then
    BACKUP_PATH="$APPLICATIONS_DIR/$APP_NAME.backup-$(date +%Y%m%d-%H%M%S).app"
    mv "$APP_PATH" "$BACKUP_PATH"
    printf 'Previous version moved to: %s\n' "$BACKUP_PATH"
fi

mv "$STAGING_APP" "$APP_PATH"
printf 'Installed: %s\n' "$APP_PATH"
