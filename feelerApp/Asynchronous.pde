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
//function that will handle logging.
class Logger extends Thread {
  //contains all the items to be written to the log. More in the body of this class.
  private AtomicInteger [] varsToLog = new AtomicInteger[11];
  private AtomicBoolean [] requiredAdds = new AtomicBoolean[3];
  private AtomicLong currentLogTimestamp = new AtomicLong(-1);
  public AtomicBoolean active=new AtomicBoolean(false);
  public int sampleInterval=990;//milliseconds sampling interval.
  private Clock timer=new Clock();
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("unnamedLog.tsv"));



  Logger(/*int in*/) {
    //d1 =th1 =la1 =ha1 =lb1 =hb1 =lg1 =mg1 =bl= att= med= tline=-1;
    //init vars to log and requireds. As atomicIntegers, they need individual treatment
    for (int a =0; a<varsToLog.length; a++) {
      varsToLog[a]=new AtomicInteger(-1);
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
      varsToLog[a].set(-1);
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
      if (active.get()) {
        //you can go by two timing algorhythms:
        //the current one is simpler, but may accumulate displacement from the real time, as the time reference is always
        //the last time. The other option is to evaluate the timer in reference to a modulus of a non-restarting time, and if
        //a sample gets delayed, the next frame will be shorter in compensation
        if (timer.get()>=sampleInterval) {
          //here we wait to receive all the pieces of data in the current loop, and then enqueue the string to the file writing thread.
          //if too much time passes, then we just ignore the lack of data. This will result in -1's on the log
          if (allRequiredVarsHaveBeenReceived()|| !timestampBelongs(timer.get())) {//timer.get()<1090
            String tt=""+(int) (currentLogTimestamp.get());
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
            writer.add(tt);
            //writer.refresh();
            resetRequiredVars();
            timer.restart();
            currentLogTimestamp.set(-1);
          }
        }
      }
    }
  }
  private boolean timestampBelongs(long timestamp){
    //cache the value of the currentLogTimestamp
    long ctst=currentLogTimestamp.get();
    //if the currentLogTimestamp is not -1 and the distance of the event is shorter than 90 ms, timestampBelongs is true. otherwise false
    boolean timestampBelongs=(ctst!=-1)&&(timestamp-ctst<90);
    //if it doesnt belong, means that we are writing a new timestamp
    //should we also reset all the data to zero in this case?
    if(!timestampBelongs){
      currentLogTimestamp=longTimer.get();
    }
    return (timestampBelongs);
  }

  //events that may not be included in each line
  public void _poorSignalEvent(int sig, long timestamp) {
  }
  public void _blinkEvent(int strength, long timestamp){
    //this one is not required to be updated
    //make the data ready for the log
    varsToLog[8].set(a)/*blinkSt*/;
  }
  public void _rawEvent(int[] values, long timestamp){
  }

  //events that we require to be logged on each line
  public void _attentionEvent(int attentionLevel, long timestamp) {
    //set the flag of addconcentration happened to true
    requiredAdds[1].set(true);
    //check if this event timestampBelongs to the current sample
    timestampBelongs(long timestamp);
    //make the data ready for the log
    varsToLog[9].set(a)/*attention*/;
  }
  public void _meditationEvent(int meditationLevel, long timestamp) {
    //set the flag of addmeditation happened to true
    requiredAdds[2].set(true);
    //check if this event timestampBelongs to the current sample
    timestampBelongs(long timestamp);
    //make the data ready for the log
    varsToLog[10].set(a);/*meditation*/
  }
  public void _eegEvent(int a, int b, int c, int d, int e, int f, int g, int h, long timestamp) {
    //set the flag of addeeg happened to true
    requiredAdds[0].set(true);
    //check if this event timestampBelongs to the current sample
    timestampBelongs(long timestamp);
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