@echo off
title sc-scrape
chcp 65001 >nul
mode 350
setlocal enabledelayedexpansion

call :ascii_art

set "artistList=artists.txt"
set "downloadPath=%CD%\SoundCloudDownloads"

if not exist "%downloadPath%" mkdir "%downloadPath%"

echo Logging to scdl.log
echo ========================= > scdl.log

for /f "tokens=*" %%A in (%artistList%) do (
    set "url=%%A"

    for %%B in (!url!) do set "artistName=%%~nxB"

    set "artistFolder=%downloadPath%\!artistName!"

    echo.
    echo Downloading tracks for !artistName!...

    if not exist "!artistFolder!" mkdir "!artistFolder!"

    scdl -l "!url!" -a -c --path "!artistFolder!" >> scdl.log 2>&1

    echo Finished downloading for !artistName!
)
echo.
echo All downloads completed!
echo Check scdl.log if something didn't download.
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
