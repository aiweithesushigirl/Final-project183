class Phy{
  PVector phyPos;
  int n = 0;
  int nStart = 0;;
  float scale;
  float degree;
  float d;
  float z;
  float size;
  PImage img;
  
  //location
  float xPos;
  float yPos;
  
  //iterations
  float stepSize;
  int curIter;
  int maxIter;
  
  boolean invert;
  
  
  //lerping
  boolean useLerping;
  boolean isLerping;
  PVector startPos;
  PVector endPos;
  
  //audio
  float freq;

  Phy(){
   // d = radians(51);
    //n = 0;
    nStart = 0;
    z = 0;
    stepSize = 1;
    scale = 3;
    n = nStart;
    size = 4;
    maxIter = int(freq*100000000);
    //img = loadImage("texture.png");

    //c = 4;
  }
  

  PVector calcPhy(float scale, int n, float d){

    float a = n * d;
    float r = scale * sqrt(n);
    float x = r * cos(a);
    float y = r * sin(a);
    float z = scale*10;
    PVector vec = new PVector(x, y, z);
    return vec;
}



  
  void update(int form, float threshold){

    int start = 0;
    float windowSize = stepSize*10;
    if (n >= windowSize) {
      start = n - int(windowSize);
      
    }
    if (n >= 3000){
      invert = true;
    }
    if (n <= 100){
      invert = false;
    }
    if (invert){
    beginShape();
    for (int i = maxIter; i > start; i--){
      startPos = calcPhy(scale, start, degree);
      phyPos = calcPhy(scale, i, degree);
      if (form == 0){
        if (stepSize > threshold){
        ellipse(phyPos.x, phyPos.y, 4, 4);
        }
      }
      else if (form == 1){
        if (stepSize > threshold){
         ellipse(phyPos.x, phyPos.y, 10, 10);
        }
      }
      
      else if (form == 2){
        if (stepSize > threshold){
          rect(phyPos.x, phyPos.y, size, size);
        }
      }
      
      size++;
      if (size > 10){
        size = 4;
      }
  }
    endShape(CLOSE);
    n -= stepSize;
    curIter--;
  }
    
    else{
    beginShape();
    for (int i = start ; i < n; i++){
      startPos = calcPhy(scale, start);
      phyPos = calcPhy(scale, i);
      if (form == 0){
        if (stepSize > threshold){
        ellipse(phyPos.x, phyPos.y, size, size);
        }
      }
      else if (form == 1){
        if (stepSize > threshold){
         ellipse(phyPos.x, phyPos.y, 10, 10);
        }
      }
      
      else if (form == 2){
        if (stepSize > threshold){
          rect(phyPos.x, phyPos.y, size, size);
        }
      }
      
      size++;
      if (size > 10){
        size = 4;
      }
    }
    endShape(CLOSE);

    n += stepSize;
    curIter++;
   }
  }



}