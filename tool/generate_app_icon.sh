#!/usr/bin/env bash
# Regenerates assets/images/app_icon_master.png and platform launcher icons
# from assets/icon/logo_05_app_icon.svg (Expiry Deals Logo-05).
set -euo pipefail
cd "$(dirname "$0")/.."
RSVG="${RSVG_CONVERT:-}"
if [[ -z "$RSVG" ]]; then
  RSVG="$(command -v rsvg-convert || true)"
fi
if [[ -z "$RSVG" && -x /opt/homebrew/bin/rsvg-convert ]]; then
  RSVG=/opt/homebrew/bin/rsvg-convert
fi
if [[ -z "$RSVG" || ! -x "$RSVG" ]]; then
  echo "rsvg-convert not found. Install: brew install librsvg (or set RSVG_CONVERT)" >&2
  exit 1
fi
# High-res raster, then pad: fraction = max share of 1024² for logo (higher = larger mark, less white rim).
"$RSVG" -w 1024 assets/icon/logo_05_app_icon.svg -o assets/images/logo05_raster_temp.png
dart run tool/pad_app_icon.dart 0.86 assets/images/logo05_raster_temp.png
dart run flutter_launcher_icons
echo "Done. Rebuild the iOS app to refresh the home-screen icon."
