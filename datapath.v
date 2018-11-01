`include "register.v"
`include "functionality_support.v"
`include "alu.v"

module datapath
(
	input clk,

	input RegWr,
	input[1:0] RegDst,
	input[2:0] ALUcntrl,
	input MemWr,
	input MemToReg,
	input ALUSrc,

	input[15:0] imm16,

	input[4:0] Rd,
	input[4:0] Rt,
	input[4:0] R31,
	input[4:0] Rs,

	input[31:0] Jal_out,

	output [31:0] Op_end_result,
	output Alu_zero, Alu_overflow
);

	wire[31:0] Da, Db, Alu_bin, DataMem_out, Op_end_result, Alu_op_result, immSE;
	wire[4:0] Aw_in;
	wire Alu_zero, Alu_carryout, Alu_overflow;

	// 0 - Rd, 1 - Rt, 2 and 3 - R31 for lack of different idea
	quadmux32 #(4) AWMux (.din_0(Rd), .din_1(Rt), .din_2(R31), .
		din_3(R31), .sel(RegDst), .mux_out(Aw_in));

	regfile Reg(.Clk(clk), .RegWrite(RegWr), .WriteRegister(Aw_in),
		.ReadRegister2(Rt), .ReadRegister1(Rs), .WriteData(Jal_out),
		.ReadData2(Db), .ReadData1(Da));

	signextend SE(.short(imm16), .long(immSE));

	// 0 - Db, 1 - SE
	doublemux32 SEMux(.din_0(Db), .din_1(immSE), .sel(ALUSrc),
		.mux_out(Alu_bin));

	ALU cpuAlu(.result(Alu_op_result), .carryout(Alu_carryout),
		.zero(Alu_zero), .overflow(Alu_overflow),
		.operandA(Da), .operandB(Alu_bin), .command(ALUcntrl));

	datamemory Mem(.clk(clk), .dataOut(DataMem_out), .address(Alu_op_result),
		.writeEnable(MemWr), .dataIn(Db));

	doublemux32 MemRegMux(.din_0(Alu_op_result), .din_1(DataMem_out),
		.sel(MemToReg), .mux_out(Op_end_result));


endmodule
