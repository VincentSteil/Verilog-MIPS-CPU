module Debouncer(D, SP, CLK);
input CLK, D;
output SP;

reg Q1, Q2;
reg [16:0] count2ms;

initial
  begin
    Q1 <= 0;
    Q2 <= 0;
	 count2ms <= 0;
  end

assign SP = Q2;

always @(posedge CLK)
  begin	 
	 if (count2ms == 100000)
		begin
			count2ms <= 0;
			Q1 <= D;
			Q2 <= Q1;
		end
	 else
		begin
			count2ms <= count2ms+1; 
		end
  end

endmodule
