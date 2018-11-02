`include "cpu.v"

module mirror_cpu_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("mirror_waves.vcd");
    	$dumpvars();

    	$readmemh("asm_tests_EandM/asm_mirror.text.hex", dut.InstructionMemory.memory, 0);
			$readmemh("asm_tests_EandM/asm_mirror.data.hex", dut.cpuer.Mem.memory, 0);

    	#2000
    	$finish();
    end


endmodule
