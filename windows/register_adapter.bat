ECHO OFF

ECHO REGISTERING ADAPTER IN THE CLOUD...
ECHO Enter the names that you provided at certificate generation.
SET /P PROVIDERNAME=Adapter name: 
SET /P CONSUMERNAME=Consumer application name: 
SET /P PUBLICKEY=Public key (without newlines):

openssl pkcs12 -in .\certificates\sysop.p12 -out .\certificates\sysop.key.pem -nocerts -nodes -password pass:123456
openssl pkcs12 -in .\certificates\sysop.p12 -out .\certificates\sysop.crt.pem -clcerts -nokeys -password pass:123456

ECHO REGISTERING SERVICE CONSUMER...
.\tools\curl\bin\curl.exe --insecure -E ./certificates/sysop.crt.pem --key ./certificates/sysop.key.pem -X POST "https://127.0.0.1:8443/serviceregistry/mgmt/systems" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"address\": \"localhost\", \"authenticationInfo\": \"%PUBLICKEY%\", \"port\": 8080, \"systemName\": \"%CONSUMERNAME%\"}" | .\tools\jq\jq.exe ".id" > consumerid.txt

ECHO AUTHORIZING PROVIDER-CONSUMER COMMUNICATION...
.\tools\curl\bin\curl.exe --insecure -E ./certificates/sysop.crt.pem --key ./certificates/sysop.key.pem -X GET "https://127.0.0.1:8443/serviceregistry/mgmt/systems?direction=ASC&item_per_page=0&page=0&sort_field=id" -H "accept: */*" | .\tools\jq\jq.exe ".data[] | select(.systemName == \"%PROVIDERNAME%\") | .id" > providerid.txt
.\tools\curl\bin\curl.exe --insecure -E ./certificates/sysop.crt.pem --key ./certificates/sysop.key.pem -X GET "https://127.0.0.1:8443/serviceregistry/mgmt/services?direction=ASC&item_per_page=0&page=0&sort_field=id" -H "accept: application/json" | .\tools\jq\jq.exe ".data[] | select(.serviceDefinition == \"temperature\") | .id" > servicedefinitionid.txt
.\tools\curl\bin\curl.exe --insecure -E ./certificates/sysop.crt.pem --key ./certificates/sysop.key.pem -X GET "https://127.0.0.1:8443/serviceregistry/mgmt/servicedef/temperature?direction=ASC&sort_field=id" -H "accept: */*" | .\tools\jq\jq.exe ".data[] | select(.interfaces[].interfaceName == \"HTTP-INSECURE-SENML\") | .interfaces[].id" > interfaceid.txt

SET /P PROVIDERID=<providerid.txt
SET /P CONSUMERID=<consumerid.txt
SET /P SERVICEDEFINITIONID=<servicedefinitionid.txt
SET /P INTERFACEID=<interfaceid.txt

.\tools\curl\bin\curl.exe --insecure -E ./certificates/sysop.crt.pem --key ./certificates/sysop.key.pem -X POST "https://127.0.0.1:8445/authorization/mgmt/intracloud" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"consumerId\": %CONSUMERID%, \"interfaceIds\": [ %INTERFACEID% ], \"providerIds\": [ %PROVIDERID% ], \"serviceDefinitionIds\": [ %SERVICEDEFINITIONID% ]}"

DEL providerid.txt
DEL consumerid.txt
DEL servicedefinitionid.txt
DEL interfaceid.txt

PAUSE