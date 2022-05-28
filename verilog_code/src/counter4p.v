/*  Digital Counter used in PE_control
    to change the address of ifmap spad
    after all the filters(p) have processed
    over the ifmap value at that address
    It has a negative reset
*/

module counter4p (  clk,
                    rstn,              // clock to see the 4p time to change the address of the ifmap
                    out);

  // This always block will be triggered at the falling edge of clk (0->1)
  // Once inside this block, it checks if the reset is 0, if yes then change out to zero
  // If reset is 1, then design should be allowed to count up, so increment counter

  output reg[6:0] out = 7'b0000000;
  input clk;
  input rstn;
  always @ (negedge clk) begin
    if (! rstn)
      out <= 0;
    else
      out <= out + 1;
  end
endmodule
