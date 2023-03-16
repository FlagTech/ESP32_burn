@echo off
REM change to UTF-8
REM chcp 65001
set fname=
set dummy=
set /a total = 1

:prepare
if "%1"=="" (
  echo 用法：
  echo    run 韌體檔路徑
  goto end
)
if not exist %1 goto invalid_file
set fname=%1
echo %fname:~-3% file existed.
if /I "%fname:~-3%"=="bin" goto start

:invalid_file
set /p dummy="找不到 bin 檔或不是 bin  檔, 請複製檔案後按 Enter 繼續 (輸入 q 離開)"
if "%dummy%"=="q" (
    goto end
) else (
    goto prepare
)

:start
echo 韌體檔：%fname%
set /p port="輸入連接埠 (輸入 q 離開)："
if "%port%"=="q" goto end

:next
esptool.exe --chip esp32 --port COM13 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size 4MB 0x10000 %fname%
if errorlevel 1 (
    set /p dummy="！！！燒錄失敗, 要再試一次請直接按 Enter... (輸入 q 離開)"
) else (
    set /p dummy="第 %total% 片燒錄完成, 請換下一片後按 Enter 繼續... (輸入 q 離開)"
    set /a total=%total%+1
)

if "%dummy%"=="q" (
    goto end
) else (
    goto next
)

:end
REM change back to BIG5
REM exit batch file
exit /b 0
