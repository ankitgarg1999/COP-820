/*  asynchronous Digital Counter used in pe_array_control
    to count p*q cycles taken to load data into ifmap of one
    PE set. It helps to shift to next PE set in the PE array
    It has a negative reset
*/

module counter22 (  clk,
                    rstn,
                    out);

  output reg[3:0] out = 4'b0000;
  input clk;
  input rstn;

  always @ (negedge clk) begin
    if(rstn)
      out <= out + 1;
    else
        out = 4'h0;
  end

  always @(*)
  begin
    if(! rstn)
        out =4'b0000;
  end

endmodule
