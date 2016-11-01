void pageH1(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(34);
  fill(50);
  text(title, 100, headerHeight + padding + 30);
  popStyle();
}

void pageH2(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(24);
  fill(50);
  text(title, 175, headerHeight + padding + 120 + 40);
  popStyle();
}

void pageH3(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(24);
  fill(50);
  text(title, 710, headerHeight + padding + 120 + 40);
  popStyle();
}

void pageH4(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(12);
  fill(textDarkColor);
  text(title, 175, headerHeight + padding*28.5);
  popStyle();
}

void pageH5(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(12);
  fill(textDarkColor);
  text(title, 710, headerHeight + padding*28.5);
  popStyle();
}

void pageH6(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(18);
  fill(textLightColor);
  text(title, 118, headerHeight + padding + 75 + 100);
  //120, headerHeight + padding*10);
  popStyle();
}