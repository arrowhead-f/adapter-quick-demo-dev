ECHO OFF

SET /p port="Enter device serial port (COM1, COM2, etc.): "

:: Make SPIFFS BINARY
ECHO CREATING BINARY...
.\tools\mkspiffs\win32\mkspiffs.exe --size 0x1FA000 --page 256 --block 8192 -d 5 --create .\source\data .\binaries\spiffs.bin
ECHO BINARY CREATED.

:: UpLoading to device
ECHO UPLOADING...
python .\tools\esptool\esptool.py --baud 460800 --port %port% write_flash 0x200000 .\binaries\spiffs.bin -u

PAUSE