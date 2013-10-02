module hexToSevenSeg(bcdIN,dFourEn1,dThreeEn1,dTwoEn1,dOneEn1, C2, CLK);//CA,CB,CC,CD,CE,CF,CG);
	input [15:0] bcdIN;
	input CLK;
	output dFourEn1;
	output dThreeEn1;
	output dTwoEn1;
	output dOneEn1;
	output [6:0] C2;

  wire dFourEn1;
  wire dThreeEn1;
  wire dTwoEn1;
  wire dOneEn1;

	reg dFourEn;
	reg dThreeEn;
	reg dTwoEn;
	reg dOneEn;
	reg [6:0] C;

  assign C2 = ~C;
  assign dFourEn1 = ~dFourEn;
  assign dThreeEn1 = ~dThreeEn;
  assign dTwoEn1 = ~dTwoEn;
  assign dOneEn1 = ~dOneEn;


	wire [6:0] d1;
	wire [6:0] d2;
	wire [6:0] d3;
	wire [6:0] d4; 

  wire ClkF8MS;


	seven_seg_converter sev_seg_conv1(bcdIN[15:12], d4);
	seven_seg_converter sev_seg_conv2(bcdIN[11:8], d3);
	seven_seg_converter sev_seg_conv3(bcdIN[7:4], d2);
	seven_seg_converter sev_seg_conv4(bcdIN[3:0], d1);
	
	niceDivider cd1(CLK,ClkF8MS);

	reg [1:0] sev_seg_ctrl;

		
	always@(posedge ClkF8MS)
		begin
			sev_seg_ctrl <= sev_seg_ctrl +1;
				begin
							if(sev_seg_ctrl == 3)
								begin
									C <= d4;
									dFourEn<=0;
									dThreeEn<=0;
									dTwoEn<=0;
									dOneEn<=1;
								end 
							else if(sev_seg_ctrl == 2)
								begin
									C <= d3;
									dFourEn<=0;
									dThreeEn<=0;
									dTwoEn<=1;
									dOneEn<=0;
								end 
							else if(sev_seg_ctrl == 1)
								begin
							
									C <= d2;
									dFourEn<=0;
									dThreeEn<=1;
									dTwoEn<=0;
									dOneEn<=0;
								end 
							else if(sev_seg_ctrl == 0)
								begin

									C <= d1;
									dFourEn<=1;
									dThreeEn<=0;
									dTwoEn<=0;
									dOneEn<=0;	
								end 
							else
								begin
									dFourEn<=0;
									dThreeEn<=0;
									dTwoEn<=0;
									dOneEn<=0;
								end
				end
		end

	
endmodule 