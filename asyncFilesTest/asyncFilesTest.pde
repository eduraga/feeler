int logsThisDraw=0;
int added=0;
PFont f;
public boolean ran=false;
//public StringQueue =new StringQueue();
AsyncFilePrinter writer= new AsyncFilePrinter();
Logger logger=new Logger(30,writer);
void setup() {

  size(400, 160);
  f = createFont("SourceCodePro-Regular.ttf", 90);
  textFont(f);
  textAlign(CENTER, CENTER);
  writer.start("test.txt");
  logger.start();
  noStroke();
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
  //writer.add(tt);
  writer.restart();
  rect(0,0,logsThisDraw,10);
  fill(255,100,100);
  rect(logsThisDraw,0,added,10);
  logsThisDraw=0;
  added=0;
  //println(writer.length()+".-");
  
}