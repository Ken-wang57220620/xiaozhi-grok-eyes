@echo off
chcp 65001 >nul
setlocal

REM ============================================================
REM  小智 Grok 眼睛固件 - 一键烧写（Windows）
REM  适配：ESP32-S3-N16R8 + 1.54" ST7789 240x240 + bread-compact-wifi-lcd
REM  需要：Python 3 + esptool  (pip install esptool)
REM  端口：默认 COM3，可改成 COM5 / COM7 ...
REM ============================================================

set PORT=COM3
set BAUD=921600
set HERE=%~dp0firmware

echo.
echo   即将烧写到 %PORT%
echo   0x0      bootloader.bin
echo   0x8000   partition-table.bin
echo   0xd000   ota_data_initial.bin
echo   0x20000  xiaozhi.bin
echo   0x800000 generated_assets.bin
echo.
pause

python -m esptool --chip esp32s3 -p %PORT% -b %BAUD% --before default_reset --after hard_reset write_flash -z ^
  0x0      "%HERE%\bootloader.bin" ^
  0x8000   "%HERE%\partition-table.bin" ^
  0xd000   "%HERE%\ota_data_initial.bin" ^
  0x20000  "%HERE%\xiaozhi.bin" ^
  0x800000 "%HERE%\generated_assets.bin"

echo.
if %ERRORLEVEL%==0 (
  echo   烧写完成，设备会自动重启。
) else (
  echo   烧写失败：检查 USB 线、端口号、是否处于下载模式。
)
pause
