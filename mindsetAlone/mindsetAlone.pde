Clock longTimer;
import processing.serial.*;
import pt.citar.diablu.processing.mindset.*;
MindSet r;
int attention;
int meditation;
int signalQuality;
PrintWriter writer=createWriter("isolated-mindset-test.txt");
graphBuffer grap0, grap1;
void setup() {
  boolean connected=false;
  longTimer=new Clock();
  frameRate(90);
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
  size(700, 200);
  
  grap0=new graphBuffer(width);
  grap1=new graphBuffer(width);
  
}
void draw() {
  background(255);
  stroke(0,0,0);
  grap0.draw();
  stroke(255,0,0);
  
  grap1.draw();
  //here I am trying to simulate a very busy process
  /*float clog=0;
  /*while ((clog)<0.99999997) {
    clog=random(1);
  }*/
  //println(longTimer.get()+"att"+attention);
}

public void poorSignalEvent(int sig) {
  signalQuality=sig;
  println("poorsignalev"+longTimer.get());
}

void attentionEvent(int attentionLevel) {
  attention = attentionLevel;
  println("attentionev"+longTimer.get());
}

void meditationEvent(int meditationLevel) {
  meditation = meditationLevel;
  println("meditationev"+longTimer.get());
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
  //println("blinkEvent: " + strength);
  println("blinkev"+longTimer.get());
}

void rawEvent(int[] values) {
  //so this works pretty much like an audio buffer.
  //the sampling fq is 512 and the buffer size aswell, and is dumped here each second.
  for(int a=0; a<values.length; a++){
    grap1.add(values[a]);
  }
  //println(values.length); 
  //println("rawEvent: " + values);
  println("rawdata"+longTimer.get());
}


void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
    grap0.add(mid_gamma/100);
    println("eegev"+longTimer.get());
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
class graphBuffer {
  int [] graph;
  graphBuffer(int len) {
    graph=new int[len];
  }
  void add(int val) {
    for (int  a=graph.length-1; a>0; a--) {
      graph[a]=graph[a-1];
    }
    graph[0]=val;
  }

  void draw() {
    for (int  a=0; a<graph.length; a++) {
      line(a, height, a, height-graph[a]*height/100);
    }
  }
}