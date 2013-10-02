module bcdToSevenSegTop(bt0,bt1,bt2,bt3,sw0,sw1,Clk,dFourEn,dThreeEn,dTwoEn,dOneEn,CA,CB,CC,CD,CE,CF,CG);
  
input bt0;
input bt1;
input bt2;
input bt3;
input sw0;
input sw1;
input Clk;
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

wire Clk1HZ;
wire ClkF8MS;
wire [15:0] bcdIN;
wire [13:0] numInBinary;
wire dbBt0;
wire dbBt1;
wire dbBt2;
wire dbBt3;
wire dbSw0;
wire dbSw1;
niceDivider cd1(Clk,Clk1HZ,ClkF8MS);
Debounce_Single_Pulser dbs0(sw0,dbSw0,Clk);
Debounce_Single_Pulser dbs1(sw1,dbSw1,Clk);
Debounce_Single_Pulser db0(bt0,dbBt0,Clk);
Debounce_Single_Pulser db1(bt1,dbBt1,Clk);
Debounce_Single_Pulser db2(bt2,dbBt2,Clk);
Debounce_Single_Pulser db3(bt3,dbBt3,Clk);
Binary_Adder_Decrementer_CTRL bdct1(dbBt0,dbBt1,dbBt2,dbBt3,dbSw0,dbSw1,bcdIN,Clk,numInBinary);
bcdToSevenSeg bcd1(bcdIN,numInBinary,Clk1HZ,ClkF8MS,dFourEn,dThreeEn,dTwoEn,dOneEn,CA,CB,CC,CD,CE,CF,CG);


endmodule
  
