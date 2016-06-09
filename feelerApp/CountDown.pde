// https://forum.processing.org/one/topic/timer-in-processing.html
// This class based on code found here: http://www.goldb.org/stopwatchjava.html

class CountDown {
  int startTime = 0, stopTime = 0;
  int countDownStart = 1000 * 60 * 5;
  
  void start() {
      startTime = millis();
      recording = true;
  }
  void stop() {
      //stopTime = millis();
      recording = false;
  }
  
  int getElapsedTime() {
      int elapsed;
      if (recording) {
        elapsed = (startTime - millis()) + countDownStart;
        if(elapsed < 500 && elapsed >= 0){
          this.stop();
        }
      } else {
         //elapsed = (startTime - stopTime);
         elapsed = 0;
      }
      return elapsed;
  }
  
  int second() {
    return (getElapsedTime() / 1000) % 60;
  }
  
  int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  
  int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
  
}