`include "cpu.v"

module CPUtest();
  reg clk;
  initial clk=0;
  always #10 clk = !clk;

  cpu dut(.clk(clk));

  initial begin


    // Load CPU memory from (assembly) dump file
    $readmemh("asm_tests_E&M/addi.text.hex", dut.cpuer.Mem.memory, 0, 32'h0FFC);
    $readmemh("asm/addi.data.hex", dut.cpuer.Mem.memory, 32'h2000, 32'h3FFF);

    $dumpfile("cpu_test.vcd");
    $dumpvars();

  	// End execution after some time delay
  	#2000 $finish();

  end

endmodule
