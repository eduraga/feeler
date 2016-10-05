//atomics are variables that make sure not to be accessed twice at the same time, avoiding halts
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
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
    //String clen="0";
    synchronized(bufferLock) {
      buffer=append(buffer, what);
      bufferLengthCache.set(buffer.length);
      //clen=what+"@["+bufferLengthCache.get()+"]rc"+recording;
    }
    //println(clen);
    //cacheLength=bufferLengthCache.get();
  }
}
//function that will handle logging.
class Logger extends Thread {
  //contains all the items to be written to the log. More in the body of this class.
  private AtomicInteger [] varsToLog = new AtomicInteger[11];
  private AtomicBoolean [] requiredAdds = new AtomicBoolean[3];
  private AtomicLong currentLogTimestamp = new AtomicLong(-1);
  // integer that logging vars will contain if they are not filled and too much time passes.
  int fallbackInt=0;//-1 would be ideal, but need an adaptation in behalf of graphing the files
  public AtomicBoolean active=new AtomicBoolean(false);
  public int sampleInterval=990;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("unnamedLog.tsv"));



  Logger(/*int in*/) {
    //d1 =th1 =la1 =ha1 =lb1 =hb1 =lg1 =mg1 =bl= att= med= tline=-1;
    //init vars to log and requireds. As atomicIntegers, they need individual treatment
    for (int a =0; a<varsToLog.length; a++) {
      varsToLog[a]=new AtomicInteger(fallbackInt);
    }
    for (int a =0; a<requiredAdds.length; a++) {
      requiredAdds[a]=new AtomicBoolean(false);
    }
    //resetRequiredVars();
    sampleInterval=990;//in;
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
  void setPath(String filename) {
    //get the current active value, pause my thread, stop and redo the writer, go back to the previous thread active value
    boolean tempActive=active.get();
    active.set(false);
    writer.interrupt();
    //writer.active=false;
    writer=new asyncBufferedOutput(filename);
    writer.start();
    active.set(tempActive);
  }
  void resumeInfra() {
    if (!active.get()) {
      active.set(true);
      //timer.restart();
    }
  }


  //sets the required adds to false, to indicate that they have been written already, and we need to receive them again in order to write them again
  void resetRequiredVars() {
    for (int a =0; a<varsToLog.length; a++) {
      varsToLog[a].set(fallbackInt);
    }
    for (int a =0; a<requiredAdds.length; a++) {
      requiredAdds[a].set(false);
    }
  }
  synchronized boolean allRequiredVarsHaveBeenReceived() {
    for (int a =0; a<requiredAdds.length; a++) {
      if (!requiredAdds[a].get()) {
        return false;
      }
    }
    return true;
  }

  void run() {
    while (true) {
      //if(timeline!=4) this would be a messy place to put this, albeit it would stop the log in a more precise place
      if (active.get()) {
        
        
        long CLTS=currentLogTimestamp.get();
        //if the first data timestamp is older than 300 ms, we probably will not receive any more data for this sample.
        if (CLTS!=-1&&longTimer.get()-CLTS>=300) {
        
          String tt=""+((int) timer.get()/1000);
          tt+=(TAB);
          tt+=(varsToLog[0].get()/*delta1*/);
          tt+=(TAB);
          tt+=(varsToLog[1].get()/*theta1*/);
          tt+=(TAB);
          tt+=(varsToLog[2].get()/*low_alpha1*/);
          tt+=(TAB);
          tt+=(varsToLog[3].get()/*high_alpha1*/);
          tt+=(TAB);
          tt+=(varsToLog[4].get()/*low_beta1*/);
          tt+=(TAB);
          tt+=(varsToLog[5].get()/*high_beta1*/);
          tt+=(TAB);
          tt+=(varsToLog[6].get()/*low_gamma1*/);
          tt+=(TAB);
          tt+=(varsToLog[7].get()/*mid_gamma1*/);
          tt+=(TAB);
          tt+=(varsToLog[8].get()/*blinkSt*/);
          tt+=(TAB);
          tt+=(varsToLog[9].get()/*attention*/);
          tt+=(TAB);
          tt+=(varsToLog[10].get()/*meditation*/);
          tt+=(TAB);
          tt+=(timeline);
          //if(!test){
          //  tt+=("incomplete");
          //}
          writer.add(tt);
          //writer.refresh();
          resetRequiredVars();
       
          currentLogTimestamp.set(-1);
        }
      }
      //}
    }
  }

  private synchronized void incomingTimeStamp(long eventTime){
    //set the currentTimestamp to the provided if the current timestamp is set to -1
    //currentTimestamp will be -1 if all the data has been written, or the log is starting.
    //this indigates that the incoming set of data is the first, and the log timestamp will belong 
    //to the time that data came.
    if(currentLogTimestamp.get()==-1){
      currentLogTimestamp.set(eventTime);
    }
  }
  //events that may not be included in each line and dont use regular timestamp
  //public void _poorSignalEvent(int a, long timestamp) {
  //}
  //public void _blinkEvent(int a, long timestamp) {
    //this one is timestamp independent.
    //make the data ready for the log
    //varsToLog[8].set(a)/*blinkSt*/;
  //}
  public void _rawEvent(int[] a, long timestamp) {
    //incomingTimeStamp(timestamp);
  }

  //events that we require to be logged on each line
  public void _attentionEvent(int a, long timestamp) {
    incomingTimeStamp(timestamp);
    varsToLog[9].set(a)/*attention*/;
  }
  public void _meditationEvent(int a, long timestamp) {
    incomingTimeStamp(timestamp);
    //make the data ready for the log
    varsToLog[10].set(a);/*meditation*/
    println("_meditationevent");
  }
  public void _eegEvent(int a, int b, int c, int d, int e, int f, int g, int h, long timestamp) {
    incomingTimeStamp(timestamp);
    //make the data ready for the log
    varsToLog[0].set(a)/*delta1*/;
    varsToLog[1].set(b)/*theta1*/;
    varsToLog[2].set(c)/*low_alpha1*/;
    varsToLog[3].set(d)/*high_alpha1*/;
    varsToLog[4].set(e)/*low_beta1*/;
    varsToLog[5].set(f)/*high_beta1*/;
    varsToLog[6].set(g)/*low_gamma1*/;
    varsToLog[7].set(h)/*mid_gamma1*/;
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
  synchronized public long get() {
    return System.currentTimeMillis()-startMillis;
  }
  int getInt(int module) {
    return (int) (System.currentTimeMillis()-startMillis)%module;
  }
}