@echo off
title sc-scrape
chcp 65001 >nul
mode 350
setlocal enabledelayedexpansion

call :ascii_art

set "artistList=artists.txt"
set "tokenFile=token.txt"
set "cookieFile=cookies.txt"
set "downloadPath=%CD%\SoundCloudDownloads"

if not exist "%downloadPath%" mkdir "%downloadPath%"

set "authArg="
if exist "%tokenFile%" (
    set /p token=<"%tokenFile%"
    if defined token (
        set "authArg=--auth-token !token!"
        echo Using auth token from %tokenFile%
    )
) else (
    echo No %tokenFile% found, running without a token.
)

set "ytArgs=--sleep-requests 1 --sleep-interval 1 --max-sleep-interval 3"
if exist "%cookieFile%" (
    set "ytArgs=--cookies %cookieFile% !ytArgs!"
    echo Using cookies from %cookieFile%
)

echo Logging to scdl.log
echo ========================= > scdl.log

for /f "tokens=*" %%A in (%artistList%) do (
    set "url=%%A"

    for %%B in (!url!) do set "artistName=%%~nxB"

    set "artistFolder=%downloadPath%\!artistName!"

    echo.
    echo Downloading tracks for !artistName!...

    if not exist "!artistFolder!" mkdir "!artistFolder!"

    scdl -l "!url!" -a -c !authArg! --download-archive "!artistFolder!\archive.txt" --path "!artistFolder!" --yt-dlp-args "!ytArgs!" >> scdl.log 2>&1

    echo Finished downloading for !artistName!
)
echo.
echo all downloads complete
echo check scdl.log if errors occur
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
