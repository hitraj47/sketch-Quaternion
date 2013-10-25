// started with http://www.andrew.cmu.edu/course/60-257/reference/libraries/opengl/index.html

import processing.opengl.*;
import toxi.geom.Quaternion;  // using toxiclibs for Quaternion functions

private final color MAGENTA = color(255,0,255);
private final color YELLOW = color(255,255,0);
private final color BLACK = color(0);
private final color LTGRAY = color(225);
private final color RED = color(255,0,0);
private final color GREEN = color(0,255,0);
private final color BLUE = color(0,0,255);

float a = radians(25);
PVector origin;
PVector point, point2, point3, point4;
PVector axis;
PVector xsect, xsect2, xsect3, xsect4;
float qangle; // increment this amt on each draw, in degrees

void setup() {
  size(800, 600, OPENGL);
  fill(0, 153);
  noStroke();
   origin = new PVector(0, 0, 0);
   point = new PVector(150, 150, 50);
   point2 = new PVector(100, 100, 25);
   point3 = new PVector(200, 200, 60);
   point4 = new PVector(150,150,50);
   axis = new PVector(100, 300, 200);
   xsect = nearestPoint(origin, axis, point);
   xsect2 = nearestPoint(origin, axis, point2);
   xsect3 = nearestPoint(origin, axis, point3);
   xsect4 = nearestPoint(origin, axis, point4);
   qangle = 2.0; // increment
}
    
void draw() {
  background(255);
  translate(width/2, height/2);
  
  // modify viewing perspective
  rotateX(a);
  rotateY(a*2);
  stroke(BLACK);
  //rect(-200, -200, 400, 400);
  
  stroke(190);
  noFill();
  rotateX(PI/2); 
  
  strokeWeight(1);
  stroke(RED); // x axis
  line(0,0,0,100,0,0);
  stroke(GREEN); // y axis
  line(0,0,0,0,100,0);
  stroke(BLUE); // z axis
  line(0,0,0,0,0,100);
  
  stroke(BLACK);
  //rect(-200, -200, 400, 400);
  
  stroke(YELLOW); // the axis of rotation
  line(origin.x, origin.y, origin.z, axis.x, axis.y, axis.z);
  
  strokeWeight(5);
  PVector axisn = axis.get();
  PVector pointn = point.get();
  PVector pointn2 = point2.get();
  PVector pointn3 = point3.get();
  PVector pointn4 = point4.get();
  
  axisn.normalize();
  pointn.normalize();
  pointn2.normalize();
  pointn3.normalize();
  pointn4.normalize();
  float mag = point.mag();
  float mag2 = point2.mag();
  float mag3 = point3.mag();
  float mag4 = point4.mag();
  point = rotate(pointn, axisn, radians(qangle-PI/2)); // Q rotation
  point2 = rotate(pointn2, axisn, radians(-qangle)); // Q rotation
  point3 = rotate(pointn3, axisn, radians(qangle*5)); // Q rotation
  point4 = rotate(pointn4, axisn, radians(qangle-PI/2) );
  point.setMag(mag);
  point2.setMag(mag2);
  point3.setMag(mag3);
  point4.setMag(mag4);
  showPoint(origin, MAGENTA);
  showPoint(axis, MAGENTA);
  showPoint(point, BLACK);
  showPoint(point2, BLACK);
  showPoint(point3, BLACK);
  showPoint(point4, MAGENTA);
  stroke(127,127,127);
  strokeWeight(1);
  line(xsect.x, xsect.y, xsect.z, point.x, point.y, point.z);
  line(xsect2.x, xsect2.y, xsect2.z, point2.x, point2.y, point2.z);
  line(xsect3.x, xsect3.y, xsect3.z, point3.x, point3.y, point3.z);
  line(xsect4.x, xsect4.y, xsect4.z, point4.x, point4.y, point4.z);
  //a += 0.01;
}

PVector nearestPoint(PVector p1, PVector p2, PVector q) {
  // from http://en.wikipedia.org/wiki/Vector_projection
  // a1  = (a dot b) * b 
  // a1 is shortened vector ending at the intersection point, along the orig direction vector
  // b is the unit vector for the original vector
  // a is the vector from the end of a1 to the q point in space
  PVector b = PVector.sub(p2, p1);
  b.normalize();
  PVector a = PVector.sub(q, p1);
  PVector a1 = PVector.mult(b, PVector.dot(a,b));
  return PVector.add(a1,p1);
}

void showPoint(PVector p, color col) {
  stroke(col); // magenta
  point(p.x, p.y, p.z);
}

//Example of rotating PVector about a directional PVector
PVector rotate(PVector v, PVector r, float a) {
  Quaternion Q1 = new Quaternion(0, v.x, v.y, v.z);
  Quaternion Q2 = new Quaternion(cos(a / 2), r.x * sin(a / 2), r.y * sin(a / 2), r.z * sin(a / 2));
  Quaternion Q3 = Q2.multiply(Q1).multiply(Q2.getConjugate());
  return new PVector(Q3.x, Q3.y, Q3.z);
}


