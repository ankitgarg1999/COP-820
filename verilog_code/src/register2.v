/*
    register2 is a simple D flip flop that outputs
    the input value at every positive edge of the
    clock
    clk - input clock load_signal
    en - input to enable the register
    d - input data
    q - output data
*/
module register2 (clk,en,d,q);
  input clk,en;
  input [15:0] d;
  output reg [15:0] q;
  always @(negedge clk) begin
    if (en) begin
      q = d;
    end
  end
endmodule
