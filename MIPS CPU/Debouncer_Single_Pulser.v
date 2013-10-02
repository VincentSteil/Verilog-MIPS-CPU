module Debounce_Single_Pulser (D, SP, CLK);
input CLK, D;
output SP;

reg Q1, Q2, Q3;

initial
  begin
    Q1 <= 0;
    Q2 <= 0;
    Q3 <= 0;
  end

assign SP = ~Q3 && Q2;

always @(posedge CLK)
  begin
    Q1 <= D;
    Q2 <= Q1;
    Q3 <= Q2;
  end

endmodule
    