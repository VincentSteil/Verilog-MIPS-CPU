module seven_seg_converter (hex, seven_seg_code);
	input [3:0] hex;  
	output [6:0] seven_seg_code;
	
	reg [6:0] seven_seg_code;
	
	
	always@(*)
		begin
			case (hex)
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
			  10: seven_seg_code <= 7'b1110111;	// a		  
			  11: seven_seg_code <= 7'b1111100; // b			  
			  12: seven_seg_code <= 7'b0111001; // c		  
			  13: seven_seg_code <= 7'b1011110; // d	  
			  14: seven_seg_code <= 7'b1111001; // e	  
			  15: seven_seg_code <= 7'b1110001; // f
			  default: seven_seg_code <= 7'b0000000;
			endcase
		end
	
endmodule
