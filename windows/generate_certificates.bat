ECHO OFF

ECHO GENERATING CERTIFICATES...
ECHO Provide a name for your adapter system as well as for your consumer application. 
ECHO These names will be used in the certificate generation process and these names will have to be used in your configurations.
SET /P PROVIDERNAME=Adapter name: 
SET /P CONSUMERNAME=Consumer application name: 
CALL mintty ./tools/certificate_generation/mk_certs.sh %PROVIDERNAME% %CONSUMERNAME%