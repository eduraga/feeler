
class AsyncFilePrinter extends Thread {
  
  
  public boolean active=false;
  public boolean writing=false;
  public PrintWriter outputPrinter;
  String filename = "default.txt";
  AsyncFilePrinter() {
    active=false;
  }
  void start(String fn) {
    startWriter(fn);
    active=true;
    //start();
    super.start();
    //run();
  }
  void restart(){
    active=true;
    run();
  }
  void startWriter(String fn) {
    filename=fn;
    outputPrinter = createWriter(filename);
    //if we needed an exception handler, would go here.
    writing=true;
  }
  void run() {
    while (active) {
      //otherwise the thread never stops and clogs processing window on exit. 
      if (writing) {
        
        if (has()){
          ran=true;
          String tst=next()+TAB+random(10);
          outputPrinter.println(tst);
          println(tst);
        }else{
          active=false;
        }
      }

    }
  }
  //here we store the queue of elements to be printed to the file;
  String [] writerFIFO = new String[0];
  String next() {
    String ret="";
    if (has()) {
      //write the oldest line (0) in queue and remove it from the queue
      ret=writerFIFO[0];
      writerFIFO=subset(writerFIFO, 1);
    }
    return ret;
  }
  void add(String what) {
    writerFIFO=append(writerFIFO, what);
    println(writerFIFO[writerFIFO.length-1]);
  }
  boolean has() {
    return(writerFIFO.length>0);
  }
  int length() {
    return writerFIFO.length;
  }
}