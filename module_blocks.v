module JAL_module
(
output reg[31:0] toDataWr,
input[31:0]	PC,
input[31:0] toMem,
input[5:0] OPCode
);
  parameter constIncr = 4;

  always @(OPCode) begin
  if(OPCode == 6'b000000 && Funct == 6'b001000)
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
