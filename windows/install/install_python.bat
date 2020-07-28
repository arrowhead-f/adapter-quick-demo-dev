ECHO OFF

SET /P INSTALLPYTHON=Would you like to install Python 3.8 (Y/[N])?
IF %INSTALLPYTHON% == y SET PYTHONTRUE=1
IF %INSTALLPYTHON% == Y SET PYTHONTRUE=1
IF DEFINED PYTHONTRUE (
    ECHO DOWNLOADING PYTHON...
    ECHO Please wait for the download to finish...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe', 'python_installer.exe')"
    ECHO INSTALLING PYTHON...
    .\python_installer.exe /passive InstallAllUsers=1 PrependPath=1 Include_test=0
    ECHO PYTHON INSTALLED.
) ELSE (
    ECHO SKIPPING PYTHON INSTALLATION.
)