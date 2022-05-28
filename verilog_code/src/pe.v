/* PE - the main fuctional block of interest
     ifmap: the load line to get data for loading 16 bit ifmap
     filt: the load line to get data for loading 16 bit filters
     ipsum: the load line to get the ipsum for doing vertical sum
                     from the MUX in PE array
     opsum: the wire to transfer the calculated psums summed with psums from lower
                     PE's to the top of the PE set
     clk : clock for synchronisation
     S: the filter width size
     load: load signal indication some type (ifmap/filt) is taking place
     load2: load signal to specify ifmap loading is taking place
     load3: load signal to specift filter loading is taking place
     start: control signal from pe_array_control (Master Control) to start computation
                  as all PE sets are loaded sequentially but work parallely a common start
                    signal is required
     complete: signal to tell the comutation assigned has completed. Helps in loading
                          new data from Memory Banks for next calculation cycle and store the calculated
                         psums into the shift registers
*/

module pe (ifmap, filt, ipsum, opsum, clk, S,load,load2,load3, P , Q, start,complete); // the main Processing Element

    input [15:0]      ifmap;
    input [15:0]      filt;
    input [15:0]      ipsum;
    output reg [15:0] opsum;
    output            complete;
    input load;
    input load2;    // used along with load ie load = load2 = 1  when only ifmap is to be updated
    input load3;    // used along with load ie load=load3=1  when only filt needs to be updated
    input start;
    input clk;
    input [3:0] S; // Filter Size in range 1-12
    input [4:0] P; // The no of filters used together. Max = 24
    input [3:0] Q; // No of channels together Max = 4

    reg [3:0] add1 = 4'd0;        // Needs to update at the end of every 4*P cycles
    reg [7:0] add2 = 8'd0;            // Need to continuously update when 4 cycles complete as earlier
    reg [4:0] add3 = 5'd0;                 // Now need to update it at the after every 4 cycles with a modulo of p

    reg [15:0] ifr,fr,psr,r6;  // r6 found after the MUX2 lower one

    // intermidiate wires
    wire [15:0] a,b,c,g,d,e,f;
    wire ifw,fsw,psw,M1,M2,adw,adw2,ifw2, ifa,fsw2;
    reg en2= 1'b0;

    assign fsw2   = (fsw & (~ load2) &(load3));           //  so that only when load2 equal zero we have to write in the feature spad
    assign ifw2   = (ifw & (~ load3)&(load2));            //  so that we dont go out ot bound
    ifmap_spad I1   (.clk(clk), .addr(add1), .we(ifw2), .data_out(a), .data_in(ifmap));
    filter_spad I2  (.clk(clk), .addr(add2), .we(fsw2), .data_out(b), .data_in(filt)); // Input will get braodvasted from the mesh in the outer circuit
    psum_spad I5    (.clk(clk), .addr(add3), .we(adw&start), .data_out(c), .data_in(g));  // and start to avoid

    always @(negedge clk)
    begin
        ifr <= a;
        fr  <= b;
        psr <= c;
        r6  <= f;
    end

    // just for testing
    always @( posedge adw)
    begin
        add2 <= add2+1;
        //add3 <= add3+

    end

    reg comp=0;
    wire comp2;

    always@(negedge adw) // posedge adw2
    begin
        if(add3 == P-1 && comp != 1 )
          add3 = 5'b00000;
        else if (comp != 1)
          add3 <= add3+1;
    end

    always @( posedge ifa)
    begin
        add1 <= add1+1;
    end

    always@(posedge load2)
    begin
        add1 <= 4'b0000;
        add2 <= 8'b00000000 ;
        add3 <= 5'b00000;
        en2 <=0;
    end

    always@(posedge load3)
    begin
        add1 <= 4'b0000;
        add2 <= 8'b00000000 ;
        add3 <= 5'b00000;

    end

    always @(posedge load)
    begin
        add1 <= 4'b0000;
        add2 <= 8'b00000000 ;
        add3 <= 5'b00000;
        //comp <= 0;
        en2 = 0;
    end

    reg [15:0] mux2_control = 16'h0000;
    always @(posedge start)
    begin
        add1 <= 4'b0000;
        add2 <= 8'b00000000 ;
        add3 <= 5'b00000;
        comp <= 0;
        mux2_control <= mux2_control + 1 ;
    end



    always @(negedge load)
    begin
        add1 <= 4'b0000;
        add2 <= 8'b00000000;
        add3 <= 5'b00000;
        comp <= 0;
    end

    reg [15:0] tempo=16'h0000;


    always @(*)
     opsum = tempo + ipsum;

    always @(posedge complete)
    begin
        add3 = 5'b00000;
        comp=1;
    end

    register t1( .in0(comp),.clk(clk) , .out(comp2));

    always @(negedge clk)
    begin
        if((comp == 1 ) && add3 < P-1)
        begin
            add3 <= add3+1;
        end
        else if(comp == 1 && add3 == P-1)
        begin
            comp = 0;
        end
    end

    always @(posedge clk)
    begin
       if(comp2 == 1 && add3 <= P)
        tempo =c;
    end

    always @(negedge clk)
    begin
            if(load == 1'b1)
            begin
                add2 <= add2+1;
                if(add1 < 4'hc && en2 == 0) // when it becomes 12 en2 will become one and at the same time 12 will go to 11 and stay // only for simulation
                begin
                    en2   <= 0;
                    add1  <= add1+1;      // add1 corresponds to a 12 size memeory and
                end
                else
                begin
                    en2 <= 1;
                    add1<= add1 -1;
                end

            end
    end



    pe_control PC   (.clk(clk), .ifw(ifw), .fsw(fsw), .psw(psw), .Mux1(M1), .Mux2(M2) ,.adw(adw), .adw2(adw2), .ifa(ifa),.complete(complete) , .load(load), .P(P), .Q(Q), .S(S),  .start(start));

    mult_pipe2 mul1 (.a(ifr), .b(fr), .clk(clk), .pdt(d));

    mux2X1 Mux1     (.in0(d),.in1(ipsum),.sel(M1),.out(e));

    sum S1          (.x(r6), .y(e), .sume(g));

    mux2X1 Mux2     (.in0(psr), .in1(16'b0000000000000000), .sel(M2 ),.out(f));

endmodule
