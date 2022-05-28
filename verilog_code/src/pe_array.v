/*
    The main module
    Its based on the fact that we assume that loading from DRAM to Memory Banks
    have been done. So we need a master interupt signal to start work of the complete
    array.

    alarm: external interupt
*/
module pe_array(clk,S,R,p,q,r,t,H,W,alarm);
    input clk;
    input [4:0] S;
    input [4:0] R;
    input [4:0] p;
    input [4:0] q;
    input [4:0] r;
    input [4:0] t;
    input [15:0] H,W;
    input alarm;





    reg  [4:0]  add1_ifm = 5'b00000;
    wire [11:0] load;
    wire [11:0] load2;
    wire [11:0] load3;
    wire [10:0] mux_sel;
    wire        start;
    wire        complete[11:0][13:0];
    wire        output_done[11:0][13:0];

    pe_array_control parray(.clk(clk), .complete(complete[0][0]), .load_signal(load),.load_signal2(load2),.load_signal3(load3),.start(start),.mux_sel(mux_sel),.p(p),.q(q),.t(t),.r(r),.R(R), .S(S),.H(H),.W(W),.alarm(alarm));

    always @(negedge load) // check for negative
    begin
        add1_ifm <= add1_ifm + 1;

    end

    //input reg [15:0] filt_row_size, filt_col_size, ifmap_col_size, ifmap_row_size;
    reg [15:0] filt [11:0][11:0];
    reg [15:0] ifmap [11:0][11:0];



    wire [15:0] filt_con  [11:0];           // Horizontal Connection to the Filter  Final Outer Connection
    wire [15:0] ifmap_con [24:0];          // Horizontal Connection to ifmap

    wire [15:0] ifmapw  [11:0][13:0];       // Per pe connections
    wire [15:0] filtw   [11:0][13:0];
    wire [15:0] ipsumw  [11:0][13:0];
    wire [15:0] opsumw  [11:0][13:0];

    wire [15:0] q0  [11:0][13:0];            // Connections of output shift reg
    wire [15:0] q1  [11:0][13:0];
    wire [15:0] q2  [11:0][13:0];
    wire [15:0] q3  [11:0][13:0];
    wire [15:0] q4  [11:0][13:0];
    wire [15:0] q5  [11:0][13:0];
    wire [15:0] q6  [11:0][13:0];
    wire [15:0] q7  [11:0][13:0];
    wire [15:0] q8  [11:0][13:0];
    wire [15:0] q9  [11:0][13:0];
    wire [15:0] q10 [11:0][13:0];
    wire [15:0] q11 [11:0][13:0];
    wire [15:0] q12 [11:0][13:0];
    wire [15:0] q13 [11:0][13:0];
    wire [15:0] q14 [11:0][13:0];
    wire [15:0] q15 [11:0][13:0];
    wire [15:0] q16 [11:0][13:0];
    wire [15:0] q17 [11:0][13:0];
    wire [15:0] q18 [11:0][13:0];
    wire [15:0] q19 [11:0][13:0];
    wire [15:0] q20 [11:0][13:0];
    wire [15:0] q21 [11:0][13:0];
    wire [15:0] q22 [11:0][13:0];
    wire [15:0] q23 [11:0][13:0];

    wire out_re   [11:0][13:0];
    wire out_we   [11:0][13:0];
    wire out_res  [11:0][13:0];

    wire [15:0] mux_inp0  [10:0][13:0];
    wire [15:0] mux_inp1  [10:0][13:0];
    wire [15:0] mux_out   [10:0][13:0];
    reg         filter_en [11:0][13:0];
    reg         ifmap_en  [11:0][13:0];

    genvar x;
    genvar y;

    generate
      for (y=0; y<12;y=y+1) begin
        for (x=0;x<14;x=x+1) begin
          pe pe_x_y (.ifmap(ifmapw[y][x]),.filt(filtw[y][x]),.ipsum(mux_out[y][x]),.opsum(opsumw[y][x]),.clk(clk),.S(S),.load(load[y]),.load2(load2[y]),.load3(load3[y]),.P(p),.Q(q),.start(start),.complete(complete[y][x])); // add start
                if (y<11) begin
                    mux2X1 mux_x_y (.in0(mux_inp0[y][x]),.in1(mux_inp1[y][x]),.sel(mux_sel[y]),.out(mux_out[y][x])); // mux_inp1[y][x] instead of 16'h
                end
            shift_reg shift_out ( .clk(clk),
                                  .complete(complete[y][x]),
                                  .output_done(output_done[y][x]),
                                  .D(opsumw[y][x]),
                                  .p(p),
                                  .q0(q0[y][x]),
                                  .q1(q1[y][x]),
                                  .q2(q2[y][x]),
                                  .q3(q3[y][x]),
                                  .q4(q4[y][x]),
                                  .q5(q5[y][x]),
                                  .q6(q6[y][x]),
                                  .q7(q7[y][x]),
                                  .q8(q8[y][x]),
                                  .q9(q9[y][x]),
                                  .q10(q10[y][x]),
                                  .q11(q11[y][x]),
                                  .q12(q12[y][x]),
                                  .q13(q13[y][x]),
                                  .q14(q14[y][x]),
                                  .q15(q15[y][x]),
                                  .q16(q16[y][x]),
                                  .q17(q17[y][x]),
                                  .q18(q18[y][x]),
                                  .q19(q19[y][x]),
                                  .q20(q20[y][x]),
                                  .q21(q21[y][x]),
                                  .q22(q22[y][x]),
                                  .q23(q23[y][x]));
        end
    end
  endgenerate

    // Now connect the wires.

    genvar f;
    generate
        for (f=0;f<14;f=f+1) begin
            make_zero zero_f (ipsumw[11][f]);
        end
    endgenerate

    genvar u;
    genvar ti;
    generate
        for (u=0;u<11;u=u+1) begin
            for (ti=0;ti<14;ti=ti+1) begin
                make_zero zero_u (mux_inp1[u][ti]);
                assign mux_inp0[u][ti] = opsumw[u+1][ti];
                assign ipsumw[u][ti] = mux_out [u][ti];
            end
        end
    endgenerate

    genvar i;
    genvar j;
    generate
    for (i = 0;i<=11 ;i=i+1) begin
        for (j = 0;j<=13 ;j=j+1) begin
          assign filtw[i][j] = filt_con[i];
          if (i!=11)
              assign ipsumw[i][j] = opsumw[i+1][j];
        end
      end
    endgenerate

    // Connection for the filter rows
    wire ld_filt_en = load[0]&load3[0];
    wire ld_ifmap_en = load[0] & (load2 != 12'h000);

    ld_fil ld_filter( .clk(clk),
                      .en(ld_filt_en),
                      .w0(filt_con[0]),
                      .w1(filt_con[1]),
                      .w2(filt_con[2]),
                      .w3(filt_con[3]),
                      .w4(filt_con[4]),
                      .w5(filt_con[5]),
                      .w6(filt_con[6]),
                      .w7(filt_con[7]),
                      .w8(filt_con[8]),
                      .w9(filt_con[9]),
                      .w10(filt_con[10]),
                      .w11(filt_con[11]),
                      .p(p),
                      .q(q),
                      .r(r),
                      .t(t),
                      .R(R),
                      .S(S));

    ld_ifmap ld_feature(.clk(clk),.en(ld_ifmap_en),.w0(ifmap_con[0]),.w1(ifmap_con[1]),
                        .w2(ifmap_con[2]),.w3(ifmap_con[3]),.w4(ifmap_con[4]),.w5(ifmap_con[5]),.w6(ifmap_con[6]),
                        .w7(ifmap_con[7]),.w8(ifmap_con[8]),.w9(ifmap_con[9]),.w10(ifmap_con[10]),.w11(ifmap_con[11]),
                        .w12(ifmap_con[12]),.w13(ifmap_con[13]),.w14(ifmap_con[14]),.w15(ifmap_con[15]),
                        .w16(ifmap_con[16]),.w17(ifmap_con[17]),.w18(ifmap_con[18]),.w19(ifmap_con[19]),.w20(ifmap_con[20]),
                        .w21(ifmap_con[21]),.w22(ifmap_con[22]),.w23(ifmap_con[23]),.w24(ifmap_con[24]),.S(S),.r(r),.R(R),.q(q),.H(H),.W(W));
  // Connectionn for ifmap rows
    genvar ri;
    genvar tii;
    generate
    for (ri=0;ri<12;ri=ri+1) begin
        for (tii = ri;tii < ri+14; tii=tii+1) begin
             assign ifmapw[ri][tii-ri] = ifmap_con[tii];
        end
    end
    endgenerate

    reg e_out_psum = 1'b0;
    // output layer
    always@(*)
    begin
      e_out_psum = output_done[0][0];
    end

  reg [15:0] out_psum [20:0][100:0];

  reg [5:0] temp_t      = 6'b000000;
  reg [5:0] count_t     = 6'b000000;
  reg [5:0] count_p     = 6'b000000;
  reg [5:0] count_base  = 6'd0-3;
  reg [5:0] count_col   = 6'b000000;

  always @(negedge e_out_psum) begin
    count_base = count_base + 1;
    count_col = 0;
  end
  // Below portion - collecting the outputs from PE array and storing in appropriate format in the output feature_map bank
  always @(posedge clk) begin
    if (e_out_psum) begin
      // at every posedge we will load one of the values of the q0,q1,q2 ..... so on
      temp_t = 0;
      count_t = 0;
      if (temp_t == 0) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 1) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 1) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 2) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 3) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 4) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 5) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 6) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 7) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 8) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 9) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 10) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end

      if (temp_t == 11) begin
        count_p = 6'b000000;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q0[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q1[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q2[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q3[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q4[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q5[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q6[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q7[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q8[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q9[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q10[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q11[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q12[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q13[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q14[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q15[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q16[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q17[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q18[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q19[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q20[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q21[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q22[temp_t][count_col];
        count_p = count_p + 1;
        out_psum[count_t*p + count_p][count_col*(W-S+1) + count_base] = q23[temp_t][count_col];
        count_p = count_p + 1;

        temp_t = temp_t + R*r;
        count_t = count_t + 1;
      end
      count_col = count_col + 1;
    end

    end


endmodule
