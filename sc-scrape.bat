@echo off
title sc-scrape
chcp 65001 >nul
mode 350
setlocal enabledelayedexpansion

:: Function to print ASCII art
call :ascii_art

:: Define paths
set "artistList=artists.txt"
set "downloadPath=%CD%\SoundCloudDownloads"

:: Ensure the main download folder exists
if not exist "%downloadPath%" mkdir "%downloadPath%"

:: Read each line from artists.txt
for /f "tokens=*" %%A in (%artistList%) do (
    set "url=%%A"

    :: Extract artist name from URL (last part of URL)
    for %%B in (!url!) do set "artistName=%%~nxB"

    set "artistFolder=%downloadPath%\!artistName!"

    echo.
    echo Downloading tracks for !artistName!...

    :: Create artist folder
    if not exist "!artistFolder!" mkdir "!artistFolder!"

    :: Download tracks using scdl
    scdl -l "!url!" -t --path "!artistFolder!" --hide-progress > nul 2>&1

    echo Finished downloading for !artistName!
)

echo.
echo All downloads completed!
pause
exit /b

:: ASCII Art Function
:ascii_art
echo.
echo  ▄▀▀▀▀▄  ▄▀▄▄▄▄   ▄▀▀▀▀▄  ▄▀▄▄▄▄   ▄▀▀▄▀▀▀▄  ▄▀▀█▄   ▄▀▀▄▀▀▀▄  ▄▀▀█▄▄▄▄
echo █ █   ▐ █ █    ▌ █ █   ▐ █ █    ▌ █   █   █ ▐ ▄▀ ▀▄ █   █   █ ▐  ▄▀   ▐
echo    ▀▄   ▐ █         ▀▄   ▐ █      ▐  █▀▀█▀    █▄▄▄█ ▐  █▀▀▀▀    █▄▄▄▄▄ 
echo ▀▄   █    █      ▀▄   █    █       ▄▀    █   ▄▀   █    █        █    ▌ 
echo  █▀▀▀    ▄▀▄▄▄▄▀  █▀▀▀    ▄▀▄▄▄▄▀ █     █   █   ▄▀   ▄▀        ▄▀▄▄▄▄  
echo  ▐      █     ▐   ▐      █     ▐  ▐     ▐   ▐   ▐   █          █    ▐  
echo         ▐                ▐                          ▐          ▐       
echo.
exit /b
