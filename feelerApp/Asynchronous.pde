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

  synchronized void addeeg(int a, int b, int c, int d, int e, int f, int g, int h) {
    //set the flag of addeeg happened to true
    requiredAdds[0].set(true);
    //make the data ready for the log
    varsToLog[0].set(a)/*delta1*/;
    varsToLog[1].set(b)/*theta1*/;
    varsToLog[2].set(c)/*low_alpha1*/;
    varsToLog[3].set(d)/*high_alpha1*/;
    varsToLog[4].set(e)/*low_beta1*/;
    varsToLog[5].set(f)/*high_beta1*/;
    varsToLog[6].set(g)/*low_gamma1*/;
    varsToLog[7].set(h)/*mid_gamma1*/;
  };
  synchronized void addattention(int a) {
    //set the flag of addconcentration happened to true
    requiredAdds[1].set(true);
    //make the data ready for the log
    varsToLog[9].set(a)/*attention*/;
  }
  synchronized void addmeditation(int a) {
    //set the flag of addmeditation happened to true
    requiredAdds[2].set(true);
    //make the data ready for the log
    varsToLog[10].set(a);/*meditation*/
  }
  synchronized void addBlink(int a) {
    //this one is not required to be updated
    //make the data ready for the log
    varsToLog[8].set(a)/*blinkSt*/;
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
          //if too much time passes, then we just ignore the lacking data. This will result in -1's on the log
          while (!allRequiredVarsHaveBeenReceived()&&timer.get()<1200) {
            
            try {
              Thread.sleep(1);
            } 
            catch (InterruptedException e) {
              println("exception in thread sleep at logger class");
              println(e);
            }
          }
          String tt=""+(int) (longTimer.get());
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
        }
      }
    }
  }
}

//MindSet functions

float attoff = 0.01;
float medoff = 0.0;

//MindSet stuff
MindSet mindSet;
boolean mindSetOK = false;
boolean mindSetPortOk = false;
int mindSetId;

public void initMindset() {
  mindSet = new MindSet(this, "/dev/cu.MindWaveMobile-DevA");
}

void simulate() {
  if (recording) {
    poorSignalEvent(int(random(200)));

    //simulate with noise
    attoff = attoff + .02;
    medoff = medoff + .01;
    //comment the following two lines to simulate with mouse
    //attentionEvent(int(noise(attoff) * 100));
    // meditationEvent(int(noise(medoff) * 100));

    //simulate with mouse
    //uncomment the following two lines to simulate with mouse
    //attentionEvent(int(map(mouseX, 0, width, 0, 100)));
    //meditationEvent(int(map(mouseY, 0, height, 0, 100)));

    /*eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
     int(random(20000)), int(random(20000)), int(random(20000)), 
     int(random(20000)), int(random(20000)) );*/

    //simulate with sine/cosine waves

    int sine=int(sin(longTimer.get()/1000.00)*5000+5000);
    int cosine=int(cos(longTimer.get()/1000.00)*5000+5000);
    attentionEvent(sine / 100);
    meditationEvent(cosine / 100);

    eegEvent(sine, cosine, sine, cosine, sine, cosine, sine, cosine);
  }
}

public void poorSignalEvent(int sig) {
  //signalWidget.add(200-sig);
  //println("poorSignal: " + sig);
  if (sig == 200) {
    mindSetOK=false;
  } else {
    mindSetOK=true;
  }
}

public void attentionEvent(int attentionLevel) {
  //attentionWidget.add(attentionLevel);
  //println("attentionLevel: " + attentionLevel);
  attention = attentionLevel;
  logger.addattention(attentionLevel);
}

public void meditationEvent(int meditationLevel) {
  //meditationWidget.add(meditationLevel);
  //println("meditationLevel: " + meditationLevel);
  meditation = meditationLevel;
  logger.addmeditation(meditationLevel);
}

public void blinkEvent(int strength) {
  println("blinkEvent: " + strength);
  logger.addBlink(strength);
}

public void rawEvent(int[] values) {
  //println("rawEvent: " + values);
}

public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  delta1 = delta;
  theta1 = theta;
  low_alpha1 = low_alpha;
  high_alpha1 = high_alpha;
  low_beta1 = low_beta;
  high_beta1 = high_beta;
  low_gamma1 = low_gamma;
  mid_gamma1 = mid_gamma;
  logger.addeeg(delta,theta,low_alpha,high_alpha,low_beta,high_beta,low_gamma,mid_gamma);
  //println("delta1: " + delta1);
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