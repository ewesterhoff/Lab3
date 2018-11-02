`include "cpu.v"

module mirror_cpu_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("xoretc_waves.vcd");
    	$dumpvars();

    	$readmemh("asm_tests_EandM/xor_add_sub_slt.text.hex", dut.InstructionMemory.memory, 0);

    	#2000
    	$finish();
    end


endmodule
