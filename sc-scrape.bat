@echo off
setlocal enabledelayedexpansion

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

    :: Fetch the total number of tracks (silent API request)
    for /f "delims=" %%T in ('scdl -l "!url!" --show --no-download 2^>nul ^| find "Number of tracks:"') do (
        for /f "tokens=4" %%N in ("%%T") do set "totalTracks=%%N"
    )

    if not defined totalTracks set "totalTracks=Unknown"

    echo Total tracks to download: !totalTracks!

    set /a count=0
    :: Use a loop to download each track individually
    for /f "delims=" %%T in ('scdl -l "!url!" -t --path "!artistFolder!" --hide-progress 2^>nul') do (
        set /a count+=1
        call :show_progress !count! !totalTracks!
    )

    echo.
    echo Fetching profile data for !artistName!...

    :: Get metadata JSON
    youtube-dl --write-info-json --skip-download "!url!" -o "!artistFolder!\metadata" >nul 2>&1

    :: Extract profile picture
    for /f "delims=" %%i in ('powershell -Command "(Get-Content '!artistFolder!\metadata.info.json' | ConvertFrom-Json).thumbnail"') do set "profileImage=%%i"
    if defined profileImage (
        echo Downloading profile picture...
        curl -s "!profileImage!" -o "!artistFolder!\profile.jpg"
    )

    :: Extract header image
    for /f "delims=" %%i in ('powershell -Command "(Get-Content '!artistFolder!\metadata.info.json' | ConvertFrom-Json).background_image_url"') do set "headerImage=%%i"
    if defined headerImage (
        echo Downloading header image...
        curl -s "!headerImage!" -o "!artistFolder!\header.jpg"
    )

    :: Cleanup metadata JSON
    del "!artistFolder!\metadata.info.json" 2>nul

    echo.
    echo Finished downloading for !artistName!
)

echo.
echo All downloads completed!
pause
exit /b

:: Function to show progress bar
:show_progress
cls
set /a percent=(%1*100)/%2
set "bar="
for /l %%i in (1,1,%percent%) do set "bar=!bar!#"
echo [!bar!]
echo Progress: %1 / %2 (%percent%%)
exit /b
