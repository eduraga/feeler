// https://forum.processing.org/one/topic/timer-in-processing.html
// This class based on code found here: http://www.goldb.org/stopwatchjava.html

class CountUp {

  int startTime = 0, stopTime = 0;
  boolean running = false;  
  
  void start() {
    println("start count up");
    startTime = millis();
    running = true;
  }
  void stop() {
    cp5.getController("stopBt").hide();
    stopTime = millis();
    running = false;
  }
  int getElapsedTime() {
      int elapsed;
      if (running) {
           elapsed = (millis() - startTime);
      }
      else {
          elapsed = (stopTime - startTime);
      }
      //println("elapsed: " + elapsed);
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