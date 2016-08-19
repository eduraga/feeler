void pageH1(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(34);
  fill(50);
  //fill(100); // added by Eva
  text(title, 100, headerHeight + padding + 30);
  popStyle();
}

void pageH2(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(24);
  fill(50);
  //fill(textDarkColor);
  text(title, 210, headerHeight + padding + 120 + 40);
  popStyle();
}

void pageH3(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(24);
  fill(50);
  //fill(textDarkColor);
  text(title, 800, headerHeight + padding + 120 + 40);
  popStyle();
}

void pageH4(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(12);
  fill(textDarkColor);
  text(title, 210, headerHeight + 585);
  popStyle();
}

void pageH5(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(12);
  fill(textDarkColor);
  text(title, 800, headerHeight + 585);
  popStyle();
}