int rowsOfCameras = 4;
int camerasPerRow = 1;
ArrayList<PVector> rowLocations = new ArrayList<PVector>();
ArrayList<Integer> rowAngle = new ArrayList<Integer>();
ArrayList<PVector> objects = new ArrayList<PVector>();
ArrayList<Camera> cameras = new ArrayList<Camera>();

Arduino dumilianove;
boolean testing = true;
boolean showPositions = true;
boolean serialEnabled = false;
void setup() {
  size(512, 512);
  smooth();

  for (int i = 0; i < rowsOfCameras; ++i) {
    PVector init = new PVector(((i+1)*(width/4))-(width/8), 190);
    print(init);
    rowLocations.add(init);
  }
  if (testing) {
    PVector init = new PVector(0, 0);
    objects.add(init);
  }	
  ellipseMode(CENTER);
}

void draw() {
  background(255);
  rowAngle.clear();
  for (PVector loc : rowLocations) {
    for (PVector obj : objects) {
      //figure out shortest dx code
      rowAngle.add(round(getAngleDegrees(loc, obj)));
    }
  }
  //print(rowAngle);
  showRows();	
  showObjects();
  showRotation();

  if (testing) {
    PVector mouse = new PVector(mouseX, mouseY);
    objects.set(0, mouse);
  }
}



float getAngleDegrees(PVector loc_, PVector obj_) {
  PVector normal = new PVector(obj_.x-loc_.x,obj_.y-loc_.y);
  float rad = normal.heading();
   rad = rad+PI;
  return degrees(rad);
}

void showRows() {
  for (PVector o : rowLocations) {
    ellipse(o.x, o.y, 5, 5);
  }
}

void showRotation() {
  for (int i = 0; i < rowAngle.size(); ++i) {
    int rotation = rowAngle.get(i);
    PVector location = rowLocations.get(i);
    pushMatrix();
    translate(location.x, location.y);
    rotate(radians(rotation));
    line(-190, 0, 0, 0);

    println(location.x);
    println(location.y);

    popMatrix();
  }
}


void showObjects() {
  for (PVector o : objects) {
    ellipse(o.x, o.y, 5, 5);
  }
}




class Camera {
  int row, pin;
  int degree;
  public Camera (int row_) {
    row = row_;
    degree = 90;
  }
}

class Arduino {
  ArrayList<Camera> cameras = new ArrayList<Camera>();
  String comPort;
  Arduino(String comPort_) {
    comPort=comPort_;
  }

  void addCamera(Camera cam) {
    cameras.add(cam);
  }
  void sendCameras() {
    for (Camera cam : cameras) {
      if (testing) {
        println(cam.degree);
      }
      if (serialEnabled) {
        //do the serial stuff
      }
    }
  }
}