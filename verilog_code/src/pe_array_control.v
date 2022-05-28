/*
        The Master control module
        complete: the input from any PE module to mark completion of PE computation
                  and start loading of next batch of data
        load_signal: The 12 bit control signal/enable. Each bit corresponds to every Horizontal
                                row of PE pe_array
        load_signal2: The 12 bit control enable to laod ifmaps
        laod_signal3: The 12 bit control enable to load filter
        start: universal start signal to make all the PE sets irrespective of when
                     did they get data to start working parallely
        mux_sel: select lines to mark the end of PE sets and to pass 0 to the lowermost
                         PE of the PE set instead of the ospum of the lower PE
*/

module pe_array_control ( clk,
                          complete,
                          load_signal,
                          load_signal2,
                          load_signal3,
                          start,
                          mux_sel,
                          p,q,t,r,R,S,H,W,
                          alarm );

        input             clk;
        input [4:0]       p,q,t,r,R,S;
        input [15:0]      H,W;
        input             complete;
        input             alarm;

        output reg [11:0] load_signal = 12'h000 ,load_signal2 = 12'h000 ,load_signal3 = 12'h000 ;
        output reg [10:0] mux_sel ;
        output reg        start;

        reg [3:0]   count   = 4'h0;
        reg [15:0]  count_w = 16'h0000;
        reg         all_done= 1'b0;


        wire [3:0] RT;
        assign RT = r*t;

        reg rstc4;
        reg rstc_sq;
        reg ifmap_loading =1'b0;
        reg rstc_spq      =1'b0;

        always@(posedge alarm)
        begin
            load_signal= 12'hfff;
            load_signal3=12'hfff;
            load_signal2=12'h000;
            rstc_spq=load_signal3[0];

        end

        reg [2:0]count_r = 3'b000;

        // Comb Circuit to cut the boundary in PE array to get PE Sets

        reg one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve;
        always @(*)
          begin
            one     = (~R[3])&(~R[2])&(~R[1])&(R[0]);
            two     = (~R[3])&(~R[2])&(R[1])&(~R[0]);
            three   = (~R[3])&(~R[2])&(R[1])&(R[0]);
            four    = (~R[3])&(R[2])&(~R[1])&(~R[0]);
            five    = (~R[3])&(R[2])&(~R[1])&(R[0]);
            six     = (~R[3])&(R[2])&(R[1])&(~R[0]);
            seven   = (~R[3])&(R[2])&(R[1])&(R[0]);
            eight   = (R[3])&(~R[2])&(~R[1])&(~R[0]);
            nine    = (R[3])&(~R[2])&(~R[1])&(R[0]);
            ten     = (R[3])&(~R[2])&(R[1])&(~R[0]);
            eleven  = (R[3])&(~R[2])&(R[1])&(R[0]);
            twelve  = (R[3])&(R[2])&(~R[1])&(~R[0]);

            mux_sel[0] = one;
            mux_sel[1] = one      | two ;
            mux_sel[2] = one      | three;
            mux_sel[3] = one      | two   |four;
            mux_sel[4] = one      | five;
            mux_sel[5] = one      | two   |three  | six;
            mux_sel[6] = one      | seven;
            mux_sel[7] = one      | two   | four  | eight;
            mux_sel[8] = nine     | three | one;
            mux_sel[9] = ten      | five  | two   | one;
            mux_sel[10] = eleven  | one;

            if(mux_sel[0] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                 count_r =0;
              else
                mux_sel[0] = 0;

            end

            if(mux_sel[1] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                 count_r =0;
              else
                mux_sel[1] = 0;

            end

            if(mux_sel[2] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[2] = 0;

            end

            if(mux_sel[3] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[3] = 0;

            end

            if(mux_sel[4] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[4] = 0;

            end

            if(mux_sel[5] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[5] = 0;

            end

            if(mux_sel[6] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[6] = 0;

            end

            if(mux_sel[7] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[7] = 0;

            end

            if(mux_sel[8] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[8] = 0;

            end

            if(mux_sel[9] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[9] = 0;

            end

            if(mux_sel[10] == 1)
            begin
              count_r = count_r +1;
              if(count_r == r)
                count_r =0;
              else
                mux_sel[10] = 0;

            end

        end


        wire [9:0]  s4;       // count till P*Q*S for loading
        assign s4 = (S*p*q);  // time taken to load filters

        wire [9:0] w_spq;     // to mark completion of the P*S*Q cycles

        counter2 spq(.clk(clk),.rstn (rstc_spq), .out(w_spq));



        wire [3:0] s3 ;
        assign s3 = S*q;
        wire [3:0] w_sq;
        //the reset declared above initial block



        counter22 sq(.clk(clk), .rstn(rstc_sq),.out(w_sq));     // asynchronous reset counter

        reg filt_loaded = 1'b0;
        //reg ifmap_loading=1'b0;


        always@(*)
        begin
          if(w_spq == s4+1)
          begin
              rstc_spq=1'b0;
              load_signal3=12'h000;
              filt_loaded=1;

          end

        end

        reg [11:0] record;

        always@(posedge filt_loaded)
        begin
             if(one)
              load_signal2=12'b000000000001;
             else if (two)
              load_signal2=12'b000000000011;
             else if (three)
              load_signal2=12'b000000000111;
             else if (four)
              load_signal2=12'b000000001111;
             else if (five)
              load_signal2=12'b000000011111;
             else if ( six)
              load_signal2=12'b000000111111;
             else if (seven)
              load_signal2=12'b000001111111;
             else if ( eight)
              load_signal2=12'b000011111111;
             else if (nine)
              load_signal2=12'b000111111111;
             else if (ten)
              load_signal2=12'b001111111111;
             else if (eleven)
              load_signal2=12'b011111111111;
             else
              load_signal2=12'hfff;

             count=count+1;                  // to count the number of sets in which ifmap will be loaded
             ifmap_loading = 1;
             record = load_signal2;
             //load_signal2=load_signal2 << R;

        end



        always@(posedge clk)
        begin
            rstc_sq = ifmap_loading;
        end


        always@(*)
        begin
          if(w_sq == s3)            //  to count the number of times in one pass
          begin
             count = count +1;
             load_signal2=load_signal2 << R;
             rstc_sq=0;
             if(count > RT)
             begin
              load_signal2 = 12'h000;
              ifmap_loading = 0;
              start=1;
              filt_loaded=0;
              count=0;
              load_signal = 12'h000;
              load_signal3 = 12'h000;
             end


          end
          
          else
          begin
             rstc_sq = ifmap_loading;
          end


        end

        always@(posedge complete)
        begin
          start = 0;
          count_w = count_w+1;
          count = 0;
          ifmap_loading=1;
          filt_loaded=1;
          load_signal=12'hfff;
          load_signal3=12'h000;
          //load_signal2=12'h000;
          //load_signal2 = record;

          if(count_w == (W - S + 1))
          begin
              all_done=1;
          end

        end



endmodule // pe_array_control
