@echo off
pushd %~dp0

REM Check if Git is installed
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed on this system.
    echo Install it from https://git-scm.com/downloads
    goto end
) else (
    REM Check if this is a Git repository
    if not exist .git (
        echo Not running from a Git repository. Reinstall using an officially supported method to get updates.
        echo See: https://docs.sillytavern.app/installation/windows/
        goto end
    )
    
    REM Pull updates from upstream instead of origin
    call git fetch upstream
    call git rebase upstream/release --autostash
    if %errorlevel% neq 0 (
        REM incase there is still something wrong
        echo There were errors while updating.
        echo See the update FAQ at https://docs.sillytavern.app/installation/updating/
        goto end
    )
)

REM Set Node environment and install dependencies
set NODE_ENV=production
REM call npm install --no-save --no-audit --no-fund --loglevel=error --no-progress --omit=dev --ignore-scripts
call npm install --no-save --no-audit --no-fund --loglevel=error --no-progress --omit=dev

REM Start the server
node server.js %*

:end
pause
popd