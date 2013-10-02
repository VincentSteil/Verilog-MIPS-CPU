module seven_seg_converter (bcd, seven_seg_code);
	input [3:0] bcd;  
	output [6:0] seven_seg_code;
	
	reg [6:0] seven_seg_code;
	
	
	always@(*)
		begin
			case (bcd)
			  0: seven_seg_code <= 7'b0111111;
			  1: seven_seg_code <= 7'b0000110;
			  2: seven_seg_code <= 7'b1011011;
			  3: seven_seg_code <= 7'b1001111;
			  4: seven_seg_code <= 7'b1100110;
			  5: seven_seg_code <= 7'b1101101;
			  6: seven_seg_code <= 7'b1111101;
			  7: seven_seg_code <= 7'b0000111;
			  8: seven_seg_code <= 7'b1111111;
			  9: seven_seg_code <= 7'b1101111;
			  default: seven_seg_code <= 7'b0000000;
			endcase
		end
	
endmodule
