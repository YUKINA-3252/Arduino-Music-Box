import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;
import processing.serial.*;

Serial myPort;

ControlP5 cp5;
float knobValue;
Knob knob;
float knobFuncValue;

int btnCount=12;
char[] soundonPairs={'A','B','C','D','E','F','G','H','I','J','K','L'};

Minim minim;

int pitch=0;//1オクターブ変えるかどうかの変数

AudioPlayer[] playlist;


AudioOutput out;
int bpm;
int desiredFrameRate=60;
int count=0;

//メトロノーム機能
    class MyInstrument implements Instrument{
      Oscil osc;
      Line ampEnv;
      MyInstrument(float frequency){
        osc=new Oscil(frequency,0.0,Waves.SINE);//正弦波
        ampEnv=new Line();
        ampEnv.patch(osc.amplitude);
      }
      
      void noteOn(float duration){
        ampEnv.activate(duration,0.5,0);
        osc.patch(out);
      }
      
      void noteOff(){
        osc.unpatch(out);
      }
  }
 
//キーボードの1の入力でオクターブ変える 
  void keyPressed(){
    if (key=='0'){
      pitch++;
    }
  
  }
  
void setup(){
  myPort=new Serial(this,"/dev/ttyACM0",9600);
  minim=new Minim(this);
  playlist=new AudioPlayer[btnCount];
  
//マリンバの音
  /*
  playlist[0]=minim.loadFile("Marinba_2si.mp3");
  //playlist[0]=minim.loadFile("Marinba_do.mp3");
  playlist[1]=minim.loadFile("Marinba_re.mp3");
  playlist[2]=minim.loadFile("Marinba_mi.mp3");
  playlist[3]=minim.loadFile("Marinba_fa.mp3");
  playlist[4]=minim.loadFile("Marinba_so.mp3");
  playlist[5]=minim.loadFile("Marinba_ra.mp3");
  playlist[6]=minim.loadFile("Marinba_si.mp3");
  playlist[7]=minim.loadFile("Marinba_do#.mp3");
  playlist[8]=minim.loadFile("Marinba_re#.mp3");
  playlist[9]=minim.loadFile("Marinba_fa#.mp3");
  playlist[10]=minim.loadFile("Marinba_so#.mp3");
  playlist[11]=minim.loadFile("Marinba_ra#.mp3");
  playlist[12]=minim.loadFile("Marinba_ddo.mp3");
  playlist[13]=minim.loadFile("Marinba_rre.mp3");
  playlist[14]=minim.loadFile("Marinba_mmi.mp3");
  playlist[15]=minim.loadFile("Marinba_ffa.mp3");
  playlist[16]=minim.loadFile("Marinba_sso.mp3");
  playlist[17]=minim.loadFile("Marinba_rra.mp3");
  playlist[18]=minim.loadFile("Marinba_ssi.mp3");
  playlist[19]=minim.loadFile("Marinba_ddoo.mp3");
  playlist[20]=minim.loadFile("Marinba_rree.mp3");
  playlist[21]=minim.loadFile("Marinba_ffa#.mp3");
  playlist[22]=minim.loadFile("Marinba_sso#.mp3");
  playlist[23]=minim.loadFile("Marinba_rra#.mp3");
 */
 
//シンセサイザーの音 
  /*
  playlist[0]=minim.loadFile("synbass_do.mp3");
  playlist[1]=minim.loadFile("synbass_re.mp3");
  playlist[2]=minim.loadFile("synbass_mi.mp3");
  playlist[3]=minim.loadFile("synbass_fa.mp3");
  playlist[4]=minim.loadFile("synbass_so.mp3");
  playlist[5]=minim.loadFile("synbass_ra.mp3");
  playlist[6]=minim.loadFile("synbass_si.mp3");
  playlist[7]=minim.loadFile("synbass_do#.mp3");
  playlist[8]=minim.loadFile("synbass_re#.mp3");
  playlist[9]=minim.loadFile("synbass_fa#.mp3");
  playlist[10]=minim.loadFile("synbass_so#.mp3");
  playlist[11]=minim.loadFile("synbass_ra#.mp3");
  playlist[12]=minim.loadFile("synbass_ddo.mp3");
  playlist[13]=minim.loadFile("synbass_rre.mp3");
  playlist[14]=minim.loadFile("synbass_mmi.mp3");
  playlist[15]=minim.loadFile("synbass_ffa.mp3");
  playlist[16]=minim.loadFile("synbass_sso.mp3");
  playlist[17]=minim.loadFile("synbass_rra.mp3");
  playlist[18]=minim.loadFile("synbass_ssi.mp3");
  playlist[19]=minim.loadFile("synbass_ddo#.mp3");
  playlist[20]=minim.loadFile("synbass_rre#.mp3");
  playlist[21]=minim.loadFile("synbass_ffa#.mp3");
  playlist[22]=minim.loadFile("synbass_sso#.mp3");
  playlist[23]=minim.loadFile("synbass_rra#.mp3");
  */
 
//オルゴールの音 
  /*
  playlist[0]=minim.loadFile("musicbox_do.mp3");
  playlist[1]=minim.loadFile("musicbox_re.mp3");
  playlist[2]=minim.loadFile("musicbox_mi.mp3");
  playlist[3]=minim.loadFile("musicbos_fa.mp3");
  playlist[4]=minim.loadFile("musicbox_so.mp3");
  playlist[5]=minim.loadFile("musicbox_ra.mp3");
  playlist[6]=minim.loadFile("musicbox_si.mp3");
  playlist[7]=minim.loadFile("musicbox_do#.mp3");
  playlist[8]=minim.loadFile("musicbox_re#.mp3");
  playlist[9]=minim.loadFile("musicbox_fa#.mp3");
  playlist[10]=minim.loadFile("musicbox_so#.mp3");
  playlist[11]=minim.loadFile("musicbox_ra#.mp3");
  playlist[12]=minim.loadFile("musicbox_ddo.mp3");
  playlist[13]=minim.loadFile("musicbox_rre.mp3");
  playlist[14]=minim.loadFile("musicbox_mmi.mp3");
  playlist[15]=minim.loadFile("musicbox_ffa.mp3");
  playlist[16]=minim.loadFile("musicbox_sso.mp3");
  playlist[17]=minim.loadFile("musicbox_rra.mp3");
  playlist[18]=minim.loadFile("musicbox_ssi.mp3");
  playlist[19]=minim.loadFile("musicbox_ddo#.mp3");
  playlist[20]=minim.loadFile("musicbox_rre#.mp3");
  playlist[21]=minim.loadFile("musicbox_ffa#.mp3");
  playlist[22]=minim.loadFile("musicbox_sso#.mp3");
  playlist[23]=minim.loadFile("musicbox_rra#.mp3");
  */
  
  playlist[0]=minim.loadFile("music_so1.mp3");
  playlist[1]=minim.loadFile("music_si1.mp3");
  playlist[2]=minim.loadFile("music_do#.mp3");
  playlist[3]=minim.loadFile("music_re.mp3");
  playlist[4]=minim.loadFile("music_mi.mp3");
  playlist[5]=minim.loadFile("music_fa.mp3");
  playlist[6]=minim.loadFile("music_so.mp3");
  playlist[7]=minim.loadFile("music_ra.mp3");
  playlist[8]=minim.loadFile("music_si.mp3");
  playlist[9]=minim.loadFile("music_fa#.mp3");
  playlist[10]=minim.loadFile("music_ddo.mp3");
  playlist[11]=minim.loadFile("music_rre.mp3");

  
  
  
  size (1400,600);//OpenGLの描画ウィンドウの表示サイズ
  frameRate(desiredFrameRate);
  background(255);//背景は白

　//キーボード画面の描画
  strokeWeight(6);
  for (int i=0;i<15;i++){
    line(60+90*i,200,60+90*i,500);
  }
  line(60,500,1320,500);
  line(60,200,1320,200);
  
  strokeWeight(36);
  line(150,200,150,370);
  line(240,200,240,370);
  line(420,200,420,370);
  line(510,200,510,370);
  line(600,200,600,370);
  line(780,200,780,370);
  line(870,200,870,370);
  line(1050,200,1050,370);
  line(1140,200,1140,370);
  line(1230,200,1230,370);
 
  //メトロノームダイヤルの描画
  out=minim.getLineOut();
  cp5=new ControlP5(this);
  cp5.addKnob("bpm")
    .setRange(0,200)
    .setValue(0)
    .setPosition(100,50)
    .setRadius(50)
    .setNumberOfTickMarks(10)
    .setTickMarkLength(5);
    
}
 
  void draw(){
  
//メトロノーム
    if (frameCount % int(desiredFrameRate/(bpm/60.0))==0){
      if (count==0){
        out.playNote(0.0,0.3,new MyInstrument(440));
      }else{
        out.playNote(0.0,0.3,new MyInstrument(440));
      }
      count++;
      if (count==4){
        count=0;
      }
    }
   
//シリアル通信がアルファベットならば音楽再生
  for (int a=0;a<12;a++){
    if (myPort.read()==soundonPairs[a]){
      if (pitch%2==0){
          boolean ret=playlist[a].isPlaying();
          if (ret!=true){
            /*for (int c=0;c<btnCount;c++){
              boolean ans=playlist[c].isPlaying();
              if (ans==true){
                playlist[c].pause(); 
              }
            }*/
            playlist[a].rewind();
            playlist[a].play();
          }
        }

	//赤い円の描画（白鍵盤）
       for (int d=0;d<7;d++){
         fill(255,255,255);
         noStroke();
         ellipse(105+90*d,450,60,60);
         ellipse(735+90*d,450,60,60);
      }
      //赤い円の描画（黒鍵盤）
      fill(0,0,0);
      noStroke();
      ellipse(150,350,35,35);
      ellipse(240,350,35,35);
      ellipse(420,350,35,35);
      ellipse(510,350,35,35);
      ellipse(600,350,35,35);
      ellipse(780,350,35,35);
      ellipse(870,350,35,35);
      ellipse(1050,350,35,35);
      ellipse(1140,350,35,35);
      ellipse(1230,350,35,35);
     
      
      if ((a>=0)&&(a<7)){
        fill(255,0,0);
        noStroke();
        ellipse(105+90*a,450,60,60);
      }else if ((a==7)||(a==8)){
        fill(255,0,0);
        noStroke();
        ellipse(150+90*(a-7),350,35,35);
      }else{
        fill(255,0,0);
        noStroke();
        ellipse(420+90*(a-9),350,35,35);
      }
      
//１オクターブ変える場合
      if (pitch%2==1){
          boolean ret=playlist[a+12].isPlaying();
          if (ret!=true){
         
            playlist[a+12].rewind();
            playlist[a+12].play();
          }
 
      for (int d=0;d<7;d++){
         fill(255,255,255);
         noStroke();
         ellipse(105+90*d,450,60,60);
         ellipse(735+90*d,450,60,60);
      }
      //黒鍵盤
      fill(0,0,0);
      noStroke();
      ellipse(150,350,35,35);
      ellipse(240,350,35,35);
      ellipse(420,350,35,35);
      ellipse(510,350,35,35);
      ellipse(600,350,35,35);
      ellipse(780,350,35,35);
      ellipse(870,350,35,35);
      ellipse(1050,350,35,35);
      ellipse(1140,350,35,35);
      ellipse(1230,350,35,35);
      
      if ((a>=0)&&(a<7)){
        fill(255,0,0);
        noStroke();
        ellipse(735+90*a,450,60,60);
      }else if ((a==7)||(a==8)){
        fill(255,0,0);
        noStroke();
        ellipse(780+90*(a-7),350,35,35);
      }else{
        fill(255,0,0);
        noStroke();
        ellipse(1050+90*(a-9),350,35,35);
      }
      }
      if ((a>=3)&&(a<9)){
        fill(255,0,0);
        noStroke();
        ellipse(195+90*(a-3),450,60,60);
      }else if (a==2){
        fill(255,0,0);
        noStroke();
        ellipse(150+90*(a-2),350,35,35);
      }else if (a==9){
        fill(255,0,0);
        noStroke();
        ellipse(420+90*(a-9),350,35,35);
      }else if ((a==10)||(a==11)){
        fill(255,0,0);
        noStroke();
        ellipse(735+90*(a-10),450,60,60);
    }
  
  }
  }
  if (myPort.read()=='X'){
      for (int c=0;c<btnCount;c++){
        //playlist[c].pause(); 
 
      }
 
  
  }
  }
  
 
 //すべての音楽ファイルを停止 
  void stop(){
      for (int a=0;a<btnCount;a++){
        playlist[a].close();
      }
    minim.stop();
    super.stop();
  }

  

  
