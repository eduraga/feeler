//functions to get more easily millis from a point. 
//Starting point is when startMillis(), and getrlMillis returns millis from that point 
class millicount {
  long startMillis=0;
  millicount() {
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
millicount mil=new millicount();