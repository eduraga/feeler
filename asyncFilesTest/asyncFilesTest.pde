int logsThisDraw=0;
int added=0;
public int cacheLength=0;
PFont f;
public boolean ran=false;
//public StringQueue =new StringQueue();

Logger logger=new Logger(10);
void setup() {

  size(400, 160);
  f = createFont("SourceCodePro-Regular.ttf", 90);
  textFont(f);
  textAlign(CENTER, CENTER);

  logger.start();
  noStroke();
}
String tt="";
void draw() {
  background(255);
  fill(0);
  if (logger.active.get()) {
    tt="."+((int) longTimer.get());
  }
  text(tt, width/2, height/2);

  rect(0, 0, logsThisDraw, 10);
  fill(255, 100, 100);
  rect(logsThisDraw, 0, added, 10);
  fill(255, 30, 30);
  rect(0, 10, cacheLength, 10);
  logsThisDraw=0;
  added=0;
  
}
void keyPressed() {
    if (logger.active.get()) {
      logger.pause();
    } else {
      logger.restart();
    }
    saveFrame("line-######.png");
}