
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Delhi
// Engineer: Ankit Garg, Devang Mahesh
//
// Design Name:
// Module Name: testbench
// Project Name: Eyeriss
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

// In this Testbench, we have defined some convolutional Parameters
// Using them we have created random input features and filters
// Compared DUT with the 7 for loop Conv Soft Model
// Score the DUT Accordingly

module testbench;


    // Defining Paramters of Conv Layer
    reg CLK;
   	reg [4:0] p   = 5'd3;
   	reg [4:0] q   = 5'd2;
   	reg [4:0] S   = 5'd3;
   	reg [4:0] R   = 5'd3;
   	reg [4:0] r   = 5'd3;
   	reg [4:0] t   = 5'd4;
   	reg [15:0] H  = 16'd5;
   	reg [15:0] W  = 16'd5;


   	reg         alarm = 1'b0; // External Trigger to start Computation
    reg [15:0]  sum   = 16'd0;

    reg test = 1'b0;

    // Conv Inputs, weights and Output
    reg [15:0] filter[][][][];
    reg [15:0] ifmap[][][];
    reg [15:0] out_sum[][][];

    // In initial we use conv parameters to initialise the
    // Input, Filter and Output Sizes
    initial begin

      filter = new [p*t];

      for (int i=0;i<p*t;i=i+1) begin
        filter[i] = new [q*r];
        for (int j=0;j<q*r;j=j+1) begin
          filter[i][j] = new [R];
          for (int k=0;k<R;k=k+1) begin
            filter[i][j][k] = new [S];
          end
        end
      end

      ifmap = new [q*r];

      for (int i=0;i<q*r;i=i+1) begin
        ifmap[i] = new [H];
        for (int j=0;j<H;j=j+1) begin
          ifmap[i][j] = new [W];
        end
      end

      out_sum = new [p*t];

      for (int i=0;i<p*t;i=i+1) begin
        out_sum[i] = new [H-R+1];
        for (int j=0;j<(H-R+1);j=j+1) begin
          out_sum[i][j] = new [W-S+1];
        end
      end

    end

// outputs

// unit under test uut
  pe_array dut(.clk(CLK),.S(S) ,.R(R),.p(p),.q(q),.r(r),.t(t), .H(H), .W(W),.alarm(alarm));

  integer k = 0;
  initial begin
    CLK=1'b1;
    #5
    alarm = 1;

    #3000 $finish;
  end

  // To toggle the clock
  always begin
    #5 CLK=1'b0;#5 CLK = 1'b1;
  end

  reg d = 0;



  initial begin
    #1    // To help the size init to be done


    // We will create Random Values for Filter and input, then place it
    // at the right location inside the DUT Memory For it to access
    for (int i=0;i<150;i=i+1) begin
      dut.ld_filter.filter[i] = $random%50;
    end

    for (int i=0;i<100;i=i+1) begin
      dut.ld_feature.ifmap[i] = $random%50;
    end

    for (int i=0;i<p*t;i=i+1) begin
      for (int j=0;j<q*r;j=j+1) begin
        for (int k=0;k<R;k=k+1) begin
          for (int l=0;l<S;l=l+1) begin
            filter[i][j][k][l] = dut.ld_filter.filter[i*(q*r*R*S)+j*(R*S) + k*S + l];
          end
        end
      end
    end

    for (int i=0;i<q*r;i=i+1) begin
      for (int j=0;j<H;j=j+1) begin
        for (int k=0;k<W;k=k+1) begin
          ifmap[i][j][k] = dut.ld_feature.ifmap[i*(H*W)+j*(W)+k];
        end
      end
    end

    #2 // Verification result calculation
    // Get the expected result and store it in the out_sum variable
    // Nornal For loop Implementation of Convolution
    for (int i=0;i<p*t;i=i+1) begin
      for (int j=0;j<(H-R+1);j=j+1) begin
        for (int k=0;k<(W-S+1);k=k+1) begin
          sum = 0;
          for (int d=0;d<q*r;d=d+1) begin
            for (int e=j;e<j+R;e=e+1) begin
              for (int f=k;f<k+S;f=f+1) begin
                //$display(ifmap[d][e-j][f-k]* filter[i][d][e-j][f-k]);
                sum = sum + ifmap[d][e][f]* filter[i][d][e-j][f-k];
              end
            end
          end
          out_sum [i][j][k] = sum;
        end
      end
    end

  #2500 ;

  // Compare the two results
  for (int i=0;i<p*t;i=i+1) begin
  	for (int j=0;j<(H-R+1);j=j+1) begin
      for (int k=0;k<(W-S+1);k=k+1) begin
        d = (i/t)*p;
        //$display( i ,j,k, d+p-1-i );
        //$display(out_sum[i][j][k]);
        //$display(dut.out_psum[d+p-1-i][j*(W-S+1)+k]);
        if (out_sum[i][j][k] != dut.out_psum[d+p-1-i][j*(W-S+1)+k])  begin
          $display("Incorrect Result");
          test = 1'b1;
        end

      end
    end
  end
  if(test == 0 )
  $display("ALL Values Match !!!");
end




endmodule
