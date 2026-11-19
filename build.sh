#!/bin/sh
set -eu
cd "$(dirname "$0")"
app="build/P4G Patcher.app"
mkdir -p "$app/Contents/MacOS"
xcrun swiftc -O -module-cache-path "${TMPDIR:-/tmp}/p4g-swift-cache" main.swift -o "$app/Contents/MacOS/Patcher"
cp Info.plist "$app/Contents/"
mkdir -p "$app/Contents/Resources"
cp AppIcon.icns "$app/Contents/Resources/"
codesign --force --sign - "$app"
