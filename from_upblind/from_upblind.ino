/*
    Adafruit Arduino - Lesson 16. Stepper
 */


int shredPin = 5;

void setup()
{
  Serial.begin(9600);
  pinMode(shredPin, OUTPUT);

}

void loop()
{

  boolean doStuff = false;


  if (Serial.available())
  {
    int inByte = Serial.read(); 

    switch (inByte) {
    case 's':     // red
      doStuff = true; 
      break;
    case 't':    // green
      doStuff = false; 
      break;
    }
    
    delay(5);

    if(doStuff){
      digitalWrite(shredPin, LOW);
      //Serial.println("shredding");
    }else{
      digitalWrite(shredPin, HIGH);
      //Serial.println("nope...");
    } 
  Serial.flush(); 
  }

}


