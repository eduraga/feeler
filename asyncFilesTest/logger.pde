//function that will handle logging. It should also be trheaded if we want precise timing
class Logger extends Thread {
  public boolean active=false;
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("asyncIOTestOutput.txt"));
  Logger(int in) {
    sampleInterval=in;
    writer.start();
    active=true;
    super.start();
  }
  void start() {
    
  }
  void pause() {
    active=false;
  }
  void restart() {
    if (!active) {
      active=true;
      timer.restart();
    }
  }
  void run() {
    while (true) {
      if (active) {
        if (timer.get()>=sampleInterval) {
          logsThisDraw++;
          timer.restart();
          String tt="."+((int) longTimer.get());
          writer.add(tt);
          //writer.refresh();
        }
      }
    }
  }
}