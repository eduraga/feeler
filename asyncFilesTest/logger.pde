//function that will handle logging. It should also be trheaded if we want precise timing
class Logger extends Thread {
  public boolean active=false;
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Timer timer=new Timer();
  asyncBufferedOutput writer= new asyncBufferedOutput("asyncIOTestOutput.txt");
  Logger(int in) {
    sampleInterval=in;
  }
  void start() {
    writer.start();
    timer.restart();
    active=true;
    super.start();
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