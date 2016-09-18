StringQueue lines=new StringQueue();

class AsyncFilePrinter extends Thread {
  AsyncFilePrinter() {
  }
  public boolean running=false;
  public boolean writing=false;
  public PrintWriter outputPrinter;
  String filename = "default.txt";
  //here we store the queue of elements to be printed to the file;
  void start(String fn) {
    startWriter(fn);
    super.start();
  }
  void startWriter(String fn) {
    String filename=fn;
    outputPrinter = createWriter(filename);
    //if we needed an exception handler, would go here.
    writing=true;
  }
  public void run() {
    running=true;
    while (running) {
      if (writing) {
        if(
        outputPrinter.println(writerFIFO[0]);

      }
    }
  }
  public void stop() {
    running=false;
  }
}