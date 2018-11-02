
`include "alu.v"
`include "lut.v"
`include "register.v"

module JAL_module
(
output[31:0] toDataW,
input[31:0]	PC,
input[31:0] toMem,
input[5:0] OPCode
);
  parameter constIncr = 32'b00000000000000000000000000000100; //4
  wire[31:0] adder_out;
  wire carryout, zero, overflow, if_jal;

  ALU alu(.result(adder_out), .carryout(carryout), .zero(zero), .overflow(overflow),
  .operandA(constIncr), .operandB(PC), .command(3'd0)); //add

  JalLUT JALTEST(.muxindex(if_jal), .OPCode(OPCode));

  doublemux32 mux(.din_0(adder_out), .din_1(toMem), .sel(if_jal), .mux_out(toDataW));

endmodule

module Jump_Calc
(
output[31:0] new_PC,
input[31:0] old_PC,
input[31:0] instruction,
input[5:0] OPCode
);
  wire if_jump;
  reg[31:0] cat;
  always @ (cat) begin
    cat = {instruction[25:0], old_PC[31:28]};
    cat = cat<<2; end

  JumpLUT JTEST(.muxindex(if_jump), .OPCode(OPCode));

  doublemux32 mux(.din_0(cat), .din_1(old_PC), .sel(if_jump), .mux_out(new_PC));
endmodule


module PC_call
(
output[31:0] new_PC,
input[31:0]	last_PC,
input[31:0] JR_in,
input zeroFlag,
input overflow,
input[31:0] instruction
);
  reg[5:0] OPCode, funct;
  
  always @ (instruction) begin
    OPCode = instruction[31:26];
    funct = instruction[5:0]; end

  wire[1:0] muxindex, temp_muxindex;
  wire[31:0] BEQ_in, BNE_in;

  PC_OP_Decode decode1(.muxindex(temp_muxindex), .OPCode(OPCode), .funct(funct));
  PC_Flag_Status decode2(.OPout(muxindex), .BEQ_in(BEQ_in), .BNE_in(BNE_in),
  .OPin(temp_muxindex), .zeroFlag(zeroFlag), .overflow(overflow), .instruction(instruction));

  quadmux32 mux(.din_0(last_PC), .din_1(BEQ_in), .din_2(BNE_in), .din_3(JR_in), .sel(muxindex), .mux_out(new_PC));

endmodule

// Actually a d flip flop
module pc_hold #(parameter N = 32)
(
	input clk,
	input[N-1:0] pc_in,
	output reg[N-1:0] pc_out
);

  initial begin
    pc_out <= 0;
  end

	always @(posedge clk) begin

    	pc_out <= pc_in;

    end
endmodule

// Adds 4 to every input, unless input comes from JR load
module pc_add_4
(
	output[31:0] new_PC,
	input[5:0] funct,
	input[31:0] last_PC
);
	wire add_select_wire;
	wire[31:0] increment;

  	wire carryout, zero, overflow;

  	parameter add_zero = 32'b00000000000000000000000000000000;
  	parameter add_four = 32'b00000000000000000000000000000100;

  	//if JUR muxindex == 0
  	add4LUT jumpornah(.muxindex(add_select_wire), .funct(funct));

  	doublemux32 mux1(.din_0(add_zero), .din_1(add_four), .sel(add_select_wire), .mux_out(increment));

	ALU alu1(.result(new_PC), .carryout(carryout), .zero(zero), .overflow(overflow),
		.operandA(increment), .operandB(last_PC), .command(3'd0)); //add

endmodule

module datapath
(
  input clk,

  input RegWr,
  input[1:0] RegDst,
  input[2:0] ALUcntrl,
  input MemWr,
  input MemToReg,
  input ALUSrc,

  input[15:0] imm16,

  input[4:0] Rd,
  input[4:0] Rt,
  input[4:0] R31,
  input[4:0] Rs,

  input[31:0] Jal_out,

  output[31:0] Op_end_result, Da,
  output Alu_zero, Alu_carryout, Alu_overflow
);

  wire[31:0] Db, Alu_bin, DataMem_out, Op_end_result, Alu_op_result, immSE;
  wire[4:0] Aw_in;
  wire Alu_zero, Alu_carryout, Alu_overflow;

  // 0 - Rd, 1 - Rt, 2 and 3 - R31 for lack of different idea
  quadmux32 #(4) AWMux (.din_0(Rd), .din_1(Rt), .din_2(R31), .
    din_3(R31), .sel(RegDst), .mux_out(Aw_in));

  regfile Reg(.Clk(clk), .RegWrite(RegWr), .WriteRegister(Aw_in),
    .ReadRegister2(Rt), .ReadRegister1(Rs), .WriteData(Jal_out),
    .ReadData2(Db), .ReadData1(Da));

  signextend SE(.short(imm16), .long(immSE));

  // 0 - Db, 1 - SE
  doublemux32 SEMux(.din_0(Db), .din_1(immSE), .sel(ALUSrc),
    .mux_out(Alu_bin));

  ALU cpuAlu(.result(Alu_op_result), .carryout(Alu_carryout),
    .zero(Alu_zero), .overflow(Alu_overflow),
    .operandA(Da), .operandB(Alu_bin), .command(ALUcntrl));

  datamemory #(28675) Mem(.clk(clk), .dataOut(DataMem_out), .address(Alu_op_result),
    .writeEnable(MemWr), .dataIn(Db));

  doublemux32 MemRegMux(.din_0(Alu_op_result), .din_1(DataMem_out),
    .sel(MemToReg), .mux_out(Op_end_result));


endmodule

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

// Text menory size: 1024
// Datapath memory size: 4096-1024 = 3072
module datamemory
#(
    parameter depth = 1024,
    parameter offset = 0
)
(
    input                     clk,
    output[31:0]            dataOut,
    input [31:0]            address,
    input               writeEnable,
    input [31:0]             dataIn
);
    // convert address from mips thing to verilog index 0,4,8 to 0,1,2
    // 0x1000 to incoming address. add offset parameter

    reg [31:0] memory [depth-1:0];
    wire div4_address = address << 2;     // divide by 4
    wire[31:0] shift_address; // use the ALU to shift the address as necessary (shift if accessing datamemory) 
    wire z, c, o; // for alu

    ALU alu(.result(shift_address), .carryout(c), .zero(z), .overflow(o),
  .operandA(div4_address), .operandB(offset), .command(3'd1)); //sub

    assign dataOut = memory[shift_address];

    always @(posedge clk) begin
        if(writeEnable)begin
            memory[shift_address] <= dataIn;
            end
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
