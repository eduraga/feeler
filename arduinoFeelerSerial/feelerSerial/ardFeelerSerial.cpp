
#include "ardFeelerSerial.h"

//Initiate with this if no softwareSerial is added
feelerSerial::feelerSerial(int maxNumber){
    
    maxNumberOfChars = maxNumber;
    startMarker = '<';
    endMarker = '>';
    limitMarker = ',';
    
    if (NULL != receivedChars) delete receivedChars;
    receivedChars = new char[maxNumberOfChars];
    
    if (NULL != intValues) delete intValues;
    intValues = new unsigned int[maxNumberOfChars];
    
}

//If softwareSerial is added, do this instead
feelerSerial::feelerSerial(int maxNumber, int rx, int tx){
    
    maxNumberOfChars = maxNumber;
    startMarker = '<';
    endMarker = '>';
    limitMarker = ',';
    
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
    while(1){
        bool receiveBool = getSettings();
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
    
    boolean receiving = false;
    byte index = 0;
    
    ///do this if regualar serial is used
    if(softSerial == NULL){
        while (Serial.available() > 0 ) {
            char input = Serial.read();
            
            if (receiving == true) {
                receivedChars[index] = input;
                //read more only if maxNumberOfChars is not filled
                if (index > maxNumberOfChars-1) break;
                else index++;
                
                //stop when startMarker found
                if (input == endMarker) {
                    receivedChars[index] = '\0';
                    //clear rest
                    while(Serial.available() > 0) Serial.read();
                    return receivedChars;
                }
            } //start when startMarker found
            else if (input == startMarker) {
                receiving = true;
                receivedChars[index] = input;
                index++;
            }
        }
    } else{ //do this if softwareSerial is used
        while (softSerial->available() > 0 ) {
            char input = softSerial->read();
            
            if (receiving == true) {
                receivedChars[index] = input;
                
                //read more only if maxNumberOfChars is not filled
                if (index > maxNumberOfChars-1) break;
                else index++;
                
                //stop when startMarker found
                if (input == endMarker) {
                    receivedChars[index] = '\0';
                    
                    //clear rest
                    while(softSerial->available() > 0) softSerial->read();
                    return receivedChars;
                }
            }//start when startMarker found
            else if (input == startMarker) {
                receiving = true;
                receivedChars[index] = input;
                index++;
            }
        }
    }
    //if no readable message is detected, return null
    return NULL;
}

//Parse one int value from char array
unsigned int feelerSerial::parseInt(int index){
    unsigned int newNumber = 0;
    while (isNumber(receivedChars[index])){
        newNumber = (newNumber * 10) + (receivedChars[index] - '0');
        if(newNumber > 65535) return 65535;
        index++;
    }
    return newNumber;
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
                intValues[number] = parseInt(index);
                
                //if limitMarker, advance. Else save values
                if (receivedChars[index] == limitMarker) {
                    number++;
                    intValues[number] = 0;
                } else if (receivedChars[index] == endMarker) {
                    boxState = intValues[0];
                    box2LedState = intValues[1];
                    return true;
                }
            } else if (receivedChars[index] == startMarker) {
                if(receivedChars[index+1] == input){
                    index +=2;
                    parsing = true;
                }
               /* else if(receivedChars[index+1] == 's'){
                    return true;
                }*/
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

//Parse the settings in the beginning and save them to speed1, speed2 and speed3
bool feelerSerial::getSettings(){
    //if there is new serial
    if(getSerial() != NULL){
        int index = 0;
        boolean parsing = false;
        byte number = 0;
        intValues[0] = 0;
        while (index < maxNumberOfChars) {
            if (parsing == true) {
                //parse the int values
                intValues[number] = parseInt(index);
                
                //if limitMarker, advance. Else save values
                if (receivedChars[index] == limitMarker) {
                    number++;
                    intValues[number] = 0;
                } else if (receivedChars[index] == endMarker) {
                   
                    if(intValues[0] > 0) speed1 = (int)intValues[0];
                    if(intValues[1] > 0) speed2 = (int)intValues[1];
                    if(intValues[2] > 0) speed3 = (int)intValues[2];
                    
                    Serial.print('E');
                    return true;
                }
            } else if (receivedChars[index] == startMarker) {
                if(receivedChars[index+1] == 'S'){
                    index +=2;
                    parsing = true;
                }
                else if(receivedChars[index+1] == 's'){
                    return true;
                }
                else {
                   // while(Serial.available() > 0) Serial.read();
                    break;
                }
            }
            index++;
        }
    }
    return false;
}


//return boxState
int feelerSerial::getBoxState(){
    return boxState;
}

//return box2LedState
int feelerSerial::getBox2LedState(){
    return box2LedState;
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
bool feelerSerial::send(char value, int intValue1, int intValue2, int intValue3){
    boolean success = false;
    if(softSerial == NULL){
        //put values into array
        int array[] = {intValue1, intValue2, intValue3};
        Serial.print(startMarker);
        Serial.print(value);
        Serial.print(limitMarker);
        
        //send 3 values
        for(unsigned int i = 0; i < 3; i++){
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
            
            //break when the 3 values are sent
            if(2 == i || i > (unsigned int)maxNumberOfChars){
                success = true;
                break;
            }
            Serial.print(limitMarker);
        }
        Serial.println(endMarker);
    } else {
        //put values into array
        int array[] = {intValue1, intValue2, intValue3};
        softSerial->print(startMarker);
        softSerial->print(value);
        softSerial->print(limitMarker);
        
        //send 3 values
        for(unsigned int i = 0; i < 3; i++){
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
            if(2 == i || i > (unsigned int)maxNumberOfChars){
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


