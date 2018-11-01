
module JalLUT
(
output reg muxindex,
input[5:0]	OPCode
);
  always @(OPCode) begin
    case (OPCode)
      6'b000011:  begin muxindex = 0; end
      default:  begin muxindex = 1;end
    endcase
  end

endmodule

module JumpLUT
(
output reg muxindex,
input[5:0]	OPCode
);
  always @(OPCode) begin
    case (OPCode)
      6'b000010:  begin muxindex = 0; end
      default:  begin muxindex = 1;end
    endcase
  end

endmodule


module PC_OP_Decode
(
output reg[1:0] muxindex,
input[5:0]	OPCode,
input[5:0] funct
);
  reg[5:0] addrCode = 6'b000000;

  always @(OPCode) begin
  if(OPCode == 6'b000000 && funct == 6'b001000)
    addrCode = 6'b111111;
  else
    addrCode = OPCode;

    case (addrCode)
      6'b000101:  begin muxindex = 2'b01; end //BEQ, op=4
      6'b000110:  begin muxindex = 2'b10; end //BNE, op=5
      6'b111111:  begin muxindex = 2'b11; end //JR, op=0, funct=8
      default:  begin muxindex = 2'b00;end //else
    endcase
  end

endmodule

module PC_Flag_Status
(
output reg[1:0] OPout,
output reg[15:0] BEQ_in, BNE_in,
input[1:0]	OPin,
input zeroFlag,
input overflow,
input[31:0] instruction
);
  always @(OPin) begin
  if(OPin == 2'b01 && zeroFlag == 1) begin
    OPout = 2'b01;
    BEQ_in = instruction[15:0]; end
  else if(OPin == 2'b01 && zeroFlag == 0) begin
    OPout = 2'b00;
    BEQ_in = 0; end
  else if(OPin == 2'b10 && zeroFlag == 0) begin
    OPout = 2'b10;
    BNE_in = instruction[15:0]; end
  else if(OPin == 2'b10 && zeroFlag == 1 && overflow == 1) begin
    OPout = 2'b10;
    BNE_in = instruction[15:0]; end
  else if(OPin == 2'b10 && zeroFlag == 1 && overflow == 0) begin
    OPout = 2'b00;
    BNE_in = 0; end
  else
    OPout = OPin; end

endmodule


module add4LUT
(
  output reg muxindex,
  input[5:0] funct
);
  always @ (funct) begin
    case (funct)
      6'b001000: begin muxindex = 0; end
      default: begin muxindex = 1; end
    endcase
  end

endmodule

module instrDecode
(
  input[31:0] instruction,
  output reg[5:0] OPCode, funct,
  output reg RegWE, MemWE, memToReg, ALUsrc,
  output reg[1:0] RegDst,
  output reg[2:0] ALUcntrl
  output reg[15:0] imm16;
  output reg[4:0] Rd, Rt, R31, Rs;
  );

  reg[3:0] instrNum;

  always @ (instruction) begin
    OPCode = instruction[31:26];
    if (OPCode == 35) //load word
      instrNum = 1;
    else if (OPCode == 43) //store word
      instrNum = 2;
    else if (OPCode == 4) //beq
      instrNum = 3;
    else if (OPCode == 5) //bne
      instrNum = 4;
    else if (OPCode == 14) //xori
      instrNum = 5;
    else if (OPCode == 8) //addi
      instrNum = 6;

    else if (OPCode == 2) //jump
      instrNum = 7;
    else if (OPCode == 3) //jump and link
      instrNum = 8;

    else if (OPCode == 0) begin //r type
      funct = instruction[5:0];
      if (funct == 8) //jump register
        instrNum = 9;
      else if (funct == 32) //add
        instrNum = 10;
      else if (funct == 34) //subtract
        instrNum = 11;
      else if (funct == 42) //set less than
        instrNum = 12;end
    else
      instrNum = 13;

    case (instrNum)
      1: begin RegDst = 1; RegWE = 1; ALUcntrl = 0; MemWE = 0; memToReg = 1; ALUsrc = 1; end
      2: begin RegDst = 0; RegWE = 0; ALUcntrl = 0; MemWE = 1; memToReg = 0; ALUsrc = 1; end
      3: begin RegDst = 0; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      4: begin RegDst = 0; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      5: begin RegDst = 1; RegWE = 1; ALUcntrl = 2; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      6: begin RegDst = 1; RegWE = 1; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      7: begin RegDst = 0; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      8: begin RegDst = 2; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      9: begin RegDst = 0; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
      10: begin RegDst = 0; RegWE = 1; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 0; end
      11: begin RegDst = 0; RegWE = 1; ALUcntrl = 1; MemWE = 0; memToReg = 0; ALUsrc = 0; end
      12: begin RegDst = 0; RegWE = 1; ALUcntrl = 3; MemWE = 0; memToReg = 0; ALUsrc = 0; end
      default: begin RegDst = 1; RegWE = 0; ALUcntrl = 0; MemWE = 0; memToReg = 0; ALUsrc = 1; end
    endcase

  end


  endmodule
