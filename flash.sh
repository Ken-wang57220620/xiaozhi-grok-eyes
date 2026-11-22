#!/usr/bin/env bash
# 小智 Grok 眼睛固件 - 一键烧写（Linux / macOS）
# 用法：./flash.sh /dev/ttyUSB0
set -e
PORT=${1:-/dev/ttyUSB0}
BAUD=921600
HERE="$(cd "$(dirname "$0")" && pwd)/firmware"

python3 -m esptool --chip esp32s3 -p "$PORT" -b "$BAUD" \
  --before default_reset --after hard_reset write_flash -z \
  0x0      "$HERE/bootloader.bin" \
  0x8000   "$HERE/partition-table.bin" \
  0xd000   "$HERE/ota_data_initial.bin" \
  0x20000  "$HERE/xiaozhi.bin" \
  0x800000 "$HERE/generated_assets.bin"

echo "烧写完成，设备会自动重启。"
