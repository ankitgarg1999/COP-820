/* Digital Counter used in PE_control
    to count total cycles to completion of all the
    psums of the PE

    It has a negative reset
*/

module counter2 (   clk,               // To count for completion and total work 4*S*P*Q cycles
                    rstn,
                    out);

  // This always block will be triggered at the falling edge of clk (0->1)
  // Once inside this block, it checks if the reset is 0, if yes then change out to zero
  // If reset is 1, then design should be allowed to count up, so increment counter

  output reg[9:0] out = 9'b000000000;
  input clk;
  input rstn;
  always @ (negedge clk) begin
    if (! rstn)
      out <= 0;
    else
      out <= out + 1;
  end

endmodule
