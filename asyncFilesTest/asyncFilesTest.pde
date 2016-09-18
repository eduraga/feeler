
PFont f;
AsyncFilePrinter writer= new AsyncFilePrinter();
StringQueue queue=new StringQueue();
void setup(){
  size(400,160);
  f = createFont("SourceCodePro-Regular.ttf", 90);
  textFont(f);
  textAlign(CENTER, CENTER);
  writer.start("test.txt");
}
void draw(){
  background(255);
  fill(0);
  text((int) longTimer.get(),width/2,height/2);
}