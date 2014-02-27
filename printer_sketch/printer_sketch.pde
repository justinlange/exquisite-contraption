import processing.pdf.*;
import processing.serial.*;

int delayLength = 15;

Serial myPort;      // The serial port
int whichKey = -1;  // Variable to hold keystoke values
int inByte = -1;    // Incoming serial data

//Set these variables to the print size you want (in inches)
float print_width = 8.5;
float print_height = 11;
float make_bigger = 40;

//state to control creating a PDF, which is then printed by an automator script monitoring /data 
boolean rubeIn = false;

//state to control the arduino writing HIGH to the relay, which turns on the shredder
boolean rubeOut = false; 

boolean keyInput = false;
boolean consoleWrite = false;



Timer shredderTimer;
Timer turnOff;

String heading[];

String device[] = loadStrings("/Users/justin/code/flux-factory/printer_sketch/strings/device.txt");
String action[];
String track[];
String crushing[];
String object[];
String result[];



void setup()
{
  
  println("there are " + device.length + " lines");
for (int i = 0 ; i < device.length; i++) {
  println(device[i]);
}

  size(round(print_width * make_bigger), round(print_height * make_bigger));

  PFont myFont = createFont(PFont.list()[2], 14);
  textFont(myFont);

  // List all the available serial ports:
  String portName = Serial.list()[0];
  //String portName = "/dev/tty.usbmodem1421";
  myPort = new Serial(this, portName, 9600);

  //comment next line out to turn keyboard input mode OFF
  keyInput = true;

  shredderTimer = new Timer(17);
  turnOff = new Timer(5);
}


void draw() {

  background(0);
  text("rubeIn state: " + rubeIn, 10, 130);
  text("rubeOut state: " + rubeOut, 10, 100);

  if (rubeIn) {
    savePDF();
    shredderTimer.init();
  }

  if (shredderTimer.trigger()) {
    rubeOut = true;
  }

  if (rubeOut) {
    println("shredding");
    myPort.write('s');
    rubeOut = false;    
    turnOff.init();
  }

  if (turnOff.trigger()) {
      println("stop shredding");
      myPort.write('t');
  }
}



void serialEvent(Serial myPort) {
  inByte = myPort.read();
  println(inByte);
  if (inByte == 105) {
    rubeIn = true;
    myPort.clear();
  }
}

void savePDF() {
  pushStyle();
  String saveString = "data/" + year() + month() + day() + hour() + minute() + second() + "_grab.pdf";  
  beginRecord(PDF, saveString); 

  //draw content to be printed PDF

  text("print me", 100, 200);  

  background(255);
  fill(0);
  rect(100, 100, 10, 10);

  endRecord();
  rubeIn = false;
  popStyle();
}



void keyReleased() {
  if (keyInput) {
    if (key == 'i') {
      rubeIn = true;
      println("rubeIn: " + rubeIn);
    }
    else if (key == 's') {
      rubeOut = true;
    }
    else if (key == 't') {
      myPort.write('t');
    }
  }
}

