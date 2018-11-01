
#include "ardFeelerSerial.h"

//Initiate with this if no softwareSerial is added
feelerSerial::feelerSerial(int maxNumber){
    
    maxNumberOfChars = maxNumber;
    
    if (NULL != receivedChars) delete receivedChars;
    receivedChars = new char[maxNumberOfChars];
    
    if (NULL != intValues) delete intValues;
    intValues = new unsigned int[maxNumberOfChars];
    
}

//If softwareSerial is added, do this instead
feelerSerial::feelerSerial(int maxNumber, int rx, int tx){
    
    maxNumberOfChars = maxNumber;
    
    if (NULL != receivedChars)delete receivedChars;
    receivedChars = new char[maxNumberOfChars];
    
    if (NULL != intValues) delete intValues;
    intValues = new unsigned int[maxNumberOfChars];
    
    softSerial = new SoftwareSerial(rx,tx);
    
}

feelerSerial::~feelerSerial(){
    //DESTRUCT
}

//Choose baudrate
void feelerSerial::begin(long baudrate){
    if(softSerial != NULL) softSerial->begin(baudrate);
    else Serial.begin(baudrate);
}


//Send and get the setup values
void feelerSerial::setup(){
    
    //Set markers
    startMarker = '<';
    endMarker = '>';
    limitMarker = ',';
    
    //Setup values from computer, get and send
    receiving = false;
    boxState = 0;
    box2LedState = 0;
    playStop = 0;
    while(1){
        bool receiveBool = getSettings('S');
        if(receiveBool == true) {
            Serial.write('E');
            break;
        }
    }
    while(1){
        delay(50);
        bool sendBool = sendSettings('B');
        if(sendBool == true) {
            Serial.print('E');
            break;
        }
        delay(50);
    }
    
}

//Set the settings to send, use this if no settings are received from the computer
void feelerSerial::setSettings(unsigned  value1, unsigned value2, unsigned value3){
    speed1 = value1;
    speed2 = value2;
    speed3 = value3;
}



//Get the serial message as a char array, starting with startMarker and ending with endMarker
char* feelerSerial::getSerial(){
    
    ///do this if regualar serial is used
    if(softSerial == NULL){
//        if(Serial.available() > 60){
        while (Serial.available()) {
            
            char input = Serial.read();
       
            if (receiving == true) {
                receivedChars[indexS] = input;
                //read more only if maxNumberOfChars is not filled
                if (indexS > maxNumberOfChars-1) {
                    receiving = false;
                    break;
                }
                else indexS++;
                
                //stop when startMarker found
                if (input == endMarker || input == '\n') {
                    receivedChars[indexS] = '\0';
                    receiving = false;
                    //clear rest
                    while(Serial.available() > 0) Serial.read();
                 //   Serial.print(receivedChars);
                    return receivedChars;
                }
            } //start when startMarker found
            else if (input == startMarker) {
                indexS = 0;
                receiving = true;
                receivedChars[indexS] = input;
                indexS++;
            }
    }
    } else{ //do this if softwareSerial is used
        while (softSerial->available() > 0 ) {
            char input = softSerial->read();
            if (receiving == true) {
                receivedChars[indexS] = input;
                
                //read more only if maxNumberOfChars is not filled
                if (indexS > maxNumberOfChars-1) break;
                else indexS++;
                
                //stop when startMarker found
                if (input == endMarker) {
                    receivedChars[indexS] = '\0';
                    
                    //clear rest
                    while(softSerial->available() > 0) softSerial->read();
                    return receivedChars;
                }
            }//start when startMarker found
            else if (input == startMarker) {
                indexS = 0;
                receiving = true;
                receivedChars[indexS] = input;
                indexS++;
            }
        }
    }
    //if no readable message is detected, return null
    return NULL;
}


//Parse the serial from the received settings and save to intValues array
bool feelerSerial::get(char input) {
    if(softSerial == NULL){
        //if there is new serial
        if(getSerial() != NULL){
            int index = 0;
            boolean parsing = false;
            byte number = 0;
            intValues[0] = 0;
            while (index < maxNumberOfChars) {
                if (parsing == true) {
                    //parse the int value
                    while (isNumber(receivedChars[index])){
                        intValues[number] = (intValues[number] * 10) + (receivedChars[index] - '0');
                        if(intValues[number] > 65535) return 65535;
                        index++;
                    }
                    //if limitMarker, advance. Else save values
                    if (receivedChars[index] == limitMarker) {
                        number++;
                        intValues[number] = 0;
                    } else if (receivedChars[index] == endMarker) {
                        return true;
                    }
                } else if (receivedChars[index] == startMarker) {
                    if(receivedChars[index+1] == input){
                        index +=2;
                        parsing = true;
                    }
                     else if(receivedChars[index+1] == 's'){
                         return true;
                     }
                    else {
                        break;
                    }
                }
                index++;
            }
        }
    }
    return false;
}

bool feelerSerial::getSettings(char value){
    if(get(value)){
        if(intValues[0] > 0) speed1 = (unsigned int)intValues[0];
        if(intValues[1] > 0) speed2 = (unsigned int)intValues[1];
        if(intValues[2] > 0) speed3 = (unsigned int)intValues[2];
        return true;
    }
    return false;
}

bool feelerSerial::getValues(char value){
    if(get(value)){
        playStop = intValues[0];
        boxState = intValues[1];
        box2LedState = intValues[2];
        return true;
    }
    return false;
}

//return playStop
int feelerSerial::getPlayStop(){
    return playStop;
}

//return box2LedState
int feelerSerial::getBox2LedState(){
    return box2LedState;
}

//return box2LedState
int feelerSerial::getBoxState(){
    return boxState;
}

//serial read
char feelerSerial::read() {
    if (softSerial == NULL){
        char input = Serial.read();
        return input;
    }
    else{
        char input = softSerial->read();
        return input;
    }
}

//serial println, for debug
void feelerSerial::println(const char *output){
    if (softSerial == NULL){
        Serial.println(output);
    } else{
        softSerial->println(output);
    }
}

//serial println, for debug
void feelerSerial::print(const char *output){
    if (softSerial == NULL){
        Serial.print(output);
    } else{
        softSerial->print(output);
    }
}


//Send settings to with starting char
bool feelerSerial::sendSettings(char value){
    
    unsigned int array[] = {speed1, speed2, speed3};
    
    Serial.print(startMarker);
    Serial.print(value);
    Serial.print(limitMarker);
    for(unsigned int i = 0; i < 3; i++){
        int tempNumber = array[i];
        
        char charArray[20];
        unsigned int j = 0;
        while(true){
            charArray[j] = (tempNumber % 10) + '0';
            j++;
            if(tempNumber <= 9) break;
            tempNumber = tempNumber/10;
        }
        charArray[j] = '\0';
        for(int b = j; b >= 0; b--) { Serial.print(charArray[b]); }
        if(2 == i || i > (unsigned int)maxNumberOfChars) break;
        Serial.print(limitMarker);
    }
    Serial.println(endMarker);
    while(Serial.available() > 0) {
        if(Serial.read() == 'E') return true;
    }
    return false;
}

//send these values to the feeler app, char first, then values
bool feelerSerial::send(char value, int intValue1, int intValue2, int intValue3, int intValue4, int intValue5){
    boolean success = false;
    
    static uint8_t numberOfValues = 5;
    
    if(softSerial == NULL){
        //put values into array
        int array[] = {intValue1, intValue2, intValue3, intValue4, intValue5};
        Serial.print(startMarker);
        Serial.print(value);
        Serial.print(limitMarker);
        
        //send 3 values
        for(uint8_t i = 0; i < numberOfValues; i++){
            int tempNumber = array[i];
            char charArray[10];
            unsigned int j = 0;
            while(true){
                charArray[j] = (tempNumber % 10) + '0';
                j++;
                if(tempNumber <= 9) break;
                tempNumber = tempNumber/10;
            }
            charArray[j] = '\0';
            for(int b = j; b >= 0; b--) { Serial.print(charArray[b]); }
            
            //break when the numberOfValues are sent
            if(numberOfValues-1 == i || i > 10){
                success = true;
                break;
            }
            Serial.print(limitMarker);
        }
        Serial.println(endMarker);
    } else {
        //put values into array
        int array[] = {intValue1, intValue2, intValue3, intValue4};
        softSerial->print(startMarker);
        softSerial->print(value);
        softSerial->print(limitMarker);
        
        //send 3 values
        for(uint8_t i = 0; i < numberOfValues; i++){
            int tempNumber = array[i];
            char charArray[10];
            unsigned int j = 0;
            while(true){
                charArray[j] = (tempNumber % 10) + '0';
                j++;
                if(tempNumber <= 9) break;
                tempNumber = tempNumber/10;
            }
            charArray[j] = '\0';
            for(int b = j; b >= 0; b--) { softSerial->print(charArray[b]); }
            
            //break when the 3 values are sent
            if(numberOfValues-1 == i || i > 10){
                success = true;
                break;
            }
            softSerial->print(limitMarker);
        }
        softSerial->println(endMarker);
    }
    return success;
}

bool feelerSerial::isNumber(char input){
    if(input > 47 && input < 58) return true;
    return false;
}

unsigned int feelerSerial::getSpeed1(){
    return speed1;
}

unsigned int feelerSerial::getSpeed2(){
    return 5;
}

unsigned int feelerSerial::getSpeed3(){
    return speed3;
}


