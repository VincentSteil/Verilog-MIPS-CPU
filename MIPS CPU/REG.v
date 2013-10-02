module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, BTN, dFourEn1,dThreeEn1,dTwoEn1,dOneEn1, Seven_Seg_out, SW);
  
input CLK;
input RegW;
input [4:0] DR;
input [4:0] SR1;
input [4:0] SR2;
input [31:0] Reg_In;
input [1:0] BTN;
input [2:0] SW;

output reg [31:0] ReadReg1;
output reg [31:0] ReadReg2;
output wire [6:0] Seven_Seg_out;
output wire dFourEn1,dThreeEn1,dTwoEn1,dOneEn1;

reg [15:0] Reg_to_Seven_Seg;
hexToSevenSeg conv1(Reg_to_Seven_Seg,dFourEn1,dThreeEn1,dTwoEn1,dOneEn1, Seven_Seg_out, CLK);


	


reg [31:0] REG [0:31];
integer i;

initial
begin
ReadReg1 = 0;
ReadReg2 = 0;
for (i = 0; i < 32; i = i+1)
	begin
		REG[i] = 0;
	end
end


always @(posedge CLK)
begin


case (BTN)
	0:
		Reg_to_Seven_Seg <= REG[2][15:0];
	1:
		Reg_to_Seven_Seg <= REG[2][31:16];
	2:
		Reg_to_Seven_Seg <= REG[3][15:0];
	3:
		Reg_to_Seven_Seg <= REG[3][31:0];
endcase

if(RegW == 1'b1)
	begin
		if(DR == 1)
			REG[DR]<= SW;
		else
			REG[DR] <= Reg_In[31:0];
	end
ReadReg1 <= REG[SR1];
ReadReg2 <= REG[SR2];
REG[1] <= SW;

end
endmodule



