class LineChart {
  String type;
  int _listSize;
  int grainSize;
  int maxVal = 100;
  float stepSize;

  int minimumScreenshotWidth=7;
  //int visX;

  float relaxEnd = 0;
  float studyEnd = 0;
  float playEnd = 0;

  FloatList thisTime = new FloatList();
  FloatList thisX = new FloatList();
  FloatList previousX = new FloatList();
  FloatList thisAtt = new FloatList();
  FloatList previousAtt = new FloatList();
  FloatList thisRelax = new FloatList();
  FloatList previousRelax = new FloatList();
  StringList screenshots = new StringList();

  int currentImg;

  LineChart() {
  }

  void setup(String _type) {
    type = _type;

    if (sessionFolders != null) {
      if (type == "averages") {
        //visX = visY;
        grainSize = 1;
        if (sessionFolders.length < 10) {
          _listSize = listSize;
        } else {
          _listSize = sessionFolders.length;
        }
      } else if (type == "personal") {
        grainSize = 1;
        _listSize = 3;
      } else if (type == "values") {
        grainSize = 40;
        //visX = visY + headerHeight + padding*2;
        //_listSize = sessionFolders.length;

        //for(int i = 0; i < _listSize; i++){
        //if(sessionFolders[i].charAt(0) == '2'){
        if (data.data != null) {
          _listSize = data.data.length;
          //max is to avoid grainsize to be zero if the file is shorter than 100 lines
          grainSize = 1;//grainSize = max((int)data.data.length/100, 1);
          //variables for screenshots display
          File imgTempFolder = new File(userFolder + "/" + sessionFolders[currentItem] + "/screenshots");
          screenshotsArray = imgTempFolder.list();

          for (int j = 0; j < _listSize; j+=grainSize) {
            //println("graph-grain-"+j);
            if (data.data[j][12] > 0 && j > grainSize) {

              thisX.set(j, j * visWidth/data.data.length + visX);
              previousX.set(j, (j-grainSize) * visWidth/data.data.length + visX);

              if (data.data[j][12] == 1) {
                fill(250);
                relaxEnd = thisX.get(j);
              }
              if (data.data[j][12] == 2) {
                fill(230);
                studyEnd = thisX.get(j);
              }
              if (data.data[j][12] == 3) {
                fill(210);
                playEnd = thisX.get(j);
              }

              if (data.data[j-grainSize][10] > 0) {
                previousAtt.set(j, map(data.data[j-grainSize][10], 0, maxVal, lowerBoundary, upperBoundary));
              } else {
                previousAtt.set(j, lowerBoundary);
              }

              if (data.data[j][10] > 0) {
                thisAtt.set(j, map(data.data[j][10], 0, maxVal, lowerBoundary, upperBoundary));
              } else {
                thisAtt.set(j, lowerBoundary);
              }

              if (data.data[j-grainSize][11] > 0) {
                previousRelax.set(j, map(data.data[j-grainSize][11], 0, maxVal, lowerBoundary, upperBoundary));
              } else {
                previousRelax.set(j, lowerBoundary);
              }

              if (data.data[j][11] > 0) {
                thisRelax.set(j, map(data.data[j][11], 0, maxVal, lowerBoundary, upperBoundary));
              } else {
                thisRelax.set(j, lowerBoundary);
              }


              //if (data.data[j][0] > 0) {
              //  if(data.data[j][0] != data.data[j-grainSize][0])
              //  thisTime.set(j, data.data[j][0]);
              //} else {
              //  thisTime.set(j, 0);
              //}

              thisTime.set(j, data.data[j][0]);

              /////////////////////////////// Image stuff
              //////////////////////////////////////////////

              screenshots.set(j, "");
              int thisTime=int(data.data[j][0]);
              //println(" for time "+thisTime+"["+j+"]");
              for (int k = 0; k < screenshotsArray.length; k++) {
                if (screenshotsArray[k]!=null) {
                  String screenshot = screenshotsArray[k];
                  //println("   for scrnshot "+screenshot+"["+k+"]");
                  int screenshotTimeId = int(splitTokens(screenshot, "-")[0]);
                  if (screenshotTimeId<=thisTime) {
                    // println("   goes");
                    screenshots.set(j, imgTempFolder + "/" +screenshotsArray[k]);
                    screenshotsArray[k]=null;
                  } else {
                    // println("   doesnt go");
                  }
                }
              }
            }
          }
        }
        //}

        //}
      }
      stepSize = visWidth/_listSize;
    } else {
      //visX = visY;
      _listSize = 1;
      stepSize = 1;
    }
  }

  void display() {
    fill(graphBgColor);
    rect(visX - padding, visY - padding + 40, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2); // linechart background
    //rect(visX - padding - 15, visX - padding - 5, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2 + 5); // linechart background

    if (fileName != null && sessionFolders != null) {
      displayData();
    } else {
      fill(textDarkColor);
      pushStyle();
      textAlign(CENTER);
      textSize(24);
      text("Eager to see some data?\nStart a New session", visX - 30, visHeight/2 + visX - 50, visWidth, visHeight);
      popStyle();
    }

    //Labels
    pushStyle();
    textAlign(RIGHT, CENTER);
    fill(textDarkColor);
    textSize(12);// added by Eva
    text("100%", visX - padding*2, upperBoundary);
    text("50%", visX - padding*2, lowerBoundary + (upperBoundary - lowerBoundary)/2);
    text("0%", visX - padding*2, lowerBoundary);


    if (type == "values") text("seconds", visX - padding*1.5, visY + visHeight + padding*4 + 10);
    popStyle();
  }

  void displayData() {
    fill(textDarkColor);
    if (type == "averages") {
      pushStyle();
      textAlign(LEFT);
      text("Averaged values of the EEG data and your personal experience", visX - padding, visHeight + visX + padding * 10);
      popStyle();
    } else if (type == "values") {
      stroke(100, 100);
      line(relaxEnd, visY + padding*3, relaxEnd, visY + padding*3 + visHeight);
      line(studyEnd, visY + padding*3, studyEnd, visY + padding*3 + visHeight);

      pushStyle();
      noFill();
      ////debug label boxes
      //stroke(255,0,0);
      //rect(visX + padding, visY + padding*3 - 20, relaxEnd - (visX + padding), 20);
      //rect(relaxEnd , visY + padding*3 - 20, studyEnd - relaxEnd, 20);
      //rect(studyEnd , visY + padding*3 - 20, playEnd - studyEnd, 20);
      fill(textDarkColor);
      textAlign(CENTER, CENTER);
      text("MEDITATE", visX + padding, upperBoundary - padding*1.4, relaxEnd - (visX + padding), 20);
      if (studyEnd > relaxEnd) text("STUDY", relaxEnd, upperBoundary - padding*1.4, studyEnd - relaxEnd, 20);
      if (playEnd > studyEnd) text("PLAY", studyEnd, upperBoundary - padding*1.4, playEnd - studyEnd, 20);
      popStyle();
    } else if (type == "personal") {
      pushStyle();
      textAlign(CENTER);
      fill(textDarkColor);
      text("MEDITATE", visX + padding, upperBoundary - padding*1.4, relaxEnd - (visX + padding), 20);
      text("STUDY", relaxEnd, upperBoundary - padding*1.4, studyEnd - relaxEnd, 20);
      text("PLAY", studyEnd, upperBoundary - padding*1.4, playEnd - studyEnd, 20);
      popStyle();
    }


    fill(textDarkColor);
    if (fileName[0].charAt(0) != '.') {
      String[] fileDate = split(fileName[0], '-');

      float rlxAvg = 0;
      float attAvg = 0;

      if (type == "eeg") {
        pushStyle();
        fill(textDarkColor);
        textAlign(LEFT, CENTER);
        textSize(20);
        text(fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5], 100, headerHeight + padding + 60);
        popStyle();

        rlxAvg = relaxationAverageList[currentItem];
        attAvg = attentionAverageList[currentItem];
      }
    }

    if (type == "averages") {
      pageH1("Review");
      textSize(20);
      fill(50);
      text("Your activity", 100, headerHeight + padding + 70);


      for (int i = 0; i < _listSize; i+=grainSize) {
        float thisX = i * stepSize + visX + stepSize/2;
        float previousX = (i-1) * stepSize + visX + stepSize/2;

        if (sessionFolders[i].charAt(0) == '2') {
          pushStyle();
          textAlign(LEFT, CENTER);
          String[] fileDate = split(sessionFolders[i], '-');

          float attAvg = 0;
          float rlxAvg = 0;

          float prevAttAvg = 0;
          float prevRlxAvg = 0;

          attAvg = map(attentionAverageList[i], 0, 100, lowerBoundary, upperBoundary); // last value modifies the heigth of the ellipses
          rlxAvg = map(relaxationAverageList[i], 0, 100, lowerBoundary, upperBoundary);


          if (i>0) {
            prevAttAvg = map(attentionAverageList[i-1], 0, 100, lowerBoundary, upperBoundary);
            prevRlxAvg = map(relaxationAverageList[i-1], 0, 100, lowerBoundary, upperBoundary);

          }

          if (mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2) {
            if (type == "averages") {
              hoverUpLeft.set(thisX - dotSize/2, visX);
              hoverDownRight.set(thisX + dotSize/2, visX + visHeight + dotSize/2);

              if (mouseY >= upperBoundary && mouseY <= lowerBoundary) {
                fill(250);
                rect(thisX - dotSize/2, upperBoundary, dotSize, visHeight);//selection column, transparent

                pushStyle();
                fill(255);
                stroke(textLightColor);
                rect(mouseX, mouseY, 120, 60);

                fill(attentionColor);
                textSize(12);// added by Eva
                text("Attention " + round(attentionAverageList[i]), mouseX + padding, mouseY + padding);
                fill(relaxationColor);
                text("Relaxation " + round(relaxationAverageList[i]), mouseX + padding, mouseY + padding * 2);
                popStyle();
              }
            }
            noStroke();
          }

          if (attentionAverageList[i] > 0) {
            fill(attentionColor);
            ellipse(thisX, attAvg, dotSize, dotSize);
          }

          if (relaxationAverageList[i] > 0) {
            fill(relaxationColor);
            ellipse(thisX, rlxAvg, dotSize, dotSize);
          }


          fill(textDarkColor);
          textAlign(CENTER, CENTER);
          textSize(12);
          text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visX + padding*5.3 + 40); // legend about date and time. Averaged values page
          text(fileDate[3] + ":" + fileDate[4], thisX, visHeight + visX + padding*6.3 + 40);
          popStyle();
        }
      }
    } else if (type == "personal") {
      try {
        for (int i = 0; i < _listSize; i+=grainSize) {
          float thisX = i * stepSize + visX + stepSize/2;
          float previousX = (i-1) * stepSize + visX + stepSize/2;
          float prevMeditate = 0;
          float thisMeditate = 0;
          float prevStudy = 0;
          float thisStudy = 0;

          thisMeditate = map(float(assessmentData[i+3]), maxVal, 0, upperBoundary, lowerBoundary);// modified by Eva
          thisStudy = map(float(assessmentData[i+6]), maxVal, 0, upperBoundary, lowerBoundary);// modified by Eva
          //thisMeditate = map(float(assessmentData[i+3]), maxVal, 0, visX, visHeight + visX);// original
          //thisStudy = map(float(assessmentData[i+6]), maxVal, 0, visX, visHeight + visX);// original

          if (i > 0) {
            prevMeditate = map(float(assessmentData[i-1+3]), maxVal, 0, upperBoundary, lowerBoundary);// modified by Eva
            prevStudy = map(float(assessmentData[i-1+6]), maxVal, 0, upperBoundary, lowerBoundary);// modified by Eva
            //prevMeditate = map(float(assessmentData[i-1+3]), maxVal, 0, visX, visHeight + visX);// original
            //prevStudy = map(float(assessmentData[i-1+6]), maxVal, 0, visX, visHeight + visX);// original

            stroke(relaxationColor);
            line(
              previousX, 
              prevMeditate, 
              thisX, 
              thisMeditate
              );

            stroke(attentionColor);
            line(
              previousX, 
              prevStudy, 
              thisX, 
              thisStudy
              );
          }
          noStroke();

          if (mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2) {
            if (mouseY >= upperBoundary && mouseY <= lowerBoundary) {
              fill(250);
              rect(thisX - dotSize/2, upperBoundary, dotSize, visHeight);

              pushStyle();
              fill(255);
              stroke(textLightColor);
              rect(mouseX, mouseY, 160, padding*4);
              fill(attentionColor);
              text("Attention " + assessmentData[i+6], mouseX + padding, mouseY + padding);
              fill(relaxationColor);
              text("Relaxation " + assessmentData[i+3], mouseX + padding, mouseY + padding * 2);
              fill(textDarkColor);
              text("Feeling " + assessmentData[i], mouseX + padding, mouseY + padding * 3);
              popStyle();
            }
          }


          fill(relaxationColor);
          ellipse(thisX, thisMeditate, dotSize, dotSize);

          fill(attentionColor);
          ellipse(thisX, thisStudy, dotSize, dotSize);

          float offset = (thisX - previousX)/2;

          if (i == 0) {
            relaxEnd = thisX + offset;
          }
          if (i == 1) {
            studyEnd = thisX + offset;
          }
          if (i == 2) {
            playEnd = thisX + offset;
          }
        }


        String[] fileDate = split(fileName[0], '-');
        pushStyle();
        fill(50);
        pageH1("Review");// added by Eva
        textSize(20);// eva modifying personal experience menu
        textAlign(LEFT);
        text("Your activity / " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5] + " / Personal experience", 100, headerHeight + padding + 70);
        fill(textDarkColor);
        textSize(12);
        fill(textDarkColor);
        text("Your personal experience during the different session stages", visX - padding, visHeight + visX + padding * 8);
        popStyle();
      }catch(Exception e){
        println("could not load personal assessment. File may be incomplete");
        println(e);
      }
    } else {
      for (int i = 0; i < _listSize; i+=grainSize) {
        if (i >= grainSize) {
          displayGeneral(i, _listSize);
        }
      }

      for (int i = 0; i < _listSize; i+=grainSize) {
        if (i >= grainSize) {
          displayThumbs(i);
        }
      }

      pushStyle();
      String[] fileDate = split(fileName[0], '-');
      pageH1("Review");// added by Eva
      textAlign(LEFT);
      fill(50);
      textSize(20);// eva modifying eeg data menu
      text("Your activity / " + fileDate[2] + "." + fileDate[1] + "." + fileDate[0] + ", " + fileDate[3] + ":" + fileDate[4] + ":" + fileDate[5] + " / EEG data", 100, headerHeight + padding + 70);
      textSize(12);
      fill(textDarkColor);
      text("Your EEG data during the different session stages", visX - padding, visHeight + visX + padding * 10);
      popStyle();
    }
  }

  void displayThumbs(int i) {
    if (screenshots.get(i) != "" && screenshots.get(i) != null) {
      if (
        mouseX >= previousX.get(i)
        &&
        mouseX <= thisX.get(i)
        &&
        mouseY >= upperBoundary
        &&
        mouseY <= lowerBoundary
        ) {
        PImage screenshotImg = loadImage(screenshots.get(i));
        //imageMode(CENTER);
        currentImg = i;

        fill(255);
        stroke (85, 26, 139);
        //stroke(255,0,0);
        //stroke(textLightColor);
        rect(thisX.get(i) - screenshotImg.height/6 - padding, mouseY - padding, screenshotImg.width/4 + padding*2, screenshotImg.height/4 + padding*5);
        noStroke();
        image(screenshotImg, thisX.get(i) - screenshotImg.height/6, mouseY + padding*3, screenshotImg.width/4, screenshotImg.height/4);
        pushStyle();
        textAlign(LEFT);
        fill(attentionColor);
        text("Attention " + (int)map(thisAtt.get(i), lowerBoundary, upperBoundary, 0, maxVal) + "%", thisX.get(i) - screenshotImg.height/6, mouseY+padding);
        fill(relaxationColor);
        text("Relaxation " + (int)map(thisRelax.get(i), lowerBoundary, upperBoundary, 0, maxVal) + "%", thisX.get(i) - screenshotImg.height/6, mouseY+padding*2);
        if (debug) {
          fill(99);
          String [] FNAME=screenshots.get(i).split("/");
          text("  //img:" + FNAME[FNAME.length-1], thisX.get(i) - screenshotImg.height/6, mouseY+padding*1.5);
        }
        popStyle();
      } else {
      }
    }
  }

  void displayGeneral(int i, int len) {

    if (screenshots.get(i) != "" && screenshots.get(i) != null) {
      fill(255, 100);
      // stroke(255,0,0);
      rect(previousX.get(i), upperBoundary /* + 20*/, max(minimumScreenshotWidth, thisX.get(i) - previousX.get(i) - 1), visHeight);
    }

    //String currentScreenshot = "";
    noFill();

    stroke(attentionColor);
    line(
      previousX.get(i), 
      previousAtt.get(i), 
      thisX.get(i), 
      thisAtt.get(i)
      );
    stroke(relaxationColor);
    line(
      previousX.get(i), 
      previousRelax.get(i), 
      thisX.get(i), 
      thisRelax.get(i)
      );
    noStroke();

    //define how many labels to put in the graph x axis
    int amountOfLabels=20;
    int _portion=((len-1)/amountOfLabels);
    if (_portion>0)
      if (i%_portion == 0) {
        fill(textDarkColor);
        text(int(thisTime.get(i)), thisX.get(i), visY + visHeight + padding*4 + 17);//modifies the linechart x legend (time)
      }
  }


  void onClick() {
    hoverUpLeft.set(0, 0);
    hoverDownRight.set(0, 0);

    if (sessionFolders != null) {
      if (sessionFolders.length == 0) {
      } else {
        String lines[] = loadStrings(userFolder + "/" + sessionFolders[currentItem] + "/assessment.txt");
        assessmentData = lines;
      }

      if (fileName != null) {
        for (int i = 0; i < _listSize; i++) {
          if (fileName[0].charAt(0) != '.') {
            if (currentPage == "eegActivity") {
              if (type == "values" && i == currentImg && mouseY <= lowerBoundary && mouseY >= upperBoundary) {
                if (mouseX >= thisX.get(i) - dotSize/2 && mouseX <= thisX.get(i) + dotSize/2) {
                  modal = true;
                  openModal(screenshots.get(currentImg));
                }
              }
            } else {
              float thisX = i * stepSize + visX + stepSize/2;
              if (mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2) {
                if (type == "averages") {
                  if (mouseY >= upperBoundary && mouseY <= lowerBoundary) {
                    currentPage = "singleSession";
                    cp5.getTab("singleSession").bringToFront();
                    currentSession = sessionFolders[i];
                    cp5.getController("overall").show();
                    cp5.getController("session").setLabel("< "+ sessionFolders[i]);
                    currentItem = i;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}