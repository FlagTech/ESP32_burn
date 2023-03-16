@echo off
REM change to UTF-8
REM chcp 65001
set fname=
set dummy=
set /a total = 1

:prepare
if "%1"=="" (
  echo �Ϊk�G
  echo    run �����ɸ��|
  goto end
)
if not exist %1 goto invalid_file
set fname=%1
echo %fname:~-3% file existed.
if /I "%fname:~-3%"=="bin" goto start

:invalid_file
set /p dummy="�䤣�� bin �ɩΤ��O bin  ��, �нƻs�ɮ׫�� Enter �~�� (��J q ���})"
if "%dummy%"=="q" (
    goto end
) else (
    goto prepare
)

:start
echo �����ɡG%fname%
set /p port="��J�s���� (��J q ���})�G"
if "%port%"=="q" goto end

:next
esptool.exe --chip esp32 --port COM13 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size 4MB 0x10000 %fname%
if errorlevel 1 (
    set /p dummy="�I�I�I�N������, �n�A�դ@���Ъ����� Enter... (��J q ���})"
) else (
    set /p dummy="�� %total% ���N������, �д��U�@����� Enter �~��... (��J q ���})"
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
