@echo off
setlocal enabledelayedexpansion

set "tempFile=%temp%\ouch.ogg"
set "fileUrl=https://raw.githubusercontent.com/Alpointernet/oof/main/ouch.ogg"
set "versionsFolder=%LocalAppData%\Roblox\Versions"

if exist "%tempFile%" del /f /q "%tempFile%"

echo Downloading sound from:
echo     %fileUrl%
echo.

powershell -Command "try { Invoke-WebRequest -Uri '%fileUrl%' -OutFile '%tempFile%' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 (
    echo.
    echo ERROR: Failed to download sound from URL.
    pause
    exit /b
)

if not exist "%tempFile%" (
    echo.
    echo ERROR: Downloaded sound file not found.
    pause
    exit /b
)
for %%F in ("%tempFile%") do if %%~zF leq 0 (
    echo.
    echo ERROR: Downloaded sound file is empty.
    pause
    exit /b
)

echo Download successful.
echo Replacing sound in Roblox versions...
echo.

set "replacedCount=0"
for /d %%V in ("%versionsFolder%\*") do (
    set "targetPath=%%V\content\sounds\ouch.ogg"
    if exist "!targetPath!" (
        echo [+] Replacing sound in: %%~nxV
        del /f /q "!targetPath!"
        copy /y "%tempFile%" "!targetPath!" >nul
        if exist "!targetPath!" (
            for %%S in ("!targetPath!") do echo     Success! Size: %%~zS bytes
            echo.
            set /a replacedCount+=1
        ) else (
            echo     ERROR: Failed to replace sound in %%~nxV
            echo.
        )
    ) else (
        echo [-] Sound not found in %%~nxV, skipping.
        echo.
    )
)

echo Total versions updated: %replacedCount%
echo.

pause