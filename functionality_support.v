

// Sign extend for the datapath
module signextend
(
	input [15:0] short, 
	output reg [31:0] long
);

	always @ (short) begin
		long = {{16{short[15]}}, short };
	end

endmodule


// ------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
// ------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 32,
    parameter depth         = 32,//2**addresswidth,
    parameter width         = 32
)
(
    input 		                clk,
    output reg [width-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [width-1:0]           dataIn
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)begin
            memory[address] <= dataIn;
            end
        dataOut <= memory[address];
    end

endmodule

module  doublemux32(

input[31:0] din_0, // Mux first input
input[31:0] din_1, // Mux Second input
input sel, // Select input
output reg[31:0] mux_out // Mux output
);
always @ (sel or din_0 or din_1)
begin
 if (sel == 1'b0) begin
     mux_out = din_0;
 end else begin
     mux_out = din_1 ;
 end
 end

endmodule


module  quadmux32 #(parameter N = 31)
(
	
input[N:0] din_0, // Mux first input
input[N:0] din_1, // Mux second input
input[N:0] din_2, // Mux thirdinput
input[N:0] din_3, // Mux fourth input
input[1:0] sel, // Select input
output reg[N:0] mux_out // Mux output
);
always @ (sel or din_0 or din_1 or din_2 or din_3)
begin
 if (sel == 2'b00)
     mux_out = din_0;
 else if (sel == 2'b01)
     mux_out = din_1;
 else if (sel == 2'b10)
     mux_out = din_2;
 else
     mux_out = din_3;
 end
endmodule
