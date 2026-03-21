@echo off
setlocal enabledelayedexpansion

for %%I in ("%~dp0..\symlinks") do set "REPO_DIR=%%~fI"
set "TARGET_DIR=%USERPROFILE%\.claude"

echo Installing symlinks from %REPO_DIR% to %TARGET_DIR%
echo.

:: Symlink each file in symlinks/
for %%F in ("%REPO_DIR%\*") do (
    set "FILENAME=%%~nxF"
    set "LINK=%TARGET_DIR%\!FILENAME!"
    del "!LINK!" 2>nul
    mklink "!LINK!" "%%F"
)

:: Symlink each directory in symlinks/
for /d %%D in ("%REPO_DIR%\*") do (
    set "DIRNAME=%%~nxD"
    set "LINK=%TARGET_DIR%\!DIRNAME!"
    rmdir /s /q "!LINK!" 2>nul
    mklink /d "!LINK!" "%%D"
)

echo.
echo Done.

pause