module simpleDivider(clk50Mhz, slowClk); 
input clk50Mhz; //fast clock 
output slowClk; //slow clock 
reg[23:0] counter; 
assign slowClk= counter[23]; //(2^26 / 50E6) = 1.34seconds 
initial 
begin 
counter <= 0; 
end 
always @ (posedge clk50Mhz) 
begin 
counter <= counter + 1; //increment the counter every 20ns (1/50 Mhz) cycle. 
end 
endmodule
