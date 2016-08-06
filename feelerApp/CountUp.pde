// https://forum.processing.org/one/topic/timer-in-processing.html
// This class based on code found here: http://www.goldb.org/stopwatchjava.html

class CountUp {
  int startTime = 0, stopTime = 0, pauseTime = 0;
  int pauseStart = 0;
  int pauseEnd = 0;
  int elapsed = 0;
  boolean paused = false;
  
  void start() {
    pauseTime = 0;
    startTime = millis();
    recording = true;
    cp5.getController("playPauseBt").show();
    cp5.getController("stopBt").show();
  }
  
  void deleteDir(File file) {
    File[] contents = file.listFiles();
    if (contents != null) {
        for (File f : contents) {
            deleteDir(f);
        }
    }
    file.delete();
  }

  void stop() {
    stopTime = millis();
    recording = false;
    cp5.getController("playPauseBt").hide();
    cp5.getController("stopBt").hide();
  }
  
  void playPause() {
    if(paused){
      pauseStart = millis();
    } else {
      pauseEnd = millis();
    }
    
    if(pauseStart > pauseEnd) {
      pauseTime = pauseEnd - pauseStart - pauseTime;
    }
    
    recording = !recording;
    paused = !paused;
  }
  
  int getElapsedTime() {
    if (recording) {
      println(millis() - startTime);
      elapsed = (millis() - startTime) - pauseTime;
    } else {
      //elapsed = (startTime - stopTime);
      //if(elapsed >= 0 && elapsed < 500){
      //  elapsed = 0;
      //  this.stop();
      //}
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