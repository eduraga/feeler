//function that will handle logging. It should also be trheaded if we want precise timing
class Logger extends Thread {
  public boolean active=false;
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Timer timer=new Timer();
  AsyncFilePrinter writer= new AsyncFilePrinter();
  Logger(int in) {
    sampleInterval=in;
  }
  void start() {
    writer.start("test.txt");
    timer.restart();
    active=true;
    super.start();
  }
  void restart() {
    timer.restart();
    active=true;
    run();
  }
  void run() {
    while (active) {
      if (timer.get()>=sampleInterval) {
        println("!got!");
        logsThisDraw++;
        timer.restart();
        String tt="."+((int) longTimer.get());
        writer.add(tt);
        writer.refresh();
      }
    }
  }
}