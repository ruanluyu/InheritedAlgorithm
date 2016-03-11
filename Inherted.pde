class Inh{
  
  private int numOfPopulation;
  private int numOfGens;
  private int maxInfoNum = 10;
  private float rateOfMutation;
  private float mapMin;
  private float mapMax;
  private float best[] = new float[5];
  private float better[] = new float[5];
  private StringList info;
  
  int generation = 0;
  int numOfMutation = 0;
  int newInfoNum = 0;
  
  /////////////////////////////
  //WARNING!!!!!NUCLEAR!!!!!!//
    private boolean[][] gene;
    private boolean[][] lastGene;
  //WARNING!!!!!NUCLEAR!!!!!!//
  /////////////////////////////
  
  Inh(int numOfPopulation,int numOfGens,float rateOfMutation,float mapMin,float mapMax){
    if(numOfGens<=12 && numOfGens>=1){
    this.numOfPopulation = numOfPopulation;
    this.numOfGens = numOfGens;
    this.rateOfMutation = rateOfMutation;
    this.mapMin = mapMin;
    this.mapMax = mapMax;
    gene = new boolean[numOfPopulation][numOfGens];
    lastGene = new boolean[numOfPopulation][numOfGens];
    info = new StringList();
    for(int i = 0 ; i < numOfPopulation;i++){
      gene[i] = numToGene(round(random(-0.4,pow2(numOfGens)-0.6)));
    }
    for(int i = 0 ; i < numOfPopulation;i++){
      lastGene[i] = numToGene(round(random(-0.4,pow2(numOfGens)-0.6)));
    }
    }else{
      println("Sorry ,failed in building gens\n-the number of gen must be a number between 1 and 12");
    }
  }
  
  void calculate(){
    choose(numOfPopulation);
    backCopyGene();
    multiply();
  }
  
  void living(){
    mutate();
    better();
  }
  
  private void choose(int num){//will be saved in lastGen
    
    boolean[] flag = new boolean[numOfPopulation*2];
    for(int i = 0 ; i < numOfPopulation*2;i++){
      flag[i] = false;
    }
    
    for(int j = 0 ; j < num ; j++){
    float[] rate = new float[numOfPopulation*2];
    float all=0;
    for(int i = 0 ; i < numOfPopulation*2;i++){
      if(flag[i] == false){
        all+=getLiveMark(i);
      }
    }
    for(int i = 0 ; i < numOfPopulation*2;i++){
      if(flag[i] == false){
        rate[i] = getLiveMark(i)/all;
      }
    }
    float ran = random(1);
    float basic = 0;
    float lastBasic = 0;
    
    for(int i = 0 ; i < numOfPopulation*2;i++){
      if(flag[i] == false){
        basic += rate[i];
        if(ran>=lastBasic&&ran<basic){
          flag[i] = true;
          break;
        }
        lastBasic = basic;
      }
    }
    }
    String out = "";
    for(int i = 0 ; i < numOfPopulation*2;i++){
      if(flag[i] == false){
        out += "G"+generation+"ID"+i+"  ";
      }
    }
    addInfo(out+" died.");
      removeInfo();
    boolean curGene[][] = new boolean[num][numOfGens];
    int curNum = 0;
    for(int i = 0 ; i < numOfPopulation*2 ;i++){
      if(flag[i]){
        for(int j = 0;j < numOfGens;j++){
          if(i<numOfPopulation){
            curGene[curNum][j] = gene[i][j];
          }else{
            curGene[curNum][j] = lastGene[i-numOfPopulation][j];
          }
        }
        curNum++;
      }
    }
    for(int i = 0 ; i < curNum ;i++){
      for(int j = 0;j< numOfGens;j++){
        lastGene[i][j] = curGene[i][j];
      }
    }
  }
  
  private void mutate(){
    //int milliData = millis()%1000;
    //String timeData = "   ("+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+milliData+")";
    for(int i = 0; i < numOfPopulation;i++){
      if(random(1)<rateOfMutation){
        int index = getRandomIndex()-1; 
        if(gene[i][index]){
          gene[i][index] = false; 
        }else{
          gene[i][index] = true;
        }
        numOfMutation++;
        addInfo("The No_"+numOfMutation+" mutation occured on G"+generation+"ID"+i);
      }
    }
    for(int i = 0; i < numOfPopulation;i++){
      if(random(1)<rateOfMutation){
        int index = getRandomIndex()-1; 
        if(lastGene[i][index]){
          lastGene[i][index] = false; 
        }else{
          lastGene[i][index] = true;
        }
        numOfMutation++;
        int id = i+numOfPopulation;
        addInfo("The No_"+numOfMutation+" mutation occured on G"+generation+"ID"+id);
      }
    }
    removeInfo();
  }
  
  private void multiply(){
    int[] seq = getRandomSeq();
    for(int i = 0 ; i < numOfPopulation ; i++){
      int index = getRandomIndex()-1;
      for(int j = index ; j < numOfGens;j++){
        boolean cur = lastGene[seq[i]][numOfGens-j-1];
        lastGene[seq[i]][numOfGens-j-1] = gene[i][numOfGens-j-1];
        gene[i][numOfGens-j-1] = cur;
      }
    }
    generation++;
    addInfo("The generation No_"+generation+" generated");
    removeInfo();
  }
  
  
  
  private void resetGene(){
    for(int i = 0 ; i < numOfPopulation;i++){
      for(int j = 0 ; j < numOfGens ; j++){
        lastGene[i][j] = false; 
        gene[i][j] = false;
      }
    }
  }
  
  private void copyGene(){
    for(int i = 0 ; i < numOfPopulation;i++){
      for(int j = 0 ; j < numOfGens ; j++){
        lastGene[i][j] = gene[i][j];
      }
    }
  }
  
  private void backCopyGene(){
    for(int i = 0 ; i < numOfPopulation;i++){
      for(int j = 0 ; j < numOfGens ; j++){
        gene[i][j] = lastGene[i][j];
      }
    }
  }
  
  private void addInfo(String in){
    info.append(in);
    newInfoNum++;
  }
  
  private void removeInfo(){
    if(info.size()>maxInfoNum){
      //int rmNum = max(min(maxInfoNum,newInfoNum),info.size()-newInfoNum-maxInfoNum);
      for(int i = 0 ;i<newInfoNum;i++){
        info.remove(0);
      }
        
    }
    newInfoNum = 0;
  }
  
  private int getRandomIndex(){
    return round(random(0.5,numOfGens+0.4));
  }
  
  private int[] getRandomSeq(){
    int num = numOfPopulation;
    int[] out = new int[num];
    boolean[] flag = new boolean[num];
    for(int i = 0;i<num;i++){
       flag[i] = false;
       out[i]=0;
    }
    
    for(int i = 0 ; i<num;i++){
      float ran = round(random(-0.4,num-i-0.6));
      for(int j = 0; j<num;j++){
        if(flag[j]==false){
          if(ran>0){
            ran--;
          }else{
            flag[j] = true;
            out[j] = i;
            break;
          }
        }
      }
    }
    return out;
  }
  
  private int pow2(int num){
    int n = 1 ; 
    for(int i = 0 ; i<num;i++){
      n *=2; 
    }
    return n;
  }
  
  
  
  
  ////////////////////////////////
  //Nuclear Rules!!!!/////////////
  private float getLiveMark(int p){
    return (function(convert(p))+1)*(function(convert(p))+1);
  }
  
  private float function(float x){
    return x*sin(10*PI*x)+2;
  }
  ////////////////////////////////
  
  private float convert(int p){
    int num = 0;
    if(p<numOfPopulation){
    for(int i = 0 ; i < numOfGens;i++){
      num+=convertB(gene[p][i])*pow2(i);
    }
    }else{
    p-=numOfPopulation;
    for(int i = 0 ; i < numOfGens;i++){
      num+=convertB(lastGene[p][i])*pow2(i);
    }
    }
    return map(num,0,pow2(numOfGens)-1,mapMin,mapMax);
  }
  
  private int convertB(boolean b){
    return b?1:0;
  }
  
  private void better(){
    float max = 0;
    float x = 0;
    int id = 0;
    for(int i = 0 ; i < numOfPopulation*2;i++){
      if(getLiveMark(i)>max){
        max = getLiveMark(i);
        id = i;
      }
    }
    better[0] = generation;
    better[1] = id;
    better[2] = convert(id);
    better[3] = function(better[2]);
    better[4] = max;
    if(better[4] > best[4]){
      for(int i = 0 ; i < 5;i++){
        best[i] = better[i];
      }
    }
  }
  
  private boolean[] numToGene(int num){
    boolean[] out = new boolean[numOfGens];
    for(int i = 0;i<numOfGens;i++){
      out[i] = false;
    }
    for(int i = numOfGens-1;i>=0;i--){
      if((num<pow2(i+1))&&(num>=pow2(i))){
        out[i] = true;
        num -= pow2(i);
      }
    }
    return out;
  }
  
  float getBetter(int mode){//generation,id,x,y,mark
    return better[mode];
  }
  
  float getBest(int mode){
    return best[mode];
  }
  
  float getX(int p){
    return convert(p);
  }
  
  float getY(int p){
    return function(convert(p));
  }
  
  int getGeneration(){
    return generation;
  }
  
  int getNumOfGens(){
    return numOfGens;
  }
  
  int getNumOfPopulation(){
    return numOfPopulation;
  }
  
  int getNumOfMutation(){
    return numOfMutation;
  }
  
  float getMutationRate(){
    return rateOfMutation;
  }
  
  String getGene(int num){
    String out = "";
    if(num<numOfPopulation){
    for(int i = 0 ;i<numOfGens;i++){
      out+=convertB(gene[num][numOfGens-i-1]);
    }
    }else{
    num -= numOfPopulation;
    for(int i = 0 ;i<numOfGens;i++){
      out+=convertB(lastGene[num][numOfGens-i-1]);
    }
    }
    return out;
  }
  
  String getInfo(int id){
    return info.get(id);
  }
  
  int getInfoSize(){
    return info.size();
  }
  
  
}