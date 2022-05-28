/*
    This module is for ifmap bank. It loads the values into ifmap spads of the PEs through 25 output wires.
    clk : input clock signal
    en : input enable signal indicating to start loading
    S : input, no of columns in filter
    R : input, no of rows in filter
    q : input, no of different channels processed by a PE
    r : input, no of different channels processed by PE sets
    H : input, height of the feature map
    W : input, width of the feature map
    w0,w1 .....w24 : output wires connecting feature map bank to the 2-D pe array diagonally
*/
module ld_ifmap (   clk,
                    en,
                    w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,
                    S,
                    r,
                    R,
                    q,
                    H,
                    W);

    input           clk;
    input           en;
    input [15:0]    H,W;
    input [4:0]     r,q;
    input [4:0]     S;
    input [4:0]     R;

    reg [9:0] count   = 10'd0; // base value of the sliding window of the ifmap
    reg [9:0] count2  = 10'd0;
    reg [9:0] count_q = 10'd0; // to keep record of parameter q traversed
    reg [9:0] count_s = 10'd0; // to keep record of parameter s traversed
    reg [9:0] count_r = 10'd0; // to keep record of parameter r traversed
    reg [9:0] temp    = 10'd0;

    // 25 output wires assigned to the PE-2D array diagonally.
    output reg [15:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24;

    reg [15:0]  ifmap[10000:0];

    reg [3:0]   pe_set_base = 4'b0000; // PE set base value which gets incremented by r after each q*s cycles

    always @(posedge en) begin

        count       = count + 1;
        pe_set_base = 4'b0000;

        if (count == W-S+1)
            count = 0;
    end

    always @(posedge clk) begin
        if (en) begin

            // we assign all the 25 wires according to the division of different PE sets
            // declare temp and count2
            count2  = 4'b0000;
            temp    = pe_set_base;

            if (temp == 0) begin
                if (count2<H) begin

                    w0      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w0      = 0;
            end
            else begin
                w0 = 0;
            end

            if (temp == 1) begin
                if (count2<H) begin
                    w1      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w1      = 0;
            end
            else begin
                w1 = 0;
            end

            if (temp == 2) begin
                if (count2<H) begin
                     w2     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w2      = 0;
            end
            else begin
                w2 = 0;
            end

            if (temp == 3) begin
                if (count2<H) begin
                    w3      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w3      = 0;
            end
            else begin
                w3 = 0;
            end

            if (temp == 4) begin
                if (count2<H) begin
                    w4      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w4      = 0;
            end
            else begin
                w4 = 0;
            end

            if (temp == 5) begin
                if (count2<H) begin
                    w5      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w5      = 0;
            end
            else begin
                w5 = 0;
            end

            if (temp == 6) begin
                if (count2<H) begin
                    w6      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w6      = 0;
            end
            else begin
                w6 = 0;
            end

            if (temp == 7) begin
                if (count2<H) begin
                    w7      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w7      = 0;
            end
            else begin
                w7 = 0;
            end

            if (temp == 8) begin
                if (count2<H) begin
                    w8      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w8      = 0;
            end
            else begin
                w8 = 0;
            end

            if (temp == 9) begin
                if (count2<H) begin
                    w9      = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w9      = 0;
            end
            else begin
                w9 = 0;
            end

            if (temp == 10) begin
                if (count2<H) begin
                    w10     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w10 = 0;
            end
            else begin
                w10 = 0;
            end

            if (temp == 11) begin
                if (count2<H) begin
                    w11     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w11 = 0;
            end
            else begin
                w11 = 0;
            end

            if (temp == 12) begin
                if (count2<H) begin
                    w12     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w12     = 0;
            end
            else begin
                w12 = 0;
            end

            if (temp == 13) begin
                if (count2<H) begin
                    w13     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w13     = 0;
            end
            else begin
                w13 = 0;
            end

            if (temp == 14) begin
                if (count2<H) begin
                    w14     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w14     = 0;
            end
            else begin
                w14 = 0;
            end

            if (temp == 15) begin
                if (count2<H) begin
                    w15     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w15     = 0;
            end
            else begin
                w15 = 0;
            end

            if (temp == 16) begin
                if (count2<H) begin
                    w16     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w16     = 0;
            end
            else begin
                w16 = 0;
            end

            if (temp == 17) begin
                if (count2<H) begin
                    w17     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w17     = 0;
            end
            else begin
                w17 = 0;
            end

            if (temp == 18) begin
                if (count2<H) begin
                    w18     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w18     = 0;
            end
            else begin
                w18 = 0;
            end

            if (temp == 19) begin
                if (count2<H) begin
                    w19     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w19     = 0;
            end
            else begin
                w19 = 0;
            end

            if (temp == 20) begin
                if (count2<H) begin
                    w20     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w20     = 0;
            end
            else begin
                w20         = 0;
            end

            if (temp == 21) begin
                if (count2<H) begin
                    w21     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w21     = 0;
            end
            else begin
                w21 = 0;
            end

            if (temp == 22) begin
                if (count2<H) begin
                    w22     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w22     = 0;
            end
            else begin
                w22 = 0;
            end

            if (temp == 23) begin
                if (count2<H) begin
                    w23     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w23     = 0;
            end
            else begin
                w23 = 0;
            end

            if (temp == 24) begin
                if (count2<H) begin
                    w24     = ifmap[count_r*q*H*W + count_q*W*H + count2*W + count_s + count];
                    count2  = count2+1;
                    temp    = temp+1;
                end
                else
                    w24 = 0;
            end
            else begin
                w24 = 0;
            end

            count_q = count_q+1;
            if (count_q == q) begin
                count_q = 0;
                count_s = count_s+1;
            end

            if (count_s == S) begin
                count_s = 0;
                count_r = count_r+1;
                pe_set_base = pe_set_base+R;
            end

            if (count_r == r) begin
                count_r = 0;
            end

        end

        else begin
            count_q = 4'b0000; // reset all these parameters when enable is turned off.
            count_r = 4'b0000;
            count_s = 4'b0000;
        end
    end
endmodule
