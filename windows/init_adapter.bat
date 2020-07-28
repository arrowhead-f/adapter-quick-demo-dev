ECHO OFF

SET /p port="Enter device serial port (COM1, COM2, etc.): "

cd .\tools\esptool
pip install --user -e .
cd ..\..

ECHO UPLOADING PROGRAM TO DEVICE...
python .\tools\esptool\esptool.py --chip esp8266 --port %port% --baud 921600 --before default_reset --after hard_reset write_flash 0x0 .\binaries\adapter.bin
ECHO PROGRAM UPLOADED.
ECHO.
ECHO MODIFY CONFIGURATION FILES IN source/data TO FIT YOUR ENVIRONMENT
ECHO THEN RUN update_adapter.bat TO UPLOAD THESE CHANGES TO DEVICE.

PAUSE