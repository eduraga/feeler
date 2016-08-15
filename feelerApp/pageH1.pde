void pageH1(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(28);
  //fill(100); // added by Eva
  text(title, padding, headerHeight + padding);
  popStyle();
}

void pageH2(String title){
  pushStyle();
  textAlign(LEFT);
  textSize(20);
  text(title, padding, headerHeight + padding + 50);
  popStyle();
}