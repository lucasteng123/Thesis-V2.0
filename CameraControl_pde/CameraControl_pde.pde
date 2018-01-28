import processing.serial.*;
import cc.arduino.*;

Arduino dumi;

int rowsOfCameras = 4;
int camerasPerRow = 1;
int whichRowToMove = 0;
ArrayList<PVector> rowLocations = new ArrayList<PVector>();
ArrayList<Integer> rowAngle = new ArrayList<Integer>();
ArrayList<PVector> objects = new ArrayList<PVector>();
ArrayList<Camera> cameras = new ArrayList<Camera>();

ArduinoC dumilianove;
boolean testing = true;
boolean showPositions = true;
boolean serialEnabled = true;
boolean moving = false;
void setup() {
  size(512, 512);
  smooth();

  for (int i = 0; i < rowsOfCameras; ++i) {
    PVector init = new PVector(((i+1)*(width/4))-(width/8), 190);
    print(init);
    rowLocations.add(init);
    for(int y=0; y<camerasPerRow; y++){
       cameras.add(new Camera(i)); 
    }
  }
  
  if (testing) {
    PVector init = new PVector(0, 0);
    objects.add(init);
  }	
  dumilianove = new ArduinoC();
  for (Camera c : cameras) {
  	dumilianove.addCamera(c);
  }
  
  ellipseMode(CENTER);
  dumi = new Arduino(this,Arduino.list()[1],57600);
  dumi.pinMode(7,Arduino.SERVO);
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
  cameras.get(0).degree = rowAngle.get(0);
  //print(rowAngle);
  showRows();	
  showObjects();
  showRotation();
  dumilianove.sendCameras(dumi);

  if (testing) {
    if (!moving) {
      PVector mouse = new PVector(mouseX, mouseY);
      objects.set(0, mouse);
    }
  }
  if (moving) {
    PVector mouse = new PVector(mouseX, mouseY);
    rowLocations.set(whichRowToMove, mouse);
  }
}



float getAngleDegrees(PVector loc_, PVector obj_) {
  PVector normal = new PVector(obj_.x-loc_.x, obj_.y-loc_.y);
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
    //textSize(32);
    
    pushMatrix();
    translate(location.x, location.y);
    
    rotate(radians(rotation));
    line(-190, 0, 0, 0);
    fill(0);
    text(rotation,-25,10);

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

class ArduinoC {
  ArrayList<Camera> cameras = new ArrayList<Camera>();

  ArduinoC() { 
  }

  void addCamera(Camera cam) {
    cameras.add(cam);
  }
  void sendCameras(Arduino a) {
    if(serialEnabled){
      Camera c = cameras.get(0);
      a.servoWrite(7, c.degree);
    }
    for (Camera cam : cameras) {
      if (testing) {
        println(cam.degree);
      }
      if (serialEnabled) {
        //a.servoWrite(7,
      }
    }
  }
}

void keyPressed() {
  if (key=='0') {
    moving = true;
    whichRowToMove = 0;
  }
  if (key=='1') {
    moving = true;
    whichRowToMove = 1;
  }
  if (key=='2') {
    moving = true;
    whichRowToMove = 2;
  }
  if (key=='3') {
    moving = true;
    whichRowToMove = 3;
  }
}
void mousePressed() {
  if (moving) {
    moving=false;
  }
}