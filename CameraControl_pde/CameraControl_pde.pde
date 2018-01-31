import processing.serial.*;
import cc.arduino.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Arduino dumi;

int rowsOfCameras = 4;
int camerasPerRow = 1;
int whichRowToMove = 0;
ArrayList<PVector> rowLocations = new ArrayList<PVector>();
ArrayList<Integer> rowAngle = new ArrayList<Integer>();
ArrayList<PVector> objects = new ArrayList<PVector>();
ArrayList<Camera> cameras = new ArrayList<Camera>();
float[] mod = {0.8, 0.82, 0.85, 0.9, 1, 1, 0.9, 0.85, 0.82, 0.8};

PImage[] camimg = new PImage[181];
PImage[] camimg_noLight = new PImage[181];

ArduinoC dumilianove;
boolean testing = true;
boolean showPositions = true;
boolean serialEnabled = true;
boolean moving = false;
boolean isDetected = false;

void settings() {
 fullScreen();
 }

void setup() {
  //size(1280, 720);

  oscP5 = new OscP5(this, 8001);
  oscP5.plug(this, "positionFromCamera", "/size_pos");
  stroke(255);
  smooth();
  for (int i=0; i<181; i++) {
    camimg[i] = loadImage((i+1)+".png");
    camimg_noLight[i] = loadImage((i+1)+"_nolight.png");
  }

  for (int i = 0; i < rowsOfCameras; ++i) {
    PVector init = new PVector(((i+1)*(width/4))-(width/8), height-90);
    print(init);
    rowLocations.add(init);
    for (int y=0; y<camerasPerRow; y++) {
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
  dumi = new Arduino(this, Arduino.list()[1], 57600);
  dumi.pinMode(7, Arduino.SERVO);
  dumi.pinMode(6, Arduino.SERVO);
  dumi.pinMode(5, Arduino.SERVO);
  dumi.pinMode(4, Arduino.SERVO);
}

void draw() {
  background(0);

  rowAngle.clear();
  for (PVector loc : rowLocations) {
    for (PVector obj : objects) {
      //figure out shortest dx code
      rowAngle.add(round(getAngleDegrees(loc, obj)));
    }
  }
  for (int i=0; i<4; i++) {
    for (int j=0; j<10; j++) {
      pushMatrix();
      translate(((i+1)*(width/4))-(width/8)-144, ((j+1)*(height/10))-(height/10));
      pushMatrix();
      scale(0.75);
      if(isDetected){
        image(camimg[rowAngle.get(i)], 0, 0);
      } else {
        image(camimg_noLight[rowAngle.get(i)], 0, 0);
      }
      popMatrix();
      popMatrix();
    }
  }
  cameras.get(0).degree = rowAngle.get(0);
  cameras.get(1).degree = rowAngle.get(1);
  cameras.get(2).degree = rowAngle.get(2);
  cameras.get(3).degree = rowAngle.get(3);
  //print(rowAngle);
  //showRows();	
  //showObjects();
  //showRotation();
  //dumilianove.sendCameras(dumi);

  if (testing) {
    if (!moving) {
      //PVector mouse = new PVector(mouseX, mouseY);
      //objects.set(0, mouse);
    }
  }
  if (moving) {
    PVector mouse = new PVector(mouseX, mouseY);
    rowLocations.set(whichRowToMove, mouse);
    showRows();
    showRotation();
  }
}



float getAngleDegrees(PVector loc_, PVector obj_) {
  PVector normal = new PVector(obj_.x-loc_.x, obj_.y-loc_.y);
  float rad = normal.heading();
  rad = rad+PI;

  return constrain(degrees(rad), 0, 180);
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
    fill(255);
    text(rotation, -25, 10);

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
    if (serialEnabled) {
      Camera c = cameras.get(0);
      a.servoWrite(7, c.degree);
      c = cameras.get(1);
      a.servoWrite(6, c.degree);
      c = cameras.get(2);
      a.servoWrite(5, c.degree);
      c = cameras.get(3);
      a.servoWrite(4, c.degree);
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

void positionFromCamera(float x, float y, int enable) {

  if (enable == 1) {
    isDetected = true;
  } else {
    isDetected = false;
  }
  if (isDetected) {
    PVector temp = new PVector(map(x, 0, 640, width, 0), map(y, 0, 10, 0, height));
    objects.set(0, temp);
  }
}