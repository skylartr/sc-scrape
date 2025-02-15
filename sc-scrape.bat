@echo off
title sc-scrape
chcp 65001 >nul
mode 350
setlocal enabledelayedexpansion

call :ascii_art

set "artistList=artists.txt"
set "downloadPath=%CD%\SoundCloudDownloads"

if not exist "%downloadPath%" mkdir "%downloadPath%"

for /f "tokens=*" %%A in (%artistList%) do (
    set "url=%%A"

    for %%B in (!url!) do set "artistName=%%~nxB"

    set "artistFolder=%downloadPath%\!artistName!"

    echo.
    echo Downloading tracks for !artistName!...

    if not exist "!artistFolder!" mkdir "!artistFolder!"

    scdl -l "!url!" -t -c --path "!artistFolder!" --hide-progress > nul 2>&1

    echo Finished downloading for !artistName!
)

echo.
echo All downloads completed!
pause
exit /b

:ascii_art
echo.
echo  ▄▀▀▀▀▄  ▄▀▄▄▄▄   ▄▀▀▀▀▄  ▄▀▄▄▄▄   ▄▀▀▄▀▀▀▄  ▄▀▀█▄   ▄▀▀▄▀▀▀▄  ▄▀▀█▄▄▄▄
echo █ █   ▐ █ █    ▌ █ █   ▐ █ █    ▌ █   █   █ ▐ ▄▀ ▀▄ █   █   █ ▐  ▄▀   ▐
echo    ▀▄   ▐ █         ▀▄   ▐ █      ▐  █▀▀█▀    █▄▄▄█ ▐  █▀▀▀▀    █▄▄▄▄▄ 
echo ▀▄   █    █      ▀▄   █    █       ▄▀    █   ▄▀   █    █        █    ▌ 
echo  █▀▀▀    ▄▀▄▄▄▄▀  █▀▀▀    ▄▀▄▄▄▄▀ █     █   █   ▄▀   ▄▀        ▄▀▄▄▄▄  
echo  ▐      █     ▐   ▐      █     ▐  ▐     ▐   ▐   ▐   █          █    ▐  
echo         ▐                ▐                          ▐          ▐       
echo =========================================//sky14r//====================
echo.
exit /b
