//atomics are variables that make sure not to be accessed twice at the same time, avoiding halts
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicBoolean;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

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