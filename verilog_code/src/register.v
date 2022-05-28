/* Normal digital design register to delay the signal
     by one clock cycle
*/
module register(in0, clk,out);

    input in0;
    input clk;
    output out;

    reg r1;

    assign out= r1;

    always@(negedge clk)
    begin
        r1 <= in0;
    end

endmodule
