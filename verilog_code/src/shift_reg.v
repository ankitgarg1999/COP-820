/*
    shift_reg has been implemented which loads value one by one and stores in different outputs
    It takes data from single line and has 24 output ports because 24 is the maximum value that p can take
    clk : input clock load_signal
    complete : input to indicating to stop reading values
    output_done :
    D : input line which brings data into the module
    p : input, no of different filters processes by a PE
    q0,q1 ..... q23 : 24 output wires, which store the values of different filters calculated by the PE
*/
module shift_reg (clk,complete,output_done,D,p,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23);
  input clk,complete;
  input [15:0] D;
  input [4:0] p;
  output [15:0] q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23;
  output reg output_done = 1'b0;

  //reg [3:0] d [23:0]; // input wire of the 24 registers
  wire [15:0] q [23:0]; // output wire of the 24 registers

  assign q0 = q[0];
  assign q1 = q[1];
  assign q2 = q[2];
  assign q3 = q[3];
  assign q4 = q[4];
  assign q5 = q[5];
  assign q6 = q[6];
  assign q7 = q[7];
  assign q8 = q[8];
  assign q9 = q[9];
  assign q10 = q[10];
  assign q11 = q[11];
  assign q12 = q[12];
  assign q13 = q[13];
  assign q14 = q[14];
  assign q15 = q[15];
  assign q16 = q[16];
  assign q17 = q[17];
  assign q18 = q[18];
  assign q19 = q[19];
  assign q20 = q[20];
  assign q21 = q[21];
  assign q22 = q[22];
  assign q23 = q[23];

  reg en = 0;
  //wire en;
  reg [4:0] count = 5'd0;

  always@(negedge complete)
  begin

    en = 1'b1;
  end

  always@(posedge complete)
  begin
     count = 0 ;
  end

  always@(posedge clk)
  begin
    if(en == 1 )
    begin
        count = count + 1;
        if (count ==  p+1)
            en = 0;
    end

  end
  reg [3:0] count2 = 4'b0;

  always@(negedge en)
  begin
    output_done=1'b1;
  end

  always@(posedge clk)
  begin
    if(output_done ==1)
    begin
      if(count2<p)
          count2= count2+1;
      else
      begin
          count2=0;
          output_done = 0;
      end
    end
  end



  register2 r0(.clk(clk),.en(en),.d(D),.q(q[0]));


  genvar r;
  generate
    for (r=1;r<24;r=r+1) begin
      register2 rx (.clk(clk),.en(en),.d(q[r-1]),.q(q[r]));
    end
  endgenerate

endmodule
