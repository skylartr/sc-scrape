@echo off
setlocal enabledelayedexpansion

:: Check if artists.txt exists
if not exist artists.txt (
    echo artists.txt not found! Create the file and add SoundCloud profile links.
    pause
    exit /b
)

:: Loop through each line in artists.txt
for /f "tokens=*" %%A in (artists.txt) do (
    set "url=%%A"
    
    :: Extract artist name from the URL (last part after the last "/")
    for %%B in (!url!) do set "artist_name=%%~nxB"

    :: Remove special characters (just in case)
    set "artist_name=!artist_name: =_!"

    :: Define folder path
    set "folder_path=%CD%\!artist_name!"

    :: Create the artist's folder if it doesn't exist
    if not exist "!folder_path!" mkdir "!folder_path!"

    echo Downloading tracks for !artist_name! into "!folder_path!"...

    :: Run scdl with the correct parameters
    scdl -l "!url!" -t -c --path "!folder_path!" 

    echo Finished downloading !artist_name!
)

echo All downloads complete!
pause
