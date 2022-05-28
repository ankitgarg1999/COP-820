module pe_control(clk, ifw, fsw, psw, Mux1,Mux2, adw,adw2,ifa,complete, load, P, Q, S, start);

    output reg ifw;
    output reg fsw;
    output reg psw ;
    output reg adw;
    output reg adw2;
    output reg ifa;
    output reg Mux1;
    output reg Mux2;
    output reg complete;

    input start;
    input clk;
    input load;

    input [4:0] P;
    input [2:0] Q;
    input [3:0] S;

    wire [1:0] w1;
    wire [2:0] w_add3;
    wire [9:0] w2;                // Overall Completion
    wire [6:0] wc4p;              // Completion of address of ifmap counter
    wire [9:0] s3;
    wire [6:0] p4;

    reg [5:0] temp =4;
    reg [4:0] count = 5'b00000;   // To let Mux2 be a one for only the first p cycles
    reg comp=1'b0;

    assign s3 = (S * P * Q * temp);
    assign p4 = (P * temp);
    reg rstc3;
    //
    // initial
    //     begin
    //         psw=1'b0;
    //         rstc3 = ~ load;
    //     end
    //
    wire rstc1,rstc2;

    assign rstc1= ((~ load)&start)&(~comp);
    assign rstc2= ((~ load)&start);

    counter C1      (.clk(clk), .rstn(rstc1), .out (w1));            // Every fourth cycle
    counter2 C2     (.clk(clk),.rstn (rstc2), .out(w2) );            // till 4 * P * Q * S
    counter4p C3    (.clk(clk),.rstn (rstc3), .out(wc4p));           // to count till 4*p
    counter_add3 C4 ( .clk(clk) , .rstn(~comp), .out(w_add3));

    always @(posedge start)
    begin
            count = 5'b00000;
            comp =1'b0;
    end

    always@(posedge complete)
    begin
       comp <= 1'b1;
    end


    always @(*)
    begin
        if (w1 == 2'b00 && load == 1'b0)
        begin
            ifw = 1'b0; // we actully need not write to them as they are set initially only
            fsw = 1'b0; // ''''''''''''''''''''
            psw = 1'b1;
        end

        else if (w1 == 2'b00 && load == 1'b1)
        begin
            ifw = 1'b1; // we actully need not write to them as they are set initially only
            fsw = 1'b1; // ''''''''''''''''''''
            psw = 1'b0;
    end

        else if (load == 1'b1)
        begin
            ifw = 1'b1; // we actully need not write to them as they are set initially only
            fsw = 1'b1; // ''''''''''''''''''''
            psw = 1'b0;
        end

        else
        begin
            ifw = 1'b0;
            fsw = 1'b0;
            psw = 1'b0;
        end

        if (w1 == 2'b11 && load == 1'b0)
            adw=1;
        else
            adw=0;
        if (w_add3 == 3'b100 && load == 1'b0)
            adw2=1;
        else
            adw2=0;

        if (wc4p == (p4-1)  && load == 1'b0)
            begin
              ifa=1;            // Control signal to increment the address of ifmap
              rstc3=0;          // if does not work need to set a max in the counter4p
            end

        else
            begin
                ifa=0;
              rstc3= ~load;
            end

        if (w2 > s3)
            begin
                Mux1 = 1 ;
                complete=0;
            end

        else if (w2 == (s3))
            begin
                complete=1;

            end

        else
            begin
                Mux1=0;
                complete = 0;
            end

        if((w1 == 2'b10 && count < P)|| load == 1'b1)
            begin
                  Mux2 = 1;
                  count = count + 1;
            end
        else
            Mux2 = 0;
    end // end of the always(*) block

endmodule
