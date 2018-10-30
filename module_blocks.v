
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
  wire[31:0] mux_out;

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
