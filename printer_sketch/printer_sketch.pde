
import processing.pdf.*;
import processing.serial.*;


int delayLength = 15;

Serial myPort;      // The serial port
int whichKey = -1;  // Variable to hold keystoke values
int inByte = -1;    // Incoming serial data

//Set these variables to the print size you want (in inches)
float print_width = 8.5;
float print_height = 11;
float make_bigger = 70;

//state to control creating a PDF, which is then printed by an automator script monitoring /data 
boolean rubeIn = false;

//state to control the arduino writing HIGH to the relay, which turns on the shredder
boolean rubeOut = false; 

boolean keyInput = false;
boolean consoleWrite = false;


Timer shredderTimer;
Timer turnOff;


ArrayList<String[]> madlibs;

String[] index = 
{
  "a", "device", "that", "action", "track", "comma", "crushing", "object", "to", "result"
};
//MBPr
//String directory = "/Users/justin/code/flux-factory/printer_sketch/strings/";

//mbp 17" directory
String directory = "/Users/Justin/flux-factory/exquisite-contraption/printer_sketch/strings/";


String outputString = " ";

//A @device that @actionPartA @track @destructiveAction @object to @finalAction



void setup()
{
  madlibs = new ArrayList<String[]>();

  //load each text file into its own String[] that lives in the ArrayList madlibs
  for (int i=0;i<index.length;i++) {
    String nameString = directory + index[i] + ".txt";
    String[] tString = loadStrings(nameString);
    madlibs.add(tString);
  }
  //for debugging only -- just to make sure we can access this text
  for (int i =0; i< madlibs.size(); i++) {
    String[] tString = madlibs.get(i);   
    for (int j=0;j<tString.length; j++) {
    }
  }     

  String[] tStringArray = new String[madlibs.size()];
  //now, let's set up a random quote
  for (int i =0; i< madlibs.size(); i++) {
    String[] tString = madlibs.get(i);
    int arraySize = tString.length;
    float randomFloat = random(0, arraySize);
    int randomIndex = floor(randomFloat);
    tStringArray[i] = new String(tString[randomIndex]);
  }

  for (int i=0;i<tStringArray.length; i++) {
    outputString = outputString + (tStringArray[i]);
  }
  println(outputString);






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
  drawText();
}

void drawText(){
    text(outputString,width*.2,height*.2,width - (width*.2),height);
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
  background(255);
  fill(0);

  
  drawText();

/*
  String[] splitString = outputString.split("\\b", 8);

  for (int i=0;i<splitString.length; i++) {
    text(splitString[i], 100, 100 + i*40);  
  }

 // text(outputString.substring(0, lineLength*i), 100, 200);
*/

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

