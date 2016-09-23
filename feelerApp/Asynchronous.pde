//atomics are variables that make sure not to be accessed twice at the same time, avoiding halts
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicBoolean;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

class asyncBufferedOutput extends Thread {
  //name for the output file
  public String fileName="undefined";
  //wether the thread is running
  private boolean active=false;
  public boolean isWriting=false;
  //whether writing to the buffer is allowed. This is a miltithread lock
  private Object bufferLock = new Object();

  //the glued buffer that will be written. Buffer gets glued into outString in order to free up the buffer asap
  private String outString="";
  //the output buffer
  private String [] buffer=new String[0];
  //a cached length of the buffer
  //private int bufferLengthCache=0;
  private AtomicInteger bufferLengthCache = new AtomicInteger(0);

  //the file writer
  //private PrintWriter file;
  private BufferedWriter file;

  asyncBufferedOutput(String fname) {
    fileName=fname;
    //file = (fname);
    //file = new BufferedWriter(new FileWriter(fname));
    try {

      //String content = "This is the content to write into file";

      File f = new File(fname);
      println("Writing buffer output to: "+fname);
      // if file doesnt exists, then create it
      if (!f.exists()) {
        f.createNewFile();
      }

      FileWriter fw = new FileWriter(f.getAbsoluteFile());
      file = new BufferedWriter(fw);
      //bw.write(content);
      //bw.close();
      isWriting=true;
      //file = new PrintWriter(new BufferedWriter(new FileWriter(fname)));
    }
    catch(IOException e) {
      e.printStackTrace();
    }
    active=true;
  }
  void start() {
    super.start();
  }
  void run() {
    while (active) {
      if (isWriting) {
        if (bufferLengthCache.get()>0) {
          synchronized(bufferLock) {
            //set ready flag to true (so isReady returns true)
            //String n="\n";
            outString=String.join("\n", buffer);
            buffer=new String[0];

            //ready=true;
            //lockBuffer=false;
            //buffer.notifyAll();
          }
          try {
            //file.write("us");
            file.write("\n"+outString);
            file.flush();
          }
          catch(IOException e) {
            e.printStackTrace();
          }
          //exit();
          bufferLengthCache.set(0);
          outString="";
        }
      } else {
        println("Sorry! You are trying to write to a file, but I couldn't open it.");
        active=false;
      }
    }
  }
  public synchronized void add(String what) {
    String clen="0";
    synchronized(bufferLock) {
      buffer=append(buffer, what);
      bufferLengthCache.set(buffer.length);
      clen=what+"@["+bufferLengthCache.get()+"]rc"+recording;
    }
    println(clen);
    //cacheLength=bufferLengthCache.get();
  }
}
//function that will handle logging. It should also be trheaded if we want precise timing
class Logger extends Thread {
  public AtomicBoolean active=new AtomicBoolean(false);
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("asnyncfeelerlogtest.txt"));
  Logger(int in) {
    sampleInterval=in;
    writer.start();
    active.set(true);
    super.start();
    pause();
  }
  void start() {
  }
  void pause() {
    active.set(false);
  }
  void pause(String reason) {
    println(reason);
    active.set(false);
  }
  void restart() {
    if (!active.get()) {
      active.set(true);
      timer.restart();
    }
  }
  void resumeInfra() {
    if (!active.get()) {
      active.set(true);
      //timer.restart();
    }
  }
  void run() {
    while (true) {
      if (active.get()) {
        if (timer.get()>=sampleInterval) {
          //println("recording1");
          //logsThisDraw++;
          
          String tt="."+((int) longTimer.get());
          tt+=(TAB);
          tt+=(delta1);
          tt+=(TAB);
          tt+=(theta1);
          tt+=(TAB);
          tt+=(low_alpha1);
          tt+=(TAB);
          tt+=(high_alpha1);
          tt+=(TAB);
          tt+=(low_beta1);
          tt+=(TAB);
          tt+=(high_beta1);
          tt+=(TAB);
          tt+=(low_gamma1);
          tt+=(TAB);
          tt+=(mid_gamma1);
          tt+=(TAB);
          tt+=(blinkSt);
          tt+=(TAB);
          tt+=(attention);
          tt+=(TAB);
          tt+=(meditation);
          tt+=(TAB);
          tt+=(timeline);
          writer.add(tt);
          //writer.refresh();
          timer.restart();
        }
      }
    }
  }
}
//functions to get more easily millis from a moment. 
//Starting point is when startMillis(), and getrlMillis returns millis from that point 
class Clock {
  private long startMillis=0;

  Clock() {
    startMillis=System.currentTimeMillis();
  }
  void restart() {
    startMillis=System.currentTimeMillis();
  }
  long get() {
    return System.currentTimeMillis()-startMillis;
  }
  int getInt(int module) {
    return (int) (System.currentTimeMillis()-startMillis)%module;
  }
}