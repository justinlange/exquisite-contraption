// timer stuff
long startMillis, timerSeconds;
boolean initTimer;



int shredPin = 5;

void setup()
{
  Serial.begin(9600);
  pinMode(shredPin, OUTPUT);

}

void loop()
{

  boolean doStuff = false;
  boolean initTimer = false;


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
    case 'r':
      initTimer = false;
      break;
    }

    delay(5);

    if(doStuff){
      digitalWrite(shredPin, LOW);
      startTimer(15);
      //Serial.println("shredding");
    }
    else{
      digitalWrite(shredPin, HIGH);
      //Serial.println("nope...");
    } 
    Serial.flush(); 
  }
  
  if(trigger()) doStuff = false;

}

void startTimer(long _timerSeconds){
  timerSeconds = _timerSeconds;
  startMillis = millis(); 
  initTimer = true; 
  Serial.println("timer init, statMillis: " + startMillis);
}


boolean trigger(){
  if(!initTimer) return false;
  long result = millis() -startMillis;
  if(result > (timerSeconds * 1000)){
    return true;
  }
  return false;
}



