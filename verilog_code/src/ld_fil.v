/*
    ld_fil is the module for filter bank. It loads the filter values to all the PEs
    clk : input clock signal
    en : input enable signal which indicates to start loading
    p : input, no of different filters processes by a PE
    q : input, no of different channels processed by a PE
    r : input, no of different channels processed by PE sets
    t : input, no of different filters processed by PE sets
    R : input, no of rows in the filter
    S : input, no of colums in the filter
    w0,w1,......w11 : output wires connecting the filter bank to the 2-D PE array. These wires load the filter vaules into the PEs
*/
module ld_fil (clk, en, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, p, q, r, t, R, S);

  input               clk;
  input               en;
  input      [4:0]    p,q,r,t,R,S;
  wire       [4:0]    filt_size;
  output reg [15:0]   w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11; // 12 output wires to the 12 rows of the PE array


  assign filt_size = R * S;

  reg [15:0] out_wires [11:0];
  reg [15:0] filter [1000:0]; // 1-D array, filter buffer memory

  reg [9:0] count   = 10'd0;
  reg [9:0] count_t = 10'd0; // To keep record of parameter t traversed
  reg [9:0] count_r = 10'd0; // To keep record of parameter r traversed
  reg [9:0] count_p = 10'd0; // To keep record of parameter p traversed
  reg [9:0] count_q = 10'd0; // To keep record of parameter q traversed
  reg [9:0] count_S = 10'd0; // To keep record of parameter S traversed
  reg [9:0] count_R = 10'd0; // To keep record of the filter row being assigned

  always @(posedge clk) begin // To assign values to the wires according the interleaving
    if (en) begin
      count_t = 0;
      count_r = 0;
      count_R = 0;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
         w0 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 0
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
         w1 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 1
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
         w2 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 2
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
         w3 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 3
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w4= filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 4
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w5= filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 5
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w6= filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 6
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w7 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 7
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w8 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 8
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w9 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 9
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w10= filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 10
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end
      if (count_t*r + count_r < t*r) begin
        w11 = filter[count_t*p*q*r*filt_size+count_p*q*r*filt_size+count_r*q*filt_size+count_q*filt_size+count_R*S+count_S]; // 11
      end
      count_R = count_R + 1;

      if (count_R == R) begin
        count_r = count_r + 1;
        count_R = 0;
      end
      if (count_r == r) begin
        count_t = count_t+1;
        count_r = 0;
      end

      count_p = count_p+1;
      if (count_p == p) begin
        count_p = 0;
        count_q = count_q+1;
      end
      if (count_q == q) begin
        count_q = 0;
        count_S = count_S+1;
      end
    end
    else begin
      count_p = 0;
      count_q = 0;
      count_S = 0;
    end
  end

endmodule
