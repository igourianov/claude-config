@echo off
setlocal enabledelayedexpansion

set "REPO_DIR=%~dp0symlinks"
set "TARGET_DIR=%USERPROFILE%\.claude"

echo Installing symlinks from %REPO_DIR% to %TARGET_DIR%
echo.

:: Symlink each file in symlinks/
for %%F in ("%REPO_DIR%\*") do (
    set "FILENAME=%%~nxF"
    set "LINK=%TARGET_DIR%\!FILENAME!"
    if exist "!LINK!" del "!LINK!"
    mklink "!LINK!" "%%F"
)

:: Symlink each directory in symlinks/
for /d %%D in ("%REPO_DIR%\*") do (
    set "DIRNAME=%%~nxD"
    set "LINK=%TARGET_DIR%\!DIRNAME!"
    if exist "!LINK!" rmdir "!LINK!"
    mklink /d "!LINK!" "%%D"
)

echo.
echo Done.
