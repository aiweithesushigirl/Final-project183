import peasy.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import com.hamoid.*;
import ddf.minim.ugens.*;



Minim minim;
AudioPlayer song;
BeatDetect beat;
ddf.minim.analysis.FFT fft;

int form;
float x = 0.01;
float y = 0;
float z = 0;

float a = 10;
float b = 28;
float c = 8.0/3.0;

float speed;

float[] real;
float[] img;
PVector offset1 = new PVector(random(-1,1),1,1);
PVector offset2;
PVector offset3;

PVector offset4 = new PVector(random(-1,1),1,1);
PVector offset5;
PVector offset6;
ArrayList<PVector> points1 = new ArrayList<PVector>();
ArrayList<PVector> points2 = new ArrayList<PVector>();


PeasyCam cam;

float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%


float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;


float scoreDecreaseRate = 25;

Phy phy1;
Phy phy2;
Phy phy3;



void setup() {
  fullScreen(P3D);
  //size(500, 400,P3D);
  colorMode(HSB);
  smooth(4);
  cam = new PeasyCam(this, 500);
  minim = new Minim(this);
  song = minim.loadFile("senorita.mp3", 128);
  song.play();
  beat = new BeatDetect();
  fft = new ddf.minim.analysis.FFT(song.bufferSize(), song.sampleRate());
  phy1 = new Phy();
  phy2 = new Phy();
  phy3 = new Phy();
}

void draw() {
  background(0);

  fft.forward(song.right);
  beat.detect(song.mix);
  real = fft.getSpectrumReal();
  img = fft.getSpectrumImaginary();
  

  float dt = 0.01;
  float dx = (a * (y - x))*dt;
  float dy = (x * (b - z) - y)*dt;
  float dz = (x * y - c * z)*dt;
  x = x + dx;
  y = y + dy;
  z = z + dz;

  points1.add(new PVector(x, y, z));
  points2.add(new PVector(x, y, z));
  


  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
  phy1.d =radians(51);
  phy2.d = radians(137.5);
  phy3.d = radians(51);
 //println (fft.specSize());
  for (int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getFreq(i);

    phy1.stepSize = int(fft.getBand(i)*5);
    phy1.freq = fft.getFreq(i)*100;
    phy1.size = int(fft.getBand(i)*5);
    //println("1: ", phy1.stepSize);
    
  }
  //phy1.Lerping();
  phy1.update(0, 0);
  
  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getFreq(i);
    phy2.stepSize = int(fft.getBand(i)*5);
    phy2.freq = fft.getFreq(i)*100;
    //println("2: ", phy2.stepSize); 
  }
  phy2.update(0, 2);
  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getFreq(i);
    phy3.stepSize = int(fft.getBand(i)*5);
    phy3.freq = fft.getFreq(i)*100;
    
    //println("3: ", phy3.stepSize);
  }
  phy3.update(2, 5);

  
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }

  PVector newvec = new PVector(scoreLow/500, scoreMid/500, scoreHi/500);
  points1.add (newvec);
  points2.add (newvec);

  float hu = 0;
  float hu1 = 0;

  translate(50, 0, -200);
  scale(3);
  stroke(255);
   

  lights();
  
  


  beginShape();
  for (PVector v : points1) {

    stroke(hu, 255, 255);
    fill(hu, 255, 255); 
  // pushMatrix();
   // vertex(v.x,v.y*2,v.z);
    //rotate(PI/360);
    //box(3);
   //popMatrix();

    
    for (int i = 0; i < fft.specSize(); ++i) {

      offset2 = PVector.random3D();
      offset1.mult(fft.getBand(i)/10);
      offset2.mult(fft.getBand(i)/10);
      //float beat2 = map(fft.getBand(i), 0, 1, -1 ,1 );
      //println(fft.getBand(i));
      
      offset3 = new PVector(fft.getBand(i)/10,fft.getBand(i)/20, 1);
      if (beat.isOnset()){
        offset3.mult(fft.getBand(i)/10);
      }
      
    }

    //v.add(offset1);
    v.add(offset2);
    v.add(offset3);


    hu += 0.2;
    if (hu > 255) {
      hu = 0;
    }
  }

  endShape();
}