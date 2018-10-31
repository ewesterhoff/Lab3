
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
input[1:0]	OPin,
input zeroFlag,
input overflow
);
  always @(OPin) begin
  if(OPin == 2'b01 && zeroFlag == 1)
    OPout = 2'b01;
  else if(OPin == 2'b01 && zeroFlag == 0)
    OPout = 2'b00;
  else if(OPin == 2'b10 && zeroFlag == 0)
    OPout = 2'b10;
  else if(OPin == 2'b10 && zeroFlag == 1 && overflow == 1)
    OPout = 2'b10;
  else if(OPin == 2'b10 && zeroFlag == 1 && overflow == 0)
    OPout = 2'b00;
  else
    OPout = OPin; end

endmodule
