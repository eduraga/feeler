import java.util.concurrent.atomic.AtomicInteger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;


//functions to get more easily computer clock millis from a moment. 
//Starting point is when startMillis(), and get returns real millis from that moment
class Clock {
  private long startMillis=0;
  Clock() {
    startMillis=System.currentTimeMillis();
  }
  //set the milliseconds count to zero
  void restart() {
    startMillis=System.currentTimeMillis();
  }
  long get() {
    return System.currentTimeMillis()-startMillis;
  }
  //to get millis in relation to an int modulus (millis%modulus)
  int getInt(int modulus) {
    return (int) (System.currentTimeMillis()-startMillis)%modulus;
  }
}
//create the main long realtime clock timer instance
/*
Start a timer:
 Timer myTimer=new Timer();
 Get time since start:
 myTimer.get();
 Restart count:
 myTimer.restart();
 */

//class that will handle disc i/o of text in a separate thread, avoiding the thread to halt while writing
class asyncBufferedOutput extends Thread {
  //name for the output file
  public String fileName="undefined";
  //wether the thread is running
  private boolean active=false;
  public boolean isWriting=false;
  //whether writing to the buffer is allowed
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
        println("Warning! You are trying to write to a file, but I couldn't open it!");
      }
    }
  }
  public synchronized void add(String what) {
    String clen="0";
    synchronized(bufferLock) {
      buffer=append(buffer, what);
      bufferLengthCache.set(buffer.length);
      clen=what+"@["+bufferLengthCache.get()+"]";
    }
    println(clen);
    //cacheLength=bufferLengthCache.get();
  }
}

//this class will work as a separate thread, and manage the logging and not the file writing.
//this ensures perfect log timing
/*
create the logger:
 Logger myLogger=new Logger(int MillisecondsInterval);
 
 pause the logger:
 myLogger.pause();
 resume the logger: 
 myLogger.restart();
 The logging functions will go where indicated inside
 
 */
class Logger extends Thread {
  public boolean active=false;
  public int sampleInterval=1000;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("asyncFeelerTest.txt"));
  Logger(int in) {
    sampleInterval=in;
    writer.start();
    active=true;
    super.start();
    pause();
  }
  //we should not need to use this method in this app
  void start() {
  }
  void pause() {
    active=false;
  }
  void resumeInfra(){
    active=true;
  }
  void stopInfra() {
    pause();
  }
  void restart() {
    if (!active) {
      active=true;
      timer.restart();
      //the following lines are not required by the logger, but are part of the way we want to log data.
      longTimer.restart();
    }
  }
  void run() {
    while (true) {
      if (active) {
        if (timer.get()>=sampleInterval) {
          logsThisDraw++;
          timer.restart();
          /* here is where the logging function goes: 
           create a string from the desired data, and then .add it to the writer */
          String tt=""+((int) longTimer.get());
          int datetimestr1 = minute()*60+second();
          datetimestr = datetimestr1 - datetimestr0;
          tt+=("."+(longTimer.get()));//pendant: recover the datetimestr1
          /*tt+=(TAB);
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
          tt+=(timeline);*/
          writer.add(tt);
          //println("#"+tt);
          //writer.refresh();
        }
      }
    }
  }
}