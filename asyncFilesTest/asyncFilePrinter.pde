class AsyncFilePrinter extends Thread { //<>//
  private boolean busy=false;
  private boolean paused=false;
  int measuredLength=0;
  boolean active=true;
  public PrintWriter outputPrinter;
  String filename = "default.txt";
  AsyncFilePrinter(String fn) {
    startWriter(fn);
    busy=false;
    active=true;
  }
  void start() {
    busy=true;
    super.start();
  }
  //evaluate if it's currently working on the file, and run again if not.

  private void startWriter(String fn) {
    filename=fn;
    outputPrinter = createWriter(filename);
  }
  void run() {
    //The structure of this loop permits to loop according to the length of the FIFO array while not trying to access it too much
    while (active) {
      if (!paused) {
        if (busy) {
          println(length()+".-");
          //otherwise the thread never stops and clogs processing window on exit. 
          if (has()) {
            String tst=next()+TAB+random(10);
            outputPrinter.println(tst);
            println(tst);
          } else {
            busy=false;
          }
        } else {
          measuredLength=writerFIFO.length;
          busy=measuredLength>0;
        }
      } else {
        busy=false;
      }
    }
  }
  //here we store the queue of elements to be printed to the file;
  private String [] writerFIFO = new String[0];
  private String next() {
    String ret="";
    if (has()) {
      //write the oldest line (0) in queue and remove it from the queue
      ret=writerFIFO[0];
      writerFIFO=subset(writerFIFO, 1);
    }
    return ret;
  }
  void add(String what) {
    paused=true;
    while (busy) {
      //wait
    }
    added++;
    writerFIFO=append(writerFIFO, what);
    paused=false;
    //println(writerFIFO[writerFIFO.length-1]);
  }
  boolean has() {
    return(writerFIFO.length>0);
  }
  int length() {
    if (busy) {
      return measuredLength;
    } else {
      return writerFIFO.length;
    }
  }
}