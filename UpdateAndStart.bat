@echo off
pushd %~dp0

REM -------------------------------
REM Check if Git is installed
REM -------------------------------
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed on this system.
    echo Install it from https://git-scm.com/downloads
    goto end
)

REM -------------------------------
REM Check if this is a Git repository
REM -------------------------------
if not exist .git (
    echo Not running from a Git repository. Reinstall using an officially supported method to get updates.
    echo See: https://docs.sillytavern.app/installation/windows/
    goto end
)

REM -------------------------------
REM Abort any in-progress rebase
REM -------------------------------
if exist ".git\rebase-merge" (
    echo Detected interrupted rebase. Aborting...
    git rebase --abort
)

REM -------------------------------
REM Pull updates safely from upstream
REM -------------------------------
echo Fetching updates from upstream...
git fetch upstream

REM Check if there are new commits to rebase
git rev-list HEAD..upstream/release --count > tmp_count.txt
set /p commits=<tmp_count.txt
del tmp_count.txt

if %commits% neq 0 (
    echo Rebasing %commits% commits from upstream/release...
    git rebase upstream/release --autostash
    if %errorlevel% neq 0 (
        echo Errors occurred during rebase.
        echo Resolve conflicts manually and run:
        echo   git rebase --continue
        goto end
    )
) else (
    echo Already up to date with upstream/release.
)

REM -------------------------------
REM Set Node environment and install dependencies
REM -------------------------------
set NODE_ENV=production
REM call npm install --no-save --no-audit --no-fund --loglevel=error --no-progress --omit=dev --ignore-scripts
call npm install --no-save --no-audit --no-fund --loglevel=error --no-progress --omit=dev

REM -------------------------------
REM Start the server
REM -------------------------------
node server.js %*

:end
pause
popd