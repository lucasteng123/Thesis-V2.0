int rowsOfCameras = 4;
PVector rowLocations[];
int rowAngle[];
PVector objects[];

boolean testing = true;
void setup() {
	
}

void draw() {
	
}


class Camera {
	int row,pin;
	int degree;
	public Camera (int row_) {
		row = row_;
		degree = 90;
	}
}

class Arduino {
	ArrayList<Camera> cameras = new ArrayList<Camera>();
	String comPort;
	Arduino(String comPort_){
		comPort=comPort_;
	}

	void addCamera(Camera cam){
		cameras.add(cam);
	}
	void sendCameras(){
		for (Camera cam : cameras) {
			if(testing){
				println(cam.degree);
			}
			if(serialEnabled){
				//do the serial stuff
			}
		}
	}

}