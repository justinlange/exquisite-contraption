

// This example code is in the public domain.

import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port

void setup() {
  size(640,480);

  println(Serial.list());


  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);

 
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');

}

void draw() {
 
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup():

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
    myString = trim(myString);
 
    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(myString, ','));

    // print out the values you got:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
    }
    // add a linefeed after all the sensor values are printed:
    println();

   
    // send a byte to ask for more data:
  }
  
  void keyReleased(){
       myPort.write(key);
  }


