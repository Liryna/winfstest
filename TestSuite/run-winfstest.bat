@echo off

set PythonExe=

rem Prefer Python 2 from PATH.
python -c "import sys; sys.exit(0 if sys.version_info[0] == 2 else 1)" >nul 2>&1
if not errorlevel 1 set PythonExe=python

rem Fall back to the traditional Python 2.7 registry keys.
if not defined PythonExe (
    set PythonRegKey=
    set PythonRegKey27Machine=HKLM\SOFTWARE\Python\PythonCore\2.7
    set PythonRegKey27User=HKCU\SOFTWARE\Python\PythonCore\2.7

    reg query %PythonRegKey27Machine%\InstallPath /ve >nul 2>&1 && set PythonRegKey=%PythonRegKey27Machine%
    reg query %PythonRegKey27User%\InstallPath /ve >nul 2>&1 && set PythonRegKey=%PythonRegKey27User%

    if defined PythonRegKey (
        for /f "tokens=2,*" %%i in ('reg query %PythonRegKey%\InstallPath /ve') do (
            set PythonInstallPath=%%j
        )
        set PythonExe="%PythonInstallPath%\python.exe"
    )
)

if not defined PythonExe (
    echo Cannot find Python 2 >&2
    exit /b 1
)

set PYTHONPATH=%~dp0
%PythonExe% %~dp0simpletap.py %~dp0\%1 %2 %3
