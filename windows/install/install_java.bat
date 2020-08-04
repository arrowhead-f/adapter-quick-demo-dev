ECHO OFF

ECHO ACQUIRING JAVA JDK 11...
ECHO Downloading...
:: powershell Start-BitsTransfer -source "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip"
::powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip', '..\tools\java\jdk11.zip')"
..\tools\curl\bin\curl.exe "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip" --output ..\tools\java\jdk11.zip
ECHO Unzipping...
powershell Expand-Archive ..\tools\java\jdk11.zip -DestinationPath ..\tools\java
DEL ..\tools\java\jdk11.zip
ECHO JAVA ACQUIRED.

PAUSE