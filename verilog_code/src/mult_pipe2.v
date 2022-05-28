/*
    The two stage multiplier used inside the PE
    clk: the clock
    a: signed 16bit input
    b: other signed 16bit input
    pdt: the trimmed 16bit product
*/
module mult_pipe2 #(
    parameter SIZE = 16,
    parameter LVL = 2

)
( a, b, clk, pdt) ;
/*
* parameter 'SIZE' is the width of multiplier/multiplicand;.Application Notes
* parameter '' is the intended number of stages of the
* pipelined multiplier;
* which is typically the smallest integer greater than or equal
* to base 2 logarithm of 'SIZE'
*/

    input signed [SIZE-1 : 0] a;
    input signed [SIZE-1 : 0] b;
    input                     clk;
    output wire  [SIZE-1 : 0] pdt;

    integer i;

    wire [2*SIZE -1 :0] a_b;
    assign a_b = a * b ;

    // To Move the product to mid
    // before putting it at output, acts as a stall
    // Hence Non Blocking Used
    always @(negedge clk) begin
        mid <= a_b;
    end

    reg [SIZE -1:0] mid;

    assign pdt = mid;

endmodule // pipelined_multiplier
