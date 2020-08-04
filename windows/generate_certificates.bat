ECHO OFF

SET REL_PATH=.\tools\java\jdk-11.0.2\bin
SET ABS_PATH=
REM
PUSHD %REL_PATH%
REM
SET ABS_PATH=%CD%
REM
POPD
SET PATH=%PATH%;%ABS_PATH%;C:\msys64\usr\bin

ECHO GENERATING CERTIFICATES...
ECHO Provide a name for your adapter system as well as for your consumer application. 
ECHO These names will be used in the certificate generation process and these names will have to be used in your configurations.
SET /P PROVIDERNAME=Adapter name: 
SET /P CONSUMERNAME=Consumer application name: 
CALL mintty ./tools/certificate_generation/mk_certs.sh %PROVIDERNAME% %CONSUMERNAME%