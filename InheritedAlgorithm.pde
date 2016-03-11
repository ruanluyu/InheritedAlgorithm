//inherited algorithm

Inh genes;
float[] y;
int nowTime = 0;
float lastXY[];

final int numOfX = 1000;
final float minX = -2;
final float maxX = 2;

final float scaleX = PI/1000;// scale per pixel
final float scaleY = 0.010;
final float offsetX = 640;
final float offsetY = 700;
final float xLen = 1000;
final float yLen = 1000;
final int meshR = 50;
final int meshL = 50;
final int meshT = 10;
final int meshB = 10;
final float easing = 1;//smooth animation(0.001~1.0)

final float mutateRate = 0.01;
final int buffTime = 4;
final int population = 16;


void setup(){
  frameRate(30);
  size(1280,720);
  genes = new Inh(population/2,10,mutateRate,minX,maxX);
  y = new float[numOfX];
  for(int i = 0 ; i<numOfX;i++){
    y[i] = function( map(i,0,numOfX-1,minX,maxX) );
  }
  lastXY = new float[genes.getNumOfPopulation()*2];
  for(int i = 0 ; i<genes.getNumOfPopulation()*2;i++){
    lastXY[i]=0;
  }
  
  
}

void draw(){
  backGround();
  nowTime++;
  if(nowTime==buffTime||nowTime>buffTime){
  nowTime=0;
  genes.calculate();
  }
  genes.living();
  fill(0);
  noStroke();
  rect(0,0,width,120);
  textAlign(LEFT,TOP);
  textSize(15);
  fill(255);
  
  text("f(x) = x*sin(10*PI*x)+2 , x<=2 && x>=-1",10,100);
  
  text("Generation:",10,0);
  text(genes.getGeneration(),120,0);
  text("Mutation:",10,20);
  text(genes.getNumOfMutation(),120,20);
  text("Rate:",10,40);
  float rate = mutateRate*100;
  text(rate+"%",120,40);
  text("NumOfGenes:",10,60);
  text(genes.getNumOfGens(),120,60);
  text("Population:",10,80);
  text(genes.getNumOfPopulation()*2,120,80);
  
  text("A Better gene in this generation:",280,0);
  text("The best gene in all generation:",580,0);
  text("Generation:",180,20);
  text("ID:",180,40);
  text("X:",180,60);
  text("Y:",180,80);
  text(floor(genes.getBetter(0)),280,20);
  text(floor(genes.getBetter(1)),280,40);
  text(genes.getBetter(2),280,60);
  text(genes.getBetter(3),280,80);
  text(floor(genes.getBest(0)),580,20);
  text(floor(genes.getBest(1)),580,40);
  text(genes.getBest(2),580,60);
  text(genes.getBest(3),580,80);
  int numInfo = genes.getInfoSize();
  for(int i = 0 ; i<numInfo;i++){
    text(genes.getInfo(i),10,120+i*20);
  }
  
  textAlign(RIGHT,TOP);
  
  
  
  
  for(int i = 0 ;i<genes.getNumOfPopulation();i++){
    text("id"+i+":  "+genes.getGene(i),980,map(i,0,genes.getNumOfPopulation(),5,110));
  }
  for(int i = 0 ;i<genes.getNumOfPopulation();i++){
    int j = i+genes.getNumOfPopulation();
    text("id"+j+":  "+genes.getGene(j),1180,map(i,0,genes.getNumOfPopulation(),5,110));
  }
  translate(offsetX,offsetY);
  for(int i = 0 ;i<genes.getNumOfPopulation()*2;i++){
    stroke(255,120+100.0*i/genes.getNumOfPopulation()*2,0);
    strokeWeight(1);
    lastXY[i] = (lastXY[i] + (genes.getX(i)-lastXY[i])*easing);
    fill(255);
    text("ID:"+i,lastXY[i]/scaleX,-i*15-20);
    line(lastXY[i]/scaleX,0,lastXY[i]/scaleX,-function(lastXY[i])/scaleY);
  }
  stroke(0,0,255);
  strokeWeight(1.5);
  line(genes.getBetter(2)/scaleX,0,genes.getBetter(2)/scaleX,-genes.getBetter(3)/scaleY);
  stroke(255,0,0);
  strokeWeight(2);
  line(genes.getBest(2)/scaleX,0,genes.getBest(2)/scaleX,-genes.getBest(3)/scaleY);
  textAlign(LEFT,TOP);
  text("better",genes.getBetter(2)/scaleX,-50);
  text("best",genes.getBest(2)/scaleX,-100);
}



void backGround(){
  
  background(100);
  pushMatrix();
  translate(offsetX,offsetY);
  strokeWeight(1);
  stroke(255,255,255,50);
  fill(255,150);
  for(int i = -meshB ; i <meshT;i++){
    line(-xLen,i*(-10),xLen,i*(-10));
  }
  for(int i = -meshL ; i <meshR;i++){
    line(i*(-10),-yLen,i*(-10),yLen);
  }
  stroke(255,255,255,75);
  for(int i = -meshB/10 ; i <meshT/10;i++){
    line(-xLen,i*(-100),xLen,i*(-100));
  }
  for(int i = -meshL/10 ; i <meshR/10;i++){
    line(i*(-100),-yLen,i*(-100),yLen);
  }
  textAlign(RIGHT,TOP);
  textSize(15);
  for(int i = -10;i<10;i++){
    text(i*100*scaleX,-5+i*100,3);
  }
  for(int i = 1;i<10;i++){
    text(i*100*scaleY,-5,-2-i*100);
  }
  stroke(255);
  line(0,yLen,0,-yLen);
  line(-xLen,0,xLen,0);
  stroke(200,200,255);
  strokeWeight(2);
  for(int i = 0 ; i < numOfX-1;i++){
    float x1 = map(i,0,numOfX-1,minX,maxX);
    float x2 = map(i+1,0,numOfX-1,minX,maxX);
    line(x1/scaleX,-y[i]/scaleY,x2/scaleX,-y[i+1]/scaleY);
  }
  popMatrix();
  
  
}


float function(float x){
  return x*sin(10*PI*x)+2;
}