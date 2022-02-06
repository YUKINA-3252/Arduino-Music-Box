
const int btnCount=12;//センサーの数
const int btnPairs[btnCount][2]={{2,3},{4,6},{22,8},{24,25},{26,27},{28,29},{30,31},{32,33},
                                   {34,35},{36,37},{38,39},{40,41}};
const int threshold=100;//閾値
const char line[btnCount]={'A','B','C','D','E','F','G','H','I','J','K','L'};

void setup(){
  Serial.begin(9600);
  for (int i=0;i<btnCount;i++){
    pinMode(btnPairs[i][0],OUTPUT);
    pinMode(btnPairs[i][1],INPUT);
  }
}

int checkTimeLag(int a,int b){
      int counter=0;
      digitalWrite(a,HIGH);
      while (digitalRead(b)!=HIGH){
        counter++;
      }
      digitalWrite(a,LOW);
      delay(1);
      return counter;
}

void loop(){

    for (int i=0;i<btnCount;i++){
      int counter=checkTimeLag(btnPairs[i][0],btnPairs[i][1]);//遅延時間をチェック
      if (counter>=threshold){
        for (int j=0;j<20;j++){
            Serial.print(line[i]);
        }
          while (1){
            //触り続けたときにアルファベットを送り続ける
            delay(10);
            int repeat=checkTimeLag(btnPairs[i][0],btnPairs[i][1]);
            if (repeat>=50){
            Serial.print(line[i]);
          }else if (repeat<50){
              break;
            }
            }
          }
      else {//何も触ってないとき
        if (i%6==0){
          Serial.write('X');
        }
      }
    }
   delay(500);
}
