ECHO OFF

ECHO CHECKING PYTHON:
python --version
ECHO.
CD install

:: Install Python
CALL ./install_python.bat

:: Install Java
CALL ./install_java.bat

:: Install MSYS2 for bash shell emulator (MinTTY)
CALL ./install_msys2.bat

CD ..

PAUSE