
`include "alu.v"
`include "lut.v"
`include "functionality_support.v"

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

// Actually a d flip flop
module pc_hold #(parameter N = 32)
(	
	input clk,
	input[N-1:0] pc_in,
	output reg[N-1:0] pc_out
);
	always @(posedge clk) begin
			
    	pc_out <= pc_in;
    	
    end
endmodule

// Adds 4 to every input, unless input comes from JR load
module pc_add_4
(
	output[31:0] new_PC,
	input[5:0] funct,
	input[31:0] last_PC
);
	wire add_select_wire;
	wire[31:0] increment;

  	wire carryout, zero, overflow;

  	parameter add_zero = 32'b00000000000000000000000000000000;
  	parameter add_four = 32'b00000000000000000000000000000100;

  	//if JUR muxindex == 0
  	add4LUT jumpornah(.muxindex(add_select_wire), .funct(funct));

  	doublemux32 mux1(.din_0(add_zero), .din_1(add_four), .sel(add_select_wire), .mux_out(increment));

	ALU alu1(.result(new_PC), .carryout(carryout), .zero(zero), .overflow(overflow),
		.operandA(increment), .operandB(last_PC), .command(3'd0)); //add

endmodule
