@echo off

:: Get current date and time
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set mydate=%%c%%a%%b
)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (
    set mytime=%%a%%b
)
set datestamp=%mydate%-%mytime%
set datestamp=%datestamp: =%

:: Set paths
set repoURL=https://github.com/IGORSVOLOHOVS/JuliaTemplate.git
set "cloneDir=%TEMP%\%datestamp%"
:: --- Modified: Use %USERPROFILE% for user's home directory ---
set "targetDir=%USERPROFILE%\Projects\Task-%datestamp%"

:: Create the target directory (including the Projects directory if it doesn't exist)
if not exist "%targetDir%" mkdir "%targetDir%" || (
    echo Failed to create target directory
    pause
    exit /b 1
)

:: Clone the repository (sparse checkout)
git clone -n --depth=1 --filter=tree:0 "%repoURL%" "%cloneDir%" || (
    echo Git clone failed
    pause
    exit /b 1
)

:: Change directory and set up sparse checkout
pushd "%cloneDir%" || (
    echo Failed to change directory to cloneDir
    pause
    exit /b 1
)
git sparse-checkout set --no-cone template || (
    echo Sparse checkout failed
    pause
    exit /b 1
)
git checkout || (
    echo Git checkout failed
    pause
    exit /b 1
)
popd

:: Copy *contents* of template to the target directory.
xcopy "%cloneDir%\template\*" "%targetDir%" /E /I /H /Y || (
  echo Copy failed.
  pause
  exit /b 1
)

:: Initialize a new Git repository in the target directory
pushd "%targetDir%" || (
    echo Failed to change directory to targetDir
    pause
    exit /b 1
)
git init || (
    echo Git init failed
    pause
    exit /b 1
)
popd

:: Open the target directory in VS Code (if installed)
where code > nul 2>&1
if %errorlevel% equ 0 (
    code "%targetDir%"
) else (
    echo VS Code (code) not found.  Skipping opening the directory.
)

:: Remove the temporary clone directory
rmdir /s /q "%cloneDir%" 2> nul
if %errorlevel% neq 0 (
  echo Warning: Failed to remove temporary directory: %cloneDir%
)

echo Script completed successfully.  Project directory: %targetDir%
pause
exit /b 0