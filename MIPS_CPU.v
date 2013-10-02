module MIPS_CPU(CLK, RST, CS, WE, ADDR, Mem_Bus);
  
  input  CLK;
  input  RST;
  output CS;
  output WE;
  output [31:0] ADDR;
  inout [31:0] Mem_Bus;
  
  reg WE, CS;
  reg [31:0] ADDR;

  
  reg [31:0] PC;
  reg [31:0] instruction;
  wire [5:0] op_code;
  wire [5:0] op_code2;
  wire [15:0] immediate;
  wire [25:0] jump;
  reg [31:0] ALU_out;
  reg [31:0] lw_buffer;
  reg [31:0] sw_buffer;
  
  assign Mem_Bus = ((WE == 1'b0)) ? 32'bZ : sw_buffer;

  
  
  assign op_code = instruction [31:26];
  assign op_code2 = instruction [5:0];
  assign immediate = instruction [15:0];
  assign jump = instruction [25:0];
  
  reg RegW;
  reg [4:0] DR;   // Destination Register
  reg [4:0] SR1;  // Source Register 1
  reg [4:0] SR2;  // Source Register 2
  reg [31:0] Reg_In; // Data to be written into reg
  wire [31:0] ReadReg1;  // Data from reg 1
  wire [31:0] ReadReg2;  // Data from reg 2
  
  REG reg1(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2);

  reg[8:0] state;
  
  
  initial
    begin
      WE = 0;
      CS = 0;
      PC = 0;
      instruction = 0;
      ADDR = 0;
      ALU_out = 0;
      lw_buffer = 0;
      sw_buffer = 0;
      state = 0;
    end
  
  parameter fetch_instr     = 0;
  parameter fetch_instr_2   = 1;
  parameter decode_instr    = 2;
  parameter invalid_instr   = 3;
  parameter Add             = 4;
  parameter Add_2           = 5;
  parameter Add_3           = 6;
  parameter Add_4           = 7;
  parameter Add_5           = 64;
  parameter Sub             = 8;
  parameter Sub_2           = 9;
  parameter Sub_3           = 10;
  parameter Sub_4           = 11;
  parameter Sub_5           = 67;
  parameter XOR1            = 12;
  parameter XOR1_2          = 13;
  parameter XOR1_3          = 14;
  parameter XOR1_4          = 15;
  parameter XOR1_5          = 72;
  parameter AND1            = 16;
  parameter AND1_2          = 17;
  parameter AND1_3          = 18;
  parameter AND1_4          = 19;
  parameter AND1_5          = 71;
  parameter OR1             = 20;
  parameter OR1_2           = 21;
  parameter OR1_3           = 22;
  parameter OR1_4           = 23;
  parameter OR1_5           = 70;
  parameter slt             = 24;
  parameter slt_2           = 25;
  parameter slt_3           = 26;
  parameter slt_4           = 27;
  parameter slt_5           = 68;
  parameter srl             = 28;
  parameter srl_2           = 29;
  parameter srl_3           = 30;
  parameter srl_4           = 31;
  parameter srl_5           = 69;
  parameter sll             = 32;
  parameter sll_2           = 33;
  parameter sll_3           = 34;
  parameter sll_4           = 35;
  parameter sll_5           = 65;
  parameter jr              = 36;
  parameter jr_2            = 37;
  parameter jr_3            = 66;
  parameter addi            = 38;
  parameter addi_2          = 39;
  parameter addi_3          = 40;
  parameter addi_4          = 41;
  parameter addi_5          = 76;
  parameter andi            = 42;
  parameter andi_2          = 43;
  parameter andi_3          = 44;
  parameter andi_4          = 45;
  parameter andi_5          = 77;
  parameter ori             = 46;
  parameter ori_2           = 47;
  parameter ori_3           = 48;
  parameter ori_4           = 49;
  parameter ori_5           = 78;
  parameter lw              = 50;
  parameter lw_2            = 51;
  parameter lw_3            = 52;
  parameter lw_4            = 53;
  parameter lw_5            = 54;
  parameter lw_6            = 75;
  parameter sw              = 55;
  parameter sw_2            = 56;
  parameter sw_3            = 57;
  parameter sw_4            = 58;
  parameter beq             = 59;
  parameter beq_2           = 60;
  parameter beq_3           = 79;
  parameter bne             = 61;
  parameter bne_2           = 62;
  parameter bne_3           = 80;
  parameter j               = 63;
  
  
  // last count = 75
  

  always @ (posedge CLK)  begin
    case (state)
      
      fetch_instr:
        begin
          RegW <= 0;
          CS <= 1;
          WE <= 0;
          ADDR <= PC;
          PC <= PC + 1;
          state <= fetch_instr_2;       
        end
        
      fetch_instr_2:
        begin
          instruction <= Mem_Bus;
          state <= decode_instr;
        end
        
      decode_instr:
        begin
          case (op_code)
            0:    // R format
              begin
                case (op_code2)
                  32:           
                    state <= Add;
                  34:
                    state <= Sub;
                  38:
                    state <= XOR1;
                  36:
                    state <= AND1; 
                  37:
                    state <= OR1;
                  42:
                    state <= slt;
                  2:
                    state <= srl;
                  0:
                    state <= sll;
                  8:
                    state <= jr; 
                  default:
                    state <= invalid_instr;                     
                endcase               
              end
            8:  // addi
              state <= addi;
            12: // andi
              state <= andi;
            13: // ori
              state <= ori;
            35: // lw
              state <= lw;
            43: // sw
              state <= sw;
            4: // beq
              state <= beq;
            5: // bne
              state <= bne;
            2: // j
              state <= j;
            default:
              state <= invalid_instr;
          endcase
        end

        
      invalid_instr:
        begin
          state <= invalid_instr;
        end
        
      Add:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= Add_2;
        end
      Add_2:
        begin
          state <= Add_3;
        end
      Add_3:
        begin
          ALU_out <= ReadReg1 + ReadReg2;
          state <= Add_4;
        end
      Add_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= Add_5;          
        end
      Add_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end  
     
      Sub:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= Sub_2;
        end
      Sub_2:
        begin
          state <= Sub_3;
        end
      Sub_3:
        begin
          ALU_out <= ReadReg1 - ReadReg2;
          state <= Sub_4;
        end
      Sub_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= Sub_5;          
        end
      Sub_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end    
          

      XOR1:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= XOR1_2;
        end
      XOR1_2:
        begin
          state <= XOR1_3;
        end      
      XOR1_3:
        begin
          ALU_out <= ReadReg1 ^ ReadReg2;
          state <= XOR1_4;
        end
      XOR1_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= XOR1_5;          
        end
      XOR1_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end

      AND1:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= AND1_2;
        end
      AND1_2:
        begin
          state <= AND1_3;
        end
      AND1_3:
        begin
          ALU_out <= ReadReg1 & ReadReg2;
          state <= AND1_4;
        end
      AND1_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= AND1_5;          
        end
      AND1_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      OR1:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= OR1_2;
        end
      OR1_2:
        begin
          state <= OR1_3;
        end
      OR1_3:
        begin
          ALU_out <= ReadReg1 | ReadReg2;
          state <= OR1_4;
        end
      OR1_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= OR1_5;          
        end
      OR1_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end

      slt:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $3
          RegW <= 0;
          state <= slt_2;
        end
      slt_2:
        begin
          state <= slt_3;
        end
      slt_3:
        begin
          if( ReadReg1 < ReadReg2)
            ALU_out <= 1;
          else
            ALU_out <= 0;         
          state <= slt_4;
        end
      slt_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= slt_5;          
        end
      slt_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      srl:
        begin
          SR1 <= instruction[20:16]; // $2
          RegW <= 0;
          state <= srl_2;
        end
      srl_2:
        begin
          state <= srl_3;
        end
      srl_3:
        begin
          ALU_out <= ReadReg1 >> instruction[10:6];
          state <= srl_4;
        end
      srl_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= srl_5;          
        end
      srl_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      sll:
        begin
          SR1 <= instruction[20:16]; // $2
          RegW <= 0;
          state <= sll_2;
        end
      sll_2:
        begin
          state <= sll_3;
        end
      sll_3:
        begin
          ALU_out <= ReadReg1 << instruction[10:6];
          state <= sll_4;
        end
      sll_4:
        begin
          RegW <= 1;
          DR <= instruction[15:11]; // $1
          state <= sll_5;          
        end
      sll_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      jr:
        begin
          SR1 <= instruction[25:21]; // $2
          RegW <= 0;
          state <= jr_2;
        end
      jr_2:
        begin
          state <= jr_3;
        end
      jr_3:
        begin
          PC <= ReadReg1;
          state <= fetch_instr;
        end

      addi:
        begin
          SR1 <= instruction[25:21]; // $2
          RegW <= 0;
          state <= addi_2;
        end
      addi_2:
        begin
          state <= addi_3;
        end
      addi_3:
        begin
          ALU_out <= ReadReg1 + immediate;
          state <= addi_4;
        end
      addi_4:
        begin
          RegW <= 1;
          DR <= instruction[20:16]; // $1
          state <= addi_5;          
        end
      addi_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      andi:
        begin
          SR1 <= instruction[25:21]; // $2
          RegW <= 0;
          state <= andi_2;
        end
      andi_2:
        begin
          state <= andi_3;
        end
      andi_3:
        begin
          ALU_out <= ReadReg1 & immediate;
          state <= andi_4;
        end
      andi_4:
        begin
          RegW <= 1;
          DR <= instruction[20:16]; // $1
          state <= andi_5;          
        end
      andi_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      ori:
        begin
          SR1 <= instruction[25:21]; // $2
          RegW <= 0;
          state <= ori_2;
        end
      ori_2:
        begin
          state <= ori_3;
        end
      ori_3:
        begin
          ALU_out <= ReadReg1 | immediate;
          state <= ori_4;
        end
      ori_4:
        begin
          RegW <= 1;
          DR <= instruction[20:16]; // $1
          state <= ori_5;          
        end
      ori_5:
        begin
          Reg_In <= ALU_out;
          state <= fetch_instr;
        end
        
      lw:
        begin
          SR1 <= instruction[25:21]; // $2
          RegW <= 0;
          state <= lw_2;
        end
      lw_2:
        begin
          state <= lw_3;
        end
      lw_3:
        begin
          ALU_out <= ReadReg1 + immediate;
          state <= lw_4;
        end
      lw_4:
        begin
          CS <= 1;
          WE <= 0;
          ADDR <= ALU_out;
          state <= lw_5;          
        end
      lw_5:
        begin
          lw_buffer <= Mem_Bus;
          RegW <= 1;
          DR <= instruction[20:16]; // $1
          state <= lw_6;
        end  
      lw_6:
        begin
          Reg_In <= lw_buffer;
          state <= fetch_instr;
        end   

      sw:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $1
          RegW <= 0;
          state <= sw_2;
        end
      sw_2:
        begin
          ALU_out <= ReadReg1 + immediate; // $2 value + imm
          state <= sw_3;
        end
      sw_3:
        begin
          ADDR <= ALU_out;                  
          sw_buffer <= ReadReg2;
          state <= sw_4;        
        end
      sw_4:
        begin
          CS <= 1;
          WE <= 1; 
          state <= fetch_instr;
        end
      
      beq:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $1
          RegW <= 0;
          state <= beq_2;
        end
      beq_2:
        begin
          state <= beq_3;
        end
      beq_3:
        begin
          if (ReadReg1 == ReadReg2)
            PC <= PC + immediate;
          else
            begin
            end
          state <= fetch_instr;
        end

      bne:
        begin
          SR1 <= instruction[25:21]; // $2
          SR2 <= instruction[20:16]; // $1
          RegW <= 0;
          state <= bne_2;
        end
      bne_2:
        begin
          state <= bne_3;
        end  
      bne_3:
        begin
          if (ReadReg1 != ReadReg2)
            PC <= PC + immediate;
          else
            begin
            end
          state <= fetch_instr;
        end
        
      j:
        begin
          PC <= jump;
          state <= fetch_instr;
        end
      
      default:
        begin
          state <= fetch_instr;
        end
      
    endcase
  end



 



endmodule