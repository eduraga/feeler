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
      //println("Writing buffer output to: "+fname);
      // if file doesnt exists, then create it
      if (!f.exists()) {
        f.createNewFile();
      }

      FileWriter fw = new FileWriter(f.getAbsoluteFile());
      file = new BufferedWriter(fw);
      
      println("asyncbufferedoutput pointing to "+f.getAbsoluteFile());
      isWriting=true;
      //file = new PrintWriter(new BufferedWriter(new FileWriter(fname)));
    }
    catch(IOException e) {
      println("exeption when creating a file writer in asyncbufferedoutput");
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
  asyncBufferedOutput writer= new asyncBufferedOutput(sketchPath("unnamedLog.tsv"));

  //MindSet stuff
  MindSet mindSet;
  AtomicBoolean mindSetOK = new AtomicBoolean(false);
  AtomicBoolean mindSetPortOk = new AtomicBoolean(false);
  int mindSetId;

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
  void run() {
    while (true) {
      if (active.get()) {
        //you can go by two timing algorhythms:
        //the current one is simpler, but may accumulate displacement from the real time, as the time reference is always
        //the last time. The other option is to evaluate the timer in reference to a modulus of a non-restarting time, and if 
        //a sample gets delayed, the next frame will be shorter in compensation
        if (timer.get()>=sampleInterval) {
          //println("recording1");
          //logsThisDraw++;

          String tt=""+(int) (longTimer.get());
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
  //MindSet functions

  float attoff = 0.01;
  float medoff = 0.0;

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
      mindSetOK.set(false);
    } else {
      mindSetOK.set(true);
    }
  }

  //void serialEvent(Serial p) { 
  //inString = p.readString();
  //thisSerialValue = p.read();

  //thisFrame = frameCount;

  //println(p.read());
  //println(p.available());
  //println(p.last());
  //if(p.read() == -1){
  //  println("morreu");
  //}

  //mindSetOK = true;
  //}

  public void attentionEvent(int attentionLevel) {
    //attentionWidget.add(attentionLevel);
    //println("attentionLevel: " + attentionLevel);
    attention = attentionLevel;
  }

  public void meditationEvent(int meditationLevel) {
    //meditationWidget.add(meditationLevel);
    //println("meditationLevel: " + meditationLevel);
    meditation = meditationLevel;
  }

  public void blinkEvent(int strength) {
    println("blinkEvent: " + strength);
  }

  public void rawEvent(int[] values) {
    //println("rawEvent: " + values);
  }

  public void eegEvent(int delta, int theta, int low_alpha, 
    int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {  
    delta1 = delta;
    theta1 = theta;
    low_alpha1 = low_alpha;
    high_alpha1 = high_alpha;
    low_beta1 = low_beta;
    high_beta1 = high_beta;
    low_gamma1 = low_gamma;
    mid_gamma1 = mid_gamma;

    println("delta1: " + delta1);

    //deltaWidget.add(delta);
    //thetaWidget.add(theta);
    //lowAlphaWidget.add(low_alpha);
    //highAlphaWidget.add(high_alpha);
    //lowBetaWidget.add(low_beta);
    //highBetaWidget.add(high_beta);
    //lowGammaWidget.add(low_gamma);
    //midGammaWidget.add(mid_gamma);
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