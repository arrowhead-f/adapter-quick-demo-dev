ECHO OFF

ECHO CRETING ADDITIONAL FORMATS OF THE CERTIFICATES...
ECHO Enter the names that you provided at certificate generation.
SET /P PROVIDERNAME=Adapter name: 
SET /P CONSUMERNAME=Consumer application name: 

cp ./certificates/%CONSUMERNAME%.p12 ./consumer/certificates/%CONSUMERNAME%.p12

openssl pkcs12 -in ./certificates/%PROVIDERNAME%.p12 -out ./source/data/cacert.pem  -cacerts -nokeys -password pass:123456
openssl pkcs12 -in ./certificates/%PROVIDERNAME%.p12 -out ./source/data/clcert.pem  -clcerts -nokeys -password pass:123456
openssl pkcs12 -in ./certificates/%PROVIDERNAME%.p12 -out ./source/data/privkey.pem -nocerts -password pass:123456
openssl pkcs12 -in ./certificates/%PROVIDERNAME%.p12 -nocerts -out ./source/data/serverkey.pem -nodes -password pass:123456
openssl rsa -in ./source/data/privkey.pem -pubout -out ./source/data/pubkey.pem

openssl x509 -in ./source/data/clcert.pem -out ./source/data/cert.der -outform DER
openssl rsa -in ./source/data/privkey.pem -out ./source/data/private.der -outform DER
openssl x509 -in ./source/data/cacert.pem -out ./source/data/ca.der -outform DER

ECHO DONE.

PAUSE