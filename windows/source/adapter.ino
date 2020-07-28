/*
 * Arrowhead Adapter example by Szvetlin Tanyi <szvetlin@aitia.ai> and Balazs Riskutia <balazs.riskutia@outlook.hu>
 * Connects to local network. 
 * Loads SSL certificates, registers a temperature service in Service Registry.
 * Sets up web server that will provide the current temperature data upon service request (in SenML format).
 *
 */

#include <DHTesp.h>
#include <NTPClient.h>
#include <ArduinoJson.h>
#include <ArrowheadESP.h>

// Server and service parameters
// TODO: change params, if needed!
#define SENSOR_PIN 16
#define SERVER_PORT 8080 
#define SERVICE_URI "/temperature"

// NTP
const long utcOffsetInSeconds = 3600;
char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "time1.google.com", utcOffsetInSeconds, 60000);
unsigned long epochTime = 0;

// Temperature variables
float temperature = 0.0;
String tempval = (String)temperature;

// DHT11 sensor
DHTesp dht;

ArrowheadESP Arrowhead;

// This function will handle the incoming service request (return with the current temperature in SenML format).
void handleServiceRequest() {
  
    //build the SenML format
    StaticJsonDocument<500> root;
    root["bn"]  = Arrowhead.getArrowheadESPFS().getProviderInfo().systemName;
    root["t"]  = epochTime;
    root["bu"]  = "celsius";
    root["ver"] = 1;
    JsonArray e = root.createNestedArray("e");
    JsonObject meas = e.createNestedObject();
    meas["n"] = Arrowhead.getArrowheadESPFS().getProviderInfo().systemName;
    meas["sv"] = tempval;

    String response;
    serializeJson(root, response);
    Arrowhead.getWebServer().send(200, "application/json", response); // or use getSecureWebServer()
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Arrowhead.getArrowheadESPFS().loadConfigFile("netConfig.json"); // loads network config from file system
  Arrowhead.getArrowheadESPFS().loadSSLConfigFile("sslConfig.json"); // loads ssl config from file system
  Arrowhead.getArrowheadESPFS().loadProviderConfigFile("providerConfig.json"); // loads provider config from file system
  //Arrowhead.useSecureWebServer(); // call secure configuration if you plan to use secure web server

  // Set the Address and port of the Service Registry.
  Arrowhead.setServiceRegistryAddress(
    Arrowhead.getArrowheadESPFS().getProviderInfo().serviceRegistryAddress,
    Arrowhead.getArrowheadESPFS().getProviderInfo().serviceRegistryPort
  );

  bool startupSuccess = Arrowhead.begin(); // true of connection to WiFi and loading Certificates is successful
  if(startupSuccess){

    // Check if service registry
    String response = "";
    int statusCode = Arrowhead.serviceRegistryEcho(&response);
    Serial.print("Status code from server: ");
    Serial.println(statusCode);
    Serial.print("Response body from server: ");
    Serial.println(response);

    String serviceRegistryEntry = "{\"endOfValidity\":\"2021-12-05 12:00:00\",\"interfaces\":[\"HTTPS-SECURE-SenML\"],\"providerSystem\":{\"address\":\" "+ Arrowhead.getIP() +"\",\"authenticationInfo\":\""+ Arrowhead.getArrowheadESPFS().getSSLInfo().publicKey +"\",\"port\":"+ SERVER_PORT +",\"systemName\":\""+ Arrowhead.getArrowheadESPFS().getProviderInfo().systemName +"\"},\"secure\":\"CERTIFICATE\",\"serviceDefinition\":\"temperature\",\"serviceUri\":\"/\",\"version\":1}";  

    response = "";
    statusCode = Arrowhead.serviceRegistryRegister(serviceRegistryEntry.c_str(), &response);
    Serial.print("Status code from server: ");
    Serial.println(statusCode);
    Serial.print("Response body from server: ");
    Serial.println(response);
  }

  Arrowhead.getWebServer().on(SERVICE_URI, handleServiceRequest); // or use getSecureWebServer()
  Arrowhead.getWebServer().begin(SERVER_PORT); // or use getSecureWebServer()

  timeClient.begin();
  dht.setup(SENSOR_PIN, DHTesp::DHT11); // Connect DHT sensor
} 


void loop() {
  Arrowhead.loop(); // keep network connection up
  // put your main code here, to run repeatedly:

  delay(dht.getMinimumSamplingPeriod());
  temperature = dht.getTemperature();
  if(!isnan(temperature)) {
    tempval = (String)temperature;
  }

  timeClient.update();
  epochTime = timeClient.getEpochTime();

  delay(1000);
  yield();
}
