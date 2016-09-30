import java.util.concurrent.atomic.AtomicBoolean;

//function that will handle logging. It should also be trheaded if we want precise timing
class Logger extends Thread {
  public AtomicBoolean active=new AtomicBoolean(false);
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("asyncIOTestOutput.txt"));

  Logger(int in) {
    sampleInterval=in;
    writer.start();
    active.set(true);
    super.start();
    //curiously, if this thread is started in pause mode, it won't make any log. 

    pause();
  }
  void start() {
  }
  void pause() {
    active.set(false);
  }
  void restart() {
    if (!active.get()) {
      active.set(true);
      timer.restart();
    }
  }
  private int dof=20000;
  void run() {

    while (true) {

      if (active.get()) {

        if (dof<=0) {
          dof=20000;
          println("active "+active);
        } else {
          dof--;
        }
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