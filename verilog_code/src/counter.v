/* Digital Counter used in PE_control
    to count 4 cycles for every computation step
    of PE
    It has a negative reset

*/
module counter (    clk,               // To count till 4 cycles as PE takes 4 cycle per MAC
                   rstn,               // It is negative reset
                    out);
  output reg[1:0] out = 2'b00;
  input clk;
  input rstn;

  // This always block will be triggered at the falling edge of clk (0->1)
  // Once inside this block, it checks if the reset is 0, if yes then change out to zero
  // If reset is 1, then design should be allowed to count up, so increment counter
  always @ (negedge clk) begin
    if (! rstn)
      out <= 0;
    else
      out <= out + 1;
  end
endmodule
