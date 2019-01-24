//timer para mover as coisas
class Timer {
  int duration = 600;
  int time = 0;
  
  void reset(int d) {
    setTime();
    duration = d;
  }
  
  void setTime() {
    time = millis();
  }
  
  int getTime() {
    return millis() - time;
  }
  
  boolean updateStep(){
    if(getTime() >= duration){
      setTime();
      return true;
    } else {
      return false;
    }
  }
  
}
