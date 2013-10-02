module bcdToSevenSeg(bcdIN,numInBinary,Clk1HZ,ClkF8MS,dFourEn,dThreeEn,dTwoEn,dOneEn,CA,CB,CC,CD,CE,CF,CG);
input [15:0] bcdIN;
input [13:0] numInBinary;
input Clk1HZ;
input ClkF8MS;
output dFourEn;
output dThreeEn;
output dTwoEn;
output dOneEn;
output CA;
output CB;
output CC;
output CD;
output CE;
output CF;
output CG;

reg [6:0] nums [0:9];
reg [6:0] d1;
reg [6:0] d2;
reg [6:0] d3;
reg [6:0] d4; 

reg digitUpdateCounter;
reg allOnOrOff;
reg oneSecCounter;

reg dFourEn;
reg dThreeEn;
reg dTwoEn;
reg dOneEn;

reg CA;
reg CB;
reg CC;
reg CD;
reg CE;
reg CF;
reg CG;



always@(bcdIN)
begin
case (bcdIN[15:12])
  0: d4<=nums[0];
  1: d4<=nums[1];
  2: d4<=nums[2];
  3: d4<=nums[3];
  4: d4<=nums[4];
  5: d4<=nums[5];
  6: d4<=nums[6];
  7: d4<=nums[7];
  8: d4<=nums[8];
  9: d4<=nums[9];
  default:d4<=0;
endcase

case (bcdIN[11:8])     
  0: d3<=nums[0];
  1: d3<=nums[1];
  2: d3<=nums[2];
  3: d3<=nums[3];
  4: d3<=nums[4];
  5: d3<=nums[5];
  6: d3<=nums[6];
  7: d3<=nums[7];
  8: d3<=nums[8];
  9: d3<=nums[9];
  default:d3<=0;
endcase

case (bcdIN[7:4]) 
  0: d2<=nums[0];
  1: d2<=nums[1];
  2: d2<=nums[2];
  3: d2<=nums[3];
  4: d2<=nums[4];
  5: d2<=nums[5];
  6: d2<=nums[6];
  7: d2<=nums[7];
  8: d2<=nums[8];
  9: d2<=nums[9];
  default:d2<=0;
endcase   

case (bcdIN[3:0])
  0: d1<=nums[0];
  1: d1<=nums[1];
  2: d1<=nums[2];
  3: d1<=nums[3];
  4: d1<=nums[4];
  5: d1<=nums[5];
  6: d1<=nums[6];
  7: d1<=nums[7];
  8: d1<=nums[8];
  9: d1<=nums[9];
  default:d1<=0;
endcase   
end

always@(ClkF8MS,allOnOrOff,digitUpdateCounter,d4,d3,d2,d1)
begin
nums[0]<=7'b0000000;
nums[1]<=7'b0000110;  
nums[2]<=7'b1011011;   
nums[3]<=7'b1001111;   
nums[4]<=7'b1100110;   
nums[5]<=7'b1101101;   
nums[6]<=7'b1111101;
nums[7]<=7'b0000111;
nums[8]<=7'b1111111;
nums[9]<=7'b1011111;
if(allOnOrOff==0)
  begin
    dFourEn<=0;
    dThreeEn<=0;
    dTwoEn<=0;
    dOneEn<=0;
  end
else if(digitUpdateCounter==4)
begin
CA<=d4[0];
CB<=d4[1];
CC<=d4[2];
CD<=d4[3];
CE<=d4[4];
CF<=d4[5];
CG<=d4[6];
dFourEn<=1;
dThreeEn<=0;
dTwoEn<=0;
dOneEn<=0;
digitUpdateCounter<=3;
end 
else if(digitUpdateCounter==3)
begin
CA<=d3[0];
CB<=d3[1];
CC<=d3[2];
CD<=d3[3];
CE<=d3[4];
CF<=d3[5];
CG<=d3[6];
dFourEn<=0;
dThreeEn<=1;
dTwoEn<=0;
dOneEn<=0;
digitUpdateCounter<=2;  
end 
else if(digitUpdateCounter==2)
begin
CA<=d2[0];
CB<=d2[1];
CC<=d2[2];
CD<=d2[3];
CE<=d2[4];
CF<=d2[5];
CG<=d2[6];
dFourEn<=0;
dThreeEn<=0;
dTwoEn<=1;
dOneEn<=0;
digitUpdateCounter<=1;  
end 
else if(digitUpdateCounter==1)
begin
CA<=d1[0];
CB<=d1[1];
CC<=d1[2];
CD<=d1[3];
CE<=d1[4];
CF<=d1[5];
CG<=d1[6];
dFourEn<=0;
dThreeEn<=0;
dTwoEn<=0;
dOneEn<=1;
digitUpdateCounter<=4;  
end 
else
begin
	dFourEn<=0;
	dThreeEn<=0;
	dTwoEn<=0;
	dOneEn<=0;
	d1<=0;
	d2<=0;
	d3<=0;
	d4<=0;
	digitUpdateCounter<=4;
	allOnOrOff<=0;
	oneSecCounter<=0;
end
end


always@(Clk1HZ,numInBinary,oneSecCounter)    //// on for 1 sec off for 1 sec under 180    when time is 0 on for .5 secs and off for .5 secs  not flashing for over 180
begin
if(numInBinary>179)
  begin
   allOnOrOff<=1; 
  end
else if(numInBinary<180&&numInBinary!=0)
  begin
    allOnOrOff<=allOnOrOff^allOnOrOff;
  end
else if(numInBinary==0)
  begin
      if(oneSecCounter==0)
      begin
        oneSecCounter<=1;
      end
		else if(oneSecCounter==1)
      begin
        allOnOrOff<=allOnOrOff^allOnOrOff;
        oneSecCounter<=0;
      end
		else
		begin
			oneSecCounter<=0;
			allOnOrOff<=0;		
		end
  end
else
begin
oneSecCounter<=0;
allOnOrOff<=0;	
end  
  
end
endmodule 