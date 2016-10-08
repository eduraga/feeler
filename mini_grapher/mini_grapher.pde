
miniGraph[] graph;
import java.util.Date;
File[] files;
int graphingValue=11;
void setup() {
  size(800, 600);
  // Path
  String path = sketchPath("charts");

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  println(filenames);
  graph=new miniGraph[filenames.length];
  println("\nListing info about all files in a directory: ");
  files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    if (!files[i].isDirectory()) {
      graph[i]=new miniGraph(loadStrings(files[i].getAbsolutePath()));
      graph[i].name=files[i].getName();
      graph[i].mypos=i;
    }
    println("Size: " + f.length());
    String lastModified = new Date(f.lastModified()).toString();
    println("Last Modified: " + lastModified);
    println("-----------------------");
  }
}
class miniGraph {
  //one buffer allows duplicate time indexes, the associative one will not.
  private String[]buffer;
  String name="unnamed";
  int mypos=0;
  private color myColor=color(random(1)*127, random(1)*127, random(1)*127);
  private HashMap<String, String>BufferAssoc=new HashMap<String, String>();
  public int displace=0;
  private boolean hasinit=false;
  miniGraph(String[]buf) {
    hasinit=true;
    println("initializing a buffer");
    buffer=new String[0];
    //copying the incoming buffer to local buffer, but removing duplicate lines
    buffer=append(buffer, buf[0]);
    for (int a=1; a<buf.length; a++) {
      //display dot graph
      if ((1.00*a/buf.length)%1==0) {
        print(".");
      }
      //check that buffer is not the same as last line & add it
      if (!buf[a].equals(buf[a-1])) {
        buffer=append(buffer, buf[a]);
        println("added  "+buf[a]+", len"+buffer.length);
        String[]bparts=splitTokens( buf[a], TAB+"\n\t");
        BufferAssoc.put(bparts[0], buf[a]);
      }
    }
    buffer=buf;
  }
  void plot(int zoom, int selectValue) {
    boolean valuePerLine=true;
    int mousePosX=-1;
    int valueUnderMouseX=-1;
    if (hasinit) {
      //int h=height/portion;
      //int top=num*height;
      int currentx=0;
      int x=0;
      int y=1;
      int[]prevCs={0, 0};
      for (int a=min(displace, buffer.length); a<buffer.length&&currentx<width; a++) {
        int tvux=-1;
        String[]lineParts;
        if (valuePerLine) {
          //absolute buffer
          lineParts=splitTokens(buffer[a], TAB+"\n\t");
        } else {
          //assoc buffer
          lineParts=new String[] {};
        }

        try {
          lineParts=splitTokens(BufferAssoc.get(""+a), TAB+"\n\t");
        }
        catch(Exception e) {
        }


        int selectedValue;
        try {
          stroke(myColor);
          selectedValue=Integer.parseInt(lineParts[selectValue]);
          if (a!=0) {
            currentx+=zoom;
            line(prevCs[x], prevCs[y], currentx, height-selectedValue);
          }
          tvux=selectedValue;
          prevCs[y]=height-selectedValue;
          prevCs[x]=currentx;
        }
        catch(ArrayIndexOutOfBoundsException e) {
          stroke(255, 0, 0);

          prevCs[y]=0;
          prevCs[x]=currentx;
        }
        catch(Exception e) {
          //println("problem with parseint");
          //print(e);
          stroke(255, 0, 0);

          prevCs[y]=0;
          prevCs[x]=currentx;
        }
        if (mousePosX==-1) {
          if (mouseX<=currentx) {
            mousePosX=a;
            valueUnderMouseX=tvux;
          }
        }
      }
    }

    fill(myColor);
    text(name+" column "+selectValue+" pointer@"+mousePosX+"="+valueUnderMouseX, 0, (mypos+1)*18);
  }
}
int zoom=1;
int hdisplace=0;
// Nothing is drawn in this program and the draw() doesn't loop because
// of the noLoop() in setup()
void draw() {
  background(250);
  stroke(9);
  for (int a=0; a<graph.length; a++) {
    graph[a].displace=hdisplace;
    graph[a].plot(zoom, graphingValue );
  }
}


public void keyPressed(KeyEvent e) {
  int keyCode = e.getKeyCode();
  switch( keyCode ) { 
  case 38:
    graphingValue+=1;
    println(graphingValue);
    break;
  case 40:
    graphingValue--;
    println(graphingValue);
    break;
  default:
    println(keyCode);
    break;
  case 39:
    hdisplace+=40;
    break;
  case 37:
    hdisplace=max(hdisplace-40, 0);
    break;
  }
  // println("k"+keyCode);
} 
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom=max(min(zoom-int(e), 10), 1);
  println(e);
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}