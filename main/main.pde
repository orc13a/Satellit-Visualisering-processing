float angle;

Table table;
float r = 200;

PImage earth;
PShape globe;
PShape ISS;

JSONObject jsonObj;
JSONArray posJson;

JSONObject pos1;
JSONObject pos2;

float sat1Lon;
float sat1Lat;
float sat2Lon;
float sat2Lat;
boolean start = true;

float ISSh;

PVector yAxis = new PVector(0, 1, 0);
PVector zAxis = new PVector(0, 0, 1);
PVector xAxis = new PVector(1, 0, 0);

float rotation = 0;

void setup() {
  size(800, 800, P3D);
  earth = loadImage("earth.jpg");

  jsonObj = loadJSONObject("https://api.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=JFPDQB-NHQTSB-7PL9S7-4SQ6");
  posJson = jsonObj.getJSONArray("positions");

  pos1 = posJson.getJSONObject(0);
  pos2 = posJson.getJSONObject(1);

  sat1Lon = pos1.getFloat("satlongitude");
  sat1Lat = pos1.getFloat("satlatitude");

  sat2Lon = pos2.getFloat("satlongitude");
  sat2Lat = pos2.getFloat("satlatitude");
  
  ISSh = pos1.getFloat("sataltitude");
  
  //println(sat1Lon, sat1Lat);
  //println(sat2Lon, sat2Lat);

//  146.5367 -45.49287
//146.61328 -45.46258

  smooth();

  noStroke();
  ISS = createShape(SPHERE, 5);

  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
}

void draw() {
  background(51);
  
  pushMatrix();
    translate(width*0.5, height*0.5);
    rotateY(angle);
    angle += 0.002;
    
    ambientLight(255, 255, 255);
    fill(200);
    noStroke();
    shape(globe);
  popMatrix();

  // fix: no + PI/2 needed, since latitude is between -180 and 180 deg
  float theta = radians(sat1Lat);

  float phi = radians(sat1Lon) + PI;

  // original version
  // float x = r * sin(theta) * cos(phi);
  // float y = -r * sin(theta) * sin(phi);
  // float z = r * cos(theta);

  // fix: in OpenGL, y & z axes are flipped from math notation of spherical coordinates
  float x = r * cos(theta) * cos(phi);
  float y = -r * sin(theta);
  float z = -r * cos(theta) * sin(phi);

  PVector pos = new PVector(x, y, z);

  //lights();
  
  rotation += 0.008;

  //latt
  pushMatrix();
    translate(width*0.5, height*0.5);
    
    //translate(pos.x + ISSh / 10, pos.y + ISSh / 10, pos.z + ISSh / 10);
    //rotate(angle, yAxis.x, yAxis.y, yAxis.z);
    //rotate(rotation, yAxis.x, yAxis.y, yAxis.z);
    //rotate(rotation, xAxis.x, xAxis.y, xAxis.z);
    //if (start) {
      rotateZ(PI/4);
      
      //start = false;
    //} else {
      rotateY(rotation);
    //}
    
    translate(pos.x , pos.y  , pos.z);
    //rotateZ(PI/4);
    //rotateY(rotation);
    fill(255);
    shape(ISS);
    
  popMatrix();
  
  //translate(pos.x + ISSh / 10, pos.y + ISSh / 10, pos.z + ISSh / 10);
  //fill(255);
  //shape(ISS);
}
