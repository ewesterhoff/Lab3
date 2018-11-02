// Structural register from HW4//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	    // Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

	wire [31:0] RegSelect;
	decoder1to32 decode (.enable(RegWrite), .address(WriteRegister), .out(RegSelect));

	wire [31:0] R0;
	wire [31:0] R1;
	wire [31:0] R2; 
	wire [31:0] R3; 
	wire [31:0] R4; 
	wire [31:0] R5; 
	wire [31:0] R6; 
	wire [31:0] R7; 
	wire [31:0] R8; 
	wire [31:0] R9;
	wire [31:0] R10;
	wire [31:0] R11;
	wire [31:0] R12; 
	wire [31:0] R13; 
	wire [31:0] R14; 
	wire [31:0] R15; 
	wire [31:0] R16; 
	wire [31:0] R17; 
	wire [31:0] R18; 
	wire [31:0] R19;
	wire [31:0] R20;
	wire [31:0] R21;
	wire [31:0] R22; 
	wire [31:0] R23; 
	wire [31:0] R24; 
	wire [31:0] R25; 
	wire [31:0] R26; 
	wire [31:0] R27; 
	wire [31:0] R28; 
	wire [31:0] R29;
	wire [31:0] R30;
	wire [31:0] R31; 
	
	register32zero r0(.d(WriteData), .clk(Clk), .wrenable(RegSelect[0]), .q(R0));
	register32 r1(.d(WriteData), .clk(Clk), .wrenable(RegSelect[1]), .q(R1));
	register32 r2(.d(WriteData), .clk(Clk), .wrenable(RegSelect[2]), .q(R2));
	register32 r3(.d(WriteData), .clk(Clk), .wrenable(RegSelect[3]), .q(R3));
	register32 r4(.d(WriteData), .clk(Clk), .wrenable(RegSelect[4]), .q(R4));
	register32 r5(.d(WriteData), .clk(Clk), .wrenable(RegSelect[5]), .q(R5));
	register32 r6(.d(WriteData), .clk(Clk), .wrenable(RegSelect[6]), .q(R6));
	register32 r7(.d(WriteData), .clk(Clk), .wrenable(RegSelect[7]), .q(R7));
	register32 r8(.d(WriteData), .clk(Clk), .wrenable(RegSelect[8]), .q(R8));
	register32 r9(.d(WriteData), .clk(Clk), .wrenable(RegSelect[9]), .q(R9));
	register32 r10(.d(WriteData), .clk(Clk), .wrenable(RegSelect[10]), .q(R10));
	register32 r11(.d(WriteData), .clk(Clk), .wrenable(RegSelect[11]), .q(R11));
	register32 r12(.d(WriteData), .clk(Clk), .wrenable(RegSelect[12]), .q(R12));
	register32 r13(.d(WriteData), .clk(Clk), .wrenable(RegSelect[13]), .q(R13));
	register32 r14(.d(WriteData), .clk(Clk), .wrenable(RegSelect[14]), .q(R14));
	register32 r15(.d(WriteData), .clk(Clk), .wrenable(RegSelect[15]), .q(R15));
	register32 r16(.d(WriteData), .clk(Clk), .wrenable(RegSelect[16]), .q(R16));
	register32 r17(.d(WriteData), .clk(Clk), .wrenable(RegSelect[17]), .q(R17));
	register32 r18(.d(WriteData), .clk(Clk), .wrenable(RegSelect[18]), .q(R18));
	register32 r19(.d(WriteData), .clk(Clk), .wrenable(RegSelect[19]), .q(R19));
	register32 r20(.d(WriteData), .clk(Clk), .wrenable(RegSelect[20]), .q(R20));
	register32 r21(.d(WriteData), .clk(Clk), .wrenable(RegSelect[21]), .q(R21));
	register32 r22(.d(WriteData), .clk(Clk), .wrenable(RegSelect[22]), .q(R22));
	register32 r23(.d(WriteData), .clk(Clk), .wrenable(RegSelect[23]), .q(R23));
	register32 r24(.d(WriteData), .clk(Clk), .wrenable(RegSelect[24]), .q(R24));
	register32 r25(.d(WriteData), .clk(Clk), .wrenable(RegSelect[25]), .q(R25));
	register32 r26(.d(WriteData), .clk(Clk), .wrenable(RegSelect[26]), .q(R26));
	register32 r27(.d(WriteData), .clk(Clk), .wrenable(RegSelect[27]), .q(R27));
	register32 r28(.d(WriteData), .clk(Clk), .wrenable(RegSelect[28]), .q(R28));
	register32 r29(.d(WriteData), .clk(Clk), .wrenable(RegSelect[29]), .q(R29));
	register32 r30(.d(WriteData), .clk(Clk), .wrenable(RegSelect[30]), .q(R30));
	register32 r31(.d(WriteData), .clk(Clk), .wrenable(RegSelect[31]), .q(R31));

	
	mux32to1by32 mux1(ReadData1, ReadRegister1, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, 
			R10, R11, R12, R13, R14, R15, R16, R17, R18, R19, R20, 
			R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31);

	mux32to1by32 mux2(ReadData2, ReadRegister2, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, 
			R10, R11, R12, R13, R14, R15, R16, R17, R18, R19, R20, 
			R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31);

endmodule

// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule

module register32
(
output reg [31:0]	q,
input [31:0]		d,
input		wrenable,
input		clk
);

	reg [5:0] counter;

	always @(posedge clk) begin
        if(wrenable) begin
	        for (counter = 0; counter < 32; counter = counter + 1) 
	        	q[counter] <= d[counter];
        end
    end

endmodule

module register32zero
(
output reg [31:0]	q,
input [31:0]		d,
input		wrenable,
input		clk
);

	reg [5:0] counter;

	always @(posedge clk) begin
        for (counter = 0; counter < 32; counter = counter + 1)
        	q[counter] <= 1'b0;
    end

endmodule

// 32:1 MUX
module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);

	assign out = inputs[address];

endmodule

// 2-layer MUX
module mux32to1by32
(
output[31:0]  out,
input[4:0]    address,
input[31:0]   input0, input1, input2, input3, input4, input5, input6, input7, input8, input9,
input[31:0]	  input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, 
input[31:0]	  input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, 
input[31:0]	  input30, input31
);

  wire[31:0] mux[31:0];			// Create a 2D array of wires
  assign mux[0] = input0;
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;	
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;	
  assign mux[30] = input30;
  assign mux[31] = input31;

  assign out = mux[address];	// Connect the output of the array

endmodule

// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address; 

endmodule

