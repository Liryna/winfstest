@echo off
setlocal EnableExtensions

rem Find Python 3.8 or newer, in this order:
rem   1. the Python launcher: py -3
rem   2. python on PATH
rem   3. HKCU/HKLM\SOFTWARE\Python\PythonCore\3.N\InstallPath (newest first)
rem   4. C:\Python3N-x64\python.exe, C:\Python3N\python.exe (newest first)

set PythonExe=

call :TryPython py -3
if defined PythonExe goto :Run

call :TryPython python
if defined PythonExe goto :Run

set PythonRegRoots=
for %%r in ("HKCU\SOFTWARE" "HKLM\SOFTWARE" "HKLM\SOFTWARE\WOW6432Node") do call :AddRegRoot "%%~r"
if defined PythonRegRoots for /l %%n in (30,-1,8) do call :TryRegistry 3.%%n
if defined PythonExe goto :Run

for /l %%n in (30,-1,8) do (
    call :TryDir C:\Python3%%n-x64
    call :TryDir C:\Python3%%n
)
if defined PythonExe goto :Run

echo Cannot find Python 3 >&2
exit /b 1

:Run
set PYTHONPATH=%~dp0
%PythonExe% "%~dp0simpletap.py" %~dp0\%1 %2 %3
exit /b %ERRORLEVEL%

rem Accept the command line %* if it runs Python 3.8 or newer.
:TryPython
if defined PythonExe exit /b 0
%* -c "import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)" >nul 2>&1
if %ERRORLEVEL% equ 0 set PythonExe=%*
exit /b 0

:AddRegRoot
reg query "%~1\Python\PythonCore" >nul 2>&1 || exit /b 0
set PythonRegRoots=%PythonRegRoots% "%~1"
exit /b 0

rem %1 is a version such as 3.13; also check the 32-bit per-user key 3.13-32.
:TryRegistry
if defined PythonExe exit /b 0
for %%r in (%PythonRegRoots%) do for %%s in ("" "-32") do call :TryRegistryKey "%%~r\Python\PythonCore\%~1%%~s\InstallPath"
exit /b 0

:TryRegistryKey
if defined PythonExe exit /b 0
for /f "tokens=1,2,*" %%a in ('reg query "%~1" /v ExecutablePath 2^>nul') do (
    if /i "%%a"=="ExecutablePath" call :TryPython "%%c"
)
exit /b 0

:TryDir
if defined PythonExe exit /b 0
if exist "%~1\python.exe" call :TryPython "%~1\python.exe"
exit /b 0
