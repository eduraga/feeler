
class FileNameManager {
  String path=sketchPath();
  File file=new File(path);
  FileNameManager() {
  }
  FileNameManager(String path) {
    path=sketchPath();
    updatePath();
  }
  private String slashPath(String in) {
    in.replace("\\", "/");
    if (in.charAt(in.length()-1)=='/') {
      return in;
    } else {
      return in+"/";
    }
  }
  boolean cd(String p) {
    path=slashPath(path)+p;
    return updatePath();
  }
  boolean setToSketchPath() {
    path=sketchPath();
    return updatePath();
  }
  boolean setBasePath(String p) {
    path=p;
    return updatePath();
  }
  boolean updatePath() {
    println("path points to"+file);
    file=new File(path);
    return  file.exists();
  }
  String getString() {
    return path;
  }
  File getFile() {
    return file;
  }
}