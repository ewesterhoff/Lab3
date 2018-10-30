module JalLUT
(
output reg muxindex,
input[5:0]	OPCode
);
always @(OPCode) begin
  if (OPCode == 2'b000011) begin
    muxindex <= 0; end
  else begin
    muxindex <= 1; end
  end

endmodule
