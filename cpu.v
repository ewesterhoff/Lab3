`include "reg_alu_dm.v"
`include "module_blocks"

module cpu 
(
	input clk
);	

	wire[31:0] old_pc;
	wire{31:0} new_pc;
	
	datamemory InstructionMemory(.clk(clk), .writeEnable(0),
		.dataIn(old_pc), .dataOut(new_pc));

	... instruction decode thing...

	


endmodule