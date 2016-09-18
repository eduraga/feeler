StringQueue lines=new StringQueue();

class AsyncFilePrinter extends Thread {
  PApplet parent;
  public int life=9000;
  public boolean active=false;
  public boolean writing=false;
  public PrintWriter outputPrinter;
  String filename = "default.txt";
  AsyncFilePrinter(PApplet p) {
    parent=p;
    active=false;
  }
  void start(String fn) {
    startWriter(fn);
    active=true;
    //start();
    super.start();
    //run();
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
      if(life<1){
        active=false;
        outputPrinter.flush();
        outputPrinter.close();
      }
      life--;
      if (writing) {
        
        //if (queue.has()){
          ran=true;
          outputPrinter.println(queue.next());
        //}
      }
    }
  }
}