// An object that wraps the PShape

class Shard {
  
  // The PShape to be "wiggled"
  PShape s;
  // Its location
  float x, y;
  
  // For 2D Perlin noise
  float yoff = 0;
  
  // We are using an ArrayList to keep a duplicate copy
  // of vertices original locations.
  ArrayList<PVector> original;



  Shard(float centerX, float centerY) {
    x = centerX;
    y = centerY; 

    // The "original" locations of the vertices make up a circle
    original = new ArrayList<PVector>();
    for (float a = 0; a < TWO_PI; a+=0.2) {
      PVector v = PVector.fromAngle(a);
      v.mult(100);
      original.add(v);
    }
    
    // Now make the PShape with those vertices
    s = createShape();
    s.beginShape();
    s.fill(127);
    s.stroke(0);
    s.strokeWeight(2);
    for (PVector v : original) {
      s.vertex(v.x, v.y);
    }
    s.endShape(CLOSE);
  }

 
void display() {
    pushMatrix();
    translate(x, y);
    shape(s);
    popMatrix();
  }
}

