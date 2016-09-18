class StringQueue {
  //here we store the queue of elements to be printed to the file;
  public String [] writerFIFO = new String[0];
  fileQueue(String fn) {
  }
  String get() {
    if (has()) {
      //write the oldest line (0) in queue and remove it from the queue
      outputPrinter.println(writerFIFO[0]);
      writerFIFO=subset(writerFIFO, 1);
    }
  }
  void add(String what){
    writerFIFO=append(writerFIFO,what);
  }
  Boolean has(){
    return(writerFIFO.length>0);
  }
}