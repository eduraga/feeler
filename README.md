# Feeler

## Installation

- Install MindsetProcessing http://jorgecardoso.eu/processing/MindSetProcessing/ in Processing.
- Install feelerSerial in Processing.

### Without PHP backend
- Change the first in feelerApp.pde line to ```boolean debug = true;```.
- The application now runs in 'debug' mode, so you can login by clicking 'L' on the keyboard.

### With PHP backend
- Install a PHP server, such as MAMP https://www.mamp.info/en/, and run it.
- Install the contents of /SimpleUsers (a modified version of: https://github.com/Repox/SimpleUsers and create a user).
  - Edit the configuration file, located at simpleusers/config.inc.php, then run the install script which is located at simpleusers/install.php As an alternative to the install script, edit the configuration file. The tables can be created manually, by opening tables.sql and pasting the tables into phpMyAdmin.
- Edit feelerApp/data/config.json to reflect your environment.

## Running
- Run feelerApp.pde (in /feelerSerial) and try to create a user or log in (or ref. to running without PHP).
- Set ```simulateMindSet``` to true to test without MindWave.
- Set ```simulateBoxes``` to true to test without the boxes.
- Change ```countDownStartMeditate``` and ```countDownStartStudy``` (in minutes, accepts fractions) to the appropriate values.

## License
Feeler is licensed under GPL3 license, see COPYING
