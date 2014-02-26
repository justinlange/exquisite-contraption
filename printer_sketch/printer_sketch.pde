import processing.pdf.*;
import processing.serial.*;

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
boolean rubeOut = true; 

boolean debug = false;

void setup()
{
  
  size(round(print_width * make_bigger), round(print_height * make_bigger));
  
   PFont myFont = createFont(PFont.list()[2], 14);
  textFont(myFont);

  // List all the available serial ports:
  //String portName = Serial.list()[7];
  String portName = "/dev/tty.usbmodem1421";
  myPort = new Serial(this, portName, 9600);
 
  //comment next line out to turn debug mode OFF
  debug = true;

}


void draw(){
  
    background(0);
  text("Last Received: " + inByte, 10, 130);
  text("Last Sent: " + whichKey, 10, 100);
  
  if(rubeIn) savePDF();
  
   if(rubeOut) shred();
  
}

void shred(){
  myPort.write('s');
  myPort.write('\n');
  rubeOut = false;
  
}


void serialEvent(Serial myPort) {
  inByte = myPort.read();
}



void savePDF(){
  String saveString = "data/" + year() + month() + day() + hour() + minute() + second() + "_grab.pdf";  
  beginRecord(PDF, saveString); 
     
  //draw content to be printed PDF
   
   text("print me", 100,200);  
     
     
     
  endRecord();
  rubeIn = false;
  
}



void keyReleased(){
  if(debug){
  if(key == 'i'){
    rubeIn = true;
    println("rubeIn: " + rubeIn);
  }else if(key == 'o'){
   rubeOut = true; 
  }  
 }  
}
  
