@echo off
:: Batch script to automatically install programs in subdirectories of the main default installation directory
:: Requires administrator privileges

echo Batch script running with administrative privileges...
echo.

:: Change the directory to the script's location
cd /d "%~dp0"

set "INSTALL_FOLDER=%~dp0"
set "DEFAULT_INSTALL_DIR=D:\trest"

:: Check for administrator privileges
NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Administrator privileges confirmed.
    goto :continue
) else (
    echo Please run this script as Administrator.
    pause
    exit /B
)

:continue

for %%i in ("%INSTALL_FOLDER%\*.exe", "%INSTALL_FOLDER%\*.msi") do (
    echo Installing %%~nxi...
    for /f "delims=" %%d in ('dir /b /ad "%DEFAULT_INSTALL_DIR%" ^| findstr /i /x "%%~ni"') do (
        set "INSTALL_DIR=%DEFAULT_INSTALL_DIR%\%%d"
    )
    if not defined INSTALL_DIR (
        mkdir "%DEFAULT_INSTALL_DIR%\%%~ni"
        set "INSTALL_DIR=%DEFAULT_INSTALL_DIR%\%%~ni"
    )
    
    if "%%~xi"==".exe" (
        start /wait "" "%%i" /S /D="%INSTALL_DIR%"
    ) else if "%%~xi"==".msi" (
        msiexec /i "%%i" /qn INSTALLDIR="%INSTALL_DIR%"
    )
)

echo All installations completed.

timeout /t 10 >nul
