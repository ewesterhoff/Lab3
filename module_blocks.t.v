`timescale 1 ns / 1 ps
`include "module_blocks.v"
/*
module testDoubleMux();
    reg[31:0] din_0, din_1;
    reg sel;
    wire[31:0] mux_out;

    doublemux32 mux(.din_0(din_0), .din_1(din_1), .sel(sel), .mux_out(mux_out));

    initial begin
        $dumpfile("doubleMux.vcd");
    	$dumpvars(0, mux);

    #50
	din_0 = 0;
	din_1 = 1;
  sel = 0; #50
  sel = 1; #50
	$dumpflush;
	$finish;
	end
endmodule

*/

module testQuadMux();
    reg[31:0] din_0, din_1, din_2, din_3;
    reg[1:0] sel;
    wire[31:0] mux_out;

    quadmux32 mux(.din_0(din_0), .din_1(din_1), .din_2(din_2), .din_3(din_3),
    .sel(sel), .mux_out(mux_out));

    initial begin
        $dumpfile("doubleMux.vcd");
    	$dumpvars(0, mux);

    #50
	din_0 = 34;
	din_1 = 10;
  din_2 = 77;
	din_3 = 20;
  sel = 0; #50
  sel = 1; #50
  sel = 2; #50
  sel = 3; #50
	$dumpflush;
	$finish;
	end
endmodule
