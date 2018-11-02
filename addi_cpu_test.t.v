`include "cpu.v"

module addi_cpu_test ();
	reg clk;

	initial clk = 1;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("addi_waves.vcd");
    	$dumpvars();

    	$readmemh("asm_tests_EandM/addi.text.hex", dut.InstructionMemory.memory, 0);


    	#2000
    	$finish();
    end
    

endmodule