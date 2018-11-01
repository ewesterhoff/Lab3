`include "module_blocks.v"

module test_();
	reg[15:0] input_addr;
	wire[31:0] output_addr;

	signextend flippy (.short(input_addr), .long(output_addr));

	initial begin
		
		input_addr = 16'b00000000000000000; # 1000

		$display("output address %b", output_addr);
		$finish;

	end

endmodule