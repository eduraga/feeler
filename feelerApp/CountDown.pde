// https://forum.processing.org/one/topic/timer-in-processing.html
// This class based on code found here: http://www.goldb.org/stopwatchjava.html

class CountDown {
  int startTime = 0, stopTime = 0, pauseTime = 0;
  int pauseStart = 0;
  int pauseEnd = 0;
  int elapsed = 0;
  int countDownStart = 1000 * 60 * 5;
  //int countDownStart = 1000 * 5;
  boolean paused = false;
  
  void start() {
    pauseTime = 0;
    startTime = millis();
    recording = true;
    cp5.getController("playPauseBt").show();
    //paused = true;
  }
  void stop() {
    stopTime = millis();
    recording = false;
  }
  
  void playPause() {
    if(paused){
      pauseStart = millis();
    } else {
      pauseEnd = millis();
    }
    
    if(pauseStart < pauseEnd) {
      pauseTime = pauseEnd - pauseStart + pauseTime;
    }
    
    recording = !recording;
    paused = !paused;
  }
  
  int getElapsedTime() {
    
    if (recording) {
      elapsed = (startTime - millis()) + countDownStart + pauseTime;
    } else {
      //elapsed = (startTime - stopTime);
      if(elapsed >= 0 && elapsed < 500){
        elapsed = 0;
        this.stop();
      }
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