class StringQueue {
  //here we store the queue of elements to be printed to the file;
  public String [] writerFIFO = new String[0];
  StringQueue() {
  }
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
  }
  Boolean has() {
    
    return(writerFIFO.length>0);
  }
  int length() {
    return writerFIFO.length;
  }
}