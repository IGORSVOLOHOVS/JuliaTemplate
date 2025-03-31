@echo off

:: Get current date and time reliably using WMIC
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get year /format:list') do set year=%%I
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get month /format:list') do set month=%%I
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get day /format:list') do set day=%%I
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get hour /format:list') do set hour=%%I
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get minute /format:list') do set minute=%%I
for /f "tokens=2 delims==" %%I in ('wmic path win32_localtime get second /format:list') do set second=%%I

:: Pad single digits with leading zero for consistent format (YYYYMMDD-HHMMSS)
if %month% lss 10 set month=0%month%
if %day% lss 10 set day=0%day%
if %hour% lss 10 set hour=0%hour%
if %minute% lss 10 set minute=0%minute%
if %second% lss 10 set second=0%second%

:: Create the final timestamp string
set datestamp=%year%%month%%day%-%hour%%minute%%second%

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
code.cmd "%targetDir%"

:: Remove the temporary clone directory
rmdir /s /q "%cloneDir%" 2> nul
:: --- MODIFIED LINE BELOW ---
if errorlevel 1 (
    echo Warning: Failed to remove temporary directory: %cloneDir%
)

echo Script completed successfully.  Project directory: %targetDir%
pause
exit /b 0
