
PFont f;
boolean ran=false;
AsyncFilePrinter writer= new AsyncFilePrinter(this);
StringQueue queue=new StringQueue();
void setup() {
  size(400, 160);
  f = createFont("SourceCodePro-Regular.ttf", 90);
  textFont(f);
  textAlign(CENTER, CENTER);
  writer.start("test.txt");

}
void draw() {
  background(255);
  if (!ran) {
    fill(128);
  } else {
    fill(0);
  }
  String tt="."+((int) longTimer.get());
  text(tt, width/2, height/2);
  queue.add(tt);
  writer.renew(90000);
  //println(queue.has());
  //println(queue.length());
}