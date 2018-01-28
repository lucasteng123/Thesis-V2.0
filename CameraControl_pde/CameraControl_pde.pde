int rowsOfCameras = 4;
int camerasPerRow = 1;
ArrayList<PVector> rowLocations = new ArrayList<PVector>;
ArrayList<int> rowAngle = new ArrayList<PVector>;
ArrayList<PVector> objects = new ArrayList<PVector>;
ArrayList<Camera> cameras = new ArrayList<Camera>;

Arduino dumilianove;

boolean testing = true;
void setup() {
	PVector init = new PVector(0,0);
	for (int i = 0; i < rowsOfCameras; ++i) {
		rowLocations.add(init);
		rowAngle.add(90);
		for (int i = 0; i < camerasPerRow; ++i) {
			cameras.add(new Camera());
		}

	}
	for (Camera c : cameras) {
		dumilianove.addCamera(c);
	}
	objects.add(init);
	
}

void draw() {
	
	dumilianove.sendCameras();
	objects.
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