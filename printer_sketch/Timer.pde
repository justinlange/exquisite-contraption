class Timer{
  
  long startMillis, timerSeconds;
  boolean init;
  
  
  Timer(long _timerSeconds){ 
    timerSeconds = _timerSeconds;
    init = false;
    println("timer construct");
  }
  
  void init(){
   startMillis = millis(); 
   println("timer init, statMillis: " + startMillis);
   init = true;
   
  }
  
  boolean trigger(){
    if(!init) return false;
    long result = millis() -startMillis;
    //println("result: " + result);
    if(result > (timerSeconds * 1000)) {
      init = false;
      return true;
    }
      return false;
  }


}
