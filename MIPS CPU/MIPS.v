module Complete_MIPS(CLK, SW, BTN2, Seven_Seg, dFourEn1,dThreeEn1,dTwoEn1,dOneEn1);
/* Will need to be modified to add functionality */
input CLK;
input [1:0] BTN2;
input [2:0] SW;

output dFourEn1;
output dThreeEn1;
output dTwoEn1;
output dOneEn1;
output wire [6:0] Seven_Seg;


wire CS, WE;
wire [31:0] ADDR, Mem_Bus;

wire [1:0] BTN;

Debouncer db0(BTN2[0], BTN[0], CLK);
Debouncer db1(BTN2[1], BTN[1], CLK);




MIPS_CPU CPU(CLK, CS, WE, ADDR, Mem_Bus, SW, BTN, Seven_Seg, dFourEn1,dThreeEn1,dTwoEn1,dOneEn1);
Memory MEM(CS, WE, CLK, ADDR, Mem_Bus);
endmodule
