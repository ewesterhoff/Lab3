
`include "alu.v"
`include "lut.v"

module JAL_module
(
output[31:0] toDataW,
input[31:0]	PC,
input[31:0] toMem,
input[5:0] OPCode
);
  parameter constIncr = 32'b00000000000000000000000000000100; //4
  wire[31:0] adder_out;
  wire carryout, zero, overflow, if_jal;

ALU alu(.result(adder_out), .carryout(carryout), .zero(zero), .overflow(overflow),
.operandA(constIncr), .operandB(PC), .command(3'd0)); //add

JalLUT JALTEST(.muxindex(if_jal), .OPCode(OPCode));

doublemux32 mux(.din_0(adder_out), .din_1(toMem), .sel(if_jal), .mux_out(toDataW));

endmodule

module  doublemux32(
input[31:0] din_0, // Mux first input
input[31:0] din_1, // Mux Second input
input sel, // Select input
output reg[31:0] mux_out // Mux output
);
always @ (sel or din_0 or din_1)
begin
 if (sel == 1'b0) begin
     mux_out = din_0;
 end else begin
     mux_out = din_1 ;
 end
 end

endmodule


module Jump_Calc
(
output[31:0] new_PC,
input[31:0]	alu_output,
input[31:0] old_PC,
input[31:0] instruction,
input[5:0] OPCode
);
  wire if_jump;
  reg[31:0] cat = {instruction[0:25], old_PC[28:31]};
always @ (cat)
  cat = cat<<2;

JumpLUT JTEST(.muxindex(if_jump), .OPCode(OPCode));

doublemux32 mux(.din_0(cat), .din_1(alu_output), .sel(if_jump), .mux_out(new_PC));

endmodule
