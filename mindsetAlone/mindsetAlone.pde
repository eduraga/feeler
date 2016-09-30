Clock longTimer;
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;
MindSet r;
int attention;
int meditation;
int signalQuality;
PrintWriter writer=createWriter("isolated-mindset-test.txt");
int [] graph;
void setup() {
  boolean connected=false;
  longTimer=new Clock();
  frameRate(30);
  writer.println("data=[");
  thread("miniThreadLog");
  println("waiting for mindset to be connected");
  while (!connected) {
    println("trying to connect now");
    try {
      r = new MindSet(this, "/dev/cu.MindWaveMobile-DevA");
      connected=true;
      println("connected successfully to mindset");
    }
    catch(Exception e) {
      println(e);
      delay(600);
    }
  }
  size(300, 200);
  graph=new int[width];
}
void draw() {
  background(255);
  for (int  a=0; a<graph.length; a++) {
    line(a, height, a, height-graph[a]*height/100);
  }
  //println(longTimer.get()+"att"+attention);
}

public void poorSignalEvent(int sig) {
  signalQuality=sig;
}

void attentionEvent(int attentionLevel) {
  attention = attentionLevel;
  for (int  a=graph.length-1; a>0; a--) {
    graph[a]=graph[a-1];
  }
  graph[0]=attention;
}

void meditationEvent(int meditationLevel) {
  meditation = meditationLevel;
}

void miniThreadLog() {
  long interval=10;
  Clock intervalTimer=new Clock();
  while (true) {
    if (intervalTimer.get()>=interval) {
      intervalTimer.restart();
      writer.println("{\"time\":"+longTimer.get()/1000.00+", \"attention\":"+attention+", \"meditation\":"+meditation+"},");
    }
  }
}

void blinkEvent(int strength) {
  println("blinkEvent: " + strength);
}

void rawEvent(int[] values) {
  //println("rawEvent: " + values);
}

void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
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
void exit() {
  writer.println("]");
  writer.flush(); // Write the remaining data
  writer.close(); // Finish the file
}