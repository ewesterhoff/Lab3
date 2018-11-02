
`include "module_blocks.v"

module cpu
(
	input clk
);

	wire[31:0] instruction, JR_in;
	wire[5:0] OPCode, funct;
	wire RegWE, MemWE, memToReg, ALUsrc, useReg31;
	wire zeroFlag, overflow;
	wire[31:0] toDataW, toMem;
	wire[31:0] PC_fromCall, PC_preAdd, PC_preJump, PC;
	wire[1:0] RegDst;
    wire[2:0] ALUcntrl;
	wire[4:0] Rd, Rt, R31, Rs;
	wire[15:0] imm16;

	datamemory #(4096) InstructionMemory(.clk(clk), .dataOut(instruction), .address(PC_preAdd), .writeEnable(1'b0),
	.dataIn(0));

	instrDecode instructionDecoder(.instruction(instruction), .OPCode(OPCode), .funct(funct),
	.RegWE(RegWE), .MemWE(MemWE), .memToReg(memToReg), .ALUsrc(ALUsrc), .RegDst(RegDst),.useReg31(useReg31),
	.ALUcntrl(ALUcntrl), .imm16(imm16), .Rd(Rd), .Rt(Rt), .R31(R31), .Rs(Rs));

	PC_call pccaller(.new_PC(PC_fromCall), .last_PC(PC), .JR_in(JR_in), .zeroFlag(zeroFlag),
	.overflow(overflow), .instruction(instruction));

	pc_hold pcholder(.clk(clk), .pc_in(PC_fromCall), .pc_out(PC_preAdd));

	pc_add_4 pcadd4(.new_PC(PC_preJump), .funct(funct), .last_PC(PC_preAdd));

	Jump_Calc jumpcheck(.new_PC(PC), .old_PC(PC_preJump), .instruction(instruction), .OPCode(OPCode));

	JAL_module jallogic(.toDataW(toDataW), .PC(PC), .toMem(toMem), .OPCode(OPCode));

	datapath cpuer(.clk(clk), .RegWr(RegWE), .RegDst(RegDst), .ALUcntrl(ALUcntrl), .MemWr(MemWE), .useReg31(useReg31),
	.MemToReg(memToReg), .ALUSrc(ALUsrc), .imm16(imm16), .Rd(Rd), .Rt(Rt), .R31(R31), .Rs(Rs), .Da(JR_in),
	.Jal_out(toDataW), .Op_end_result(toMem), .Alu_zero(zeroFlag), .Alu_overflow(overflow));


endmodule
