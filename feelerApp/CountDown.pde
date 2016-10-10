// https://forum.processing.org/one/topic/timer-in-processing.html
// This class based on code found here: http://www.goldb.org/stopwatchjava.html

class CountDown {
  int startTime = 0, stopTime = 0, pauseTime = 0;
  int pauseStart = 0;
  int pauseEnd = 0;
  int elapsed = 0;
  public int countDownStart;
  //public int countDownStart = 1000 * 30;
  boolean paused = false;

  void start(float start) {
    //if(boxState == 100){
    //  countDownStart = int(1000 * 60 * countDownStartMeditate);
    //} else if (boxState == 200){
    //  countDownStart = int(1000 * 60 * countDownStartStudy);
    //}

    countDownStart = int(1000 * 60 * start);

    pauseTime = 0;
    startTime = millis();
    logger.restart();
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
    //to delete uncompleted session data uncomment the following 2 lines:
    //File path = new File(dataPath(sessionPath));
    //this.deleteDir(path);

    stopTime = millis();
    recording = false;
    logger.pause("stop");
    cp5.getController("playPauseBt").hide();
    cp5.getController("stopBt").hide();
  }

  void playPause() {
    if (paused) {
      pauseStart = millis();
    } else {
      pauseEnd = millis();
    }

    if (pauseStart < pauseEnd) {
      pauseTime = pauseEnd - pauseStart + pauseTime;
    }

    recording = !recording;
    if (recording) {
      logger.resumeInfra();
    } else {
      logger.pause("playpause");
    }
    paused = !paused;
  }

  int getElapsedTime() {

    if (recording) {
      elapsed = (startTime - millis()) + countDownStart + pauseTime;
    } else {
      //elapsed = (startTime - stopTime);
      if (elapsed >= 0 && elapsed < 500) {
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