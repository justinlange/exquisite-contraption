// timer stuff
long startMillis, timerSeconds;
boolean initTimer;
boolean doStuff;
boolean buttonState;

boolean debug;
boolean arduinoTimer;


int shredPin = 5;
int buttonPin = 52;

void setup()
{
  debug = false;
  arduinoTimer = false;

  Serial.begin(9600);
  pinMode(shredPin, OUTPUT);
  pinMode(buttonPin, INPUT);
  initTimer = false;
  doStuff = false;


}

void loop()
{
  buttonState = digitalRead(buttonPin);
  if(debug) Serial.println(buttonState);

  if(buttonState){ 
    Serial.write('i');
    //doStuff = true;
    //Serial.println("buttonState is high!");
  }
  if(trigger() == true) doStuff = false;

  delay(5);

  if (Serial.available())
  {
    int inByte = Serial.read(); 

    switch (inByte) {
    case 's':     // red
      doStuff = true; 
      if(debug){
        Serial.print("doStuff state is: ");
        Serial.print(doStuff);
      }
      break;
    case 't':    // green
      doStuff = false; 
      if(debug){
        Serial.print("doStuff state is: ");
        Serial.print(doStuff);
      }
      break;
    case 'r':
      initTimer = false;
      break;
    }
  } 
  Serial.flush(); 


  if(doStuff){
    digitalWrite(shredPin, LOW);
    
    if(arduinoTimer){
      if(!initTimer) startTimer(5);
      initTimer = true;
    }
    //Serial.println("shredding");
  }
  else{
    digitalWrite(shredPin, HIGH);
    //Serial.println("nope...");

  }



}

void startTimer(long _timerSeconds){
  timerSeconds = _timerSeconds;
  startMillis = millis(); 
  if(debug){
    Serial.print("timer init, statMillis: ");
    Serial.println(startMillis);
  }
}


boolean trigger(){
  if(!initTimer) return false;
  long result = millis() -startMillis;
  if(result > (timerSeconds * 1000)){
    initTimer = false;
    return true;
  }
  return false;
}







