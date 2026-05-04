#!/usr/bin/env bash
set -eu

ROOTFS="${1:-system}"

if [ ! -d "$ROOTFS" ]; then
  echo "Missing firmware system folder: $ROOTFS" >&2
  echo "Usage: bash scripts/audit-system.sh [path-to-system-folder]" >&2
  exit 1
fi

REPORT_DIR="reports"
REPORT="$REPORT_DIR/system-audit.txt"
mkdir -p "$REPORT_DIR"

section() {
  printf '\n## %s\n' "$1" | tee -a "$REPORT"
}

: > "$REPORT"
echo "Timmkoo system audit" | tee -a "$REPORT"
echo "Root: $ROOTFS" | tee -a "$REPORT"
echo "Date: $(date -u '+%Y-%m-%dT%H:%M:%SZ')" | tee -a "$REPORT"

section "Top-level folders"
find "$ROOTFS" -maxdepth 2 -type d | sort | tee -a "$REPORT"

section "APK packages"
find "$ROOTFS" -type f -name '*.apk' | sort | tee -a "$REPORT"

section "Likely internet/network apps by filename"
find "$ROOTFS" -type f \( -name '*.apk' -o -name '*.jar' -o -name '*.xml' -o -name '*.rc' \) \
  | grep -Ei 'browser|webview|wifi|wlan|ota|update|cloud|sync|push|analytics|adservice|crash|download|network|share|zapya|minishare|email|maps|youtube|chrome|google|facebook|twitter|tiktok|instagram' \
  | sort | tee -a "$REPORT" || true

section "Init files"
find "$ROOTFS" -type f \( -name 'init*.rc' -o -path '*/etc/init/*' \) | sort | tee -a "$REPORT"

section "Network-related init/service lines"
find "$ROOTFS" -type f \( -name '*.rc' -o -name '*.prop' -o -name '*.conf' -o -name '*.xml' \) -print0 \
  | xargs -0 grep -InEi 'wifi|wlan|wpa|dhcp|netd|dns|ota|update|telemetry|analytics|crash|upload|download|http|https' 2>/dev/null \
  | tee -a "$REPORT" || true

section "Permission files mentioning internet/network"
find "$ROOTFS" -type f -path '*/etc/permissions/*' -print0 \
  | xargs -0 grep -InEi 'INTERNET|ACCESS_NETWORK_STATE|ACCESS_WIFI_STATE|CHANGE_WIFI_STATE|BLUETOOTH|RECEIVE_BOOT_COMPLETED|WAKE_LOCK' 2>/dev/null \
  | tee -a "$REPORT" || true

section "Build properties"
find "$ROOTFS" -type f -name 'build.prop' -print0 \
  | xargs -0 cat 2>/dev/null \
  | tee -a "$REPORT" || true

section "Largest files"
find "$ROOTFS" -type f -printf '%s %p\n' 2>/dev/null \
  | sort -nr \
  | head -50 \
  | awk '{ size=$1; $1=""; printf "%.2f MB%s\n", size/1024/1024, $0 }' \
  | tee -a "$REPORT" || true

section "Suggested first removal candidates"
cat <<'EOF' | tee -a "$REPORT"
Start by reviewing browser, OTA/update, Wi-Fi share/import, cloud/sync, telemetry, analytics, ad, and social packages.
Do not delete core framework, launcher, system UI, media provider, storage provider, audio libraries, or package manager until dependencies are known.
EOF

echo "\nWrote $REPORT"
