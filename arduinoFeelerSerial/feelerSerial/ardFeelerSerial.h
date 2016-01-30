
#include "SoftwareSerial.h"
#include "Arduino.h"

class feelerSerial
{
public:
    feelerSerial(int maxNumber);
    feelerSerial(int maxNumber, int rx, int tx);
    ~feelerSerial();
    void init();
    void setSettings(unsigned int value1, unsigned int value2, unsigned int value3);
    
    bool get(char input);
    void begin(long baudrate);
    void setup();
    
    bool sendSettings(char value);
    bool send(char value, int intValue1, int intValue2, int intValue3, int intValue4, int intValue5);
    
    char* receivedChars;
    unsigned int* intValues;
    
    unsigned int getSpeed1();
    unsigned int getSpeed2();
    unsigned int getSpeed3();
    
    int getPlayStop();
    int getBox2LedState();
    int getBoxState();
    
    int boxState;

private:
    bool isNumber(char input);
    
    bool getSettings();
    char* getSerial();
   
    char read();
    void println(const char *output);
    void print(const char *output);
    
    int maxNumberOfChars;
    char startMarker;
    char limitMarker;
    char endMarker;
    int playStop;
    int box2LedState;
    SoftwareSerial* softSerial;
    
    unsigned int speed1;
    unsigned int speed2;
    unsigned int speed3;
};
