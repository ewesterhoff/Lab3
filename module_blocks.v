
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
  reg[31:0] cat;
  always @ (cat) begin
    cat = {instruction[25:0], old_PC[31:28]};
    cat = cat<<2; end

  JumpLUT JTEST(.muxindex(if_jump), .OPCode(OPCode));

  doublemux32 mux(.din_0(cat), .din_1(alu_output), .sel(if_jump), .mux_out(new_PC));
endmodule

module  quadmux32(
input[31:0] din_0, // Mux first input
input[31:0] din_1, // Mux second input
input[31:0] din_2, // Mux thirdinput
input[31:0] din_3, // Mux fourth input
input[1:0] sel, // Select input
output reg[31:0] mux_out // Mux output
);
  always @ (sel or din_0 or din_1 or din_2 or din_3)
  begin
   if (sel == 2'b00)
       mux_out = din_0;
   else if (sel == 2'b01)
       mux_out = din_1;
   else if (sel == 2'b10)
       mux_out = din_2;
   else
       mux_out = din_3;
   end
endmodule

module PC_call
(
output[31:0] new_PC,
input[31:0]	last_PC,
input[31:0] BEQ_in,
input[31:0] BNE_in,
input[31:0] JR_in,
input zeroFlag,
input overflow,
input[5:0] OPCode,
input[5:0] funct
);
  wire[1:0] muxindex, temp_muxindex;
  PC_OP_Decode decode1(.muxindex(temp_muxindex), .OPCode(OPCode), .funct(funct));
  PC_Flag_Status decode2(.OPout(muxindex), .OPin(temp_muxindex), .zeroFlag(zeroFlag), .overflow(overflow));

  quadmux32 mux(.din_0(last_PC), .din_1(BEQ_in), .din_2(BNE_in), .din_3(JR_in), .sel(muxindex), .mux_out(new_PC));

endmodule
