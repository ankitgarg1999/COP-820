/* The Sum module used inside the PE
        x: one 16bit input
        y: other 16 bit input
        sume: the sum of the signed inputs
*/
module sum(x, y, sume);
    input signed[15:0] x,y;
    output signed [15:0] sume;
    assign  sume = x+y;
endmodule
