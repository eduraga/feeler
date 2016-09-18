
PFont f;
boolean ran=false;
//public StringQueue =new StringQueue();
AsyncFilePrinter writer= new AsyncFilePrinter();

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
  writer.add(tt);
  writer.restart();
  //println(queue.has());
  println(writer.length());
}