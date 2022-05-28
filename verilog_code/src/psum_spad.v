/* The psum scratch pad used inside the PE
     Its a 24 sized linear 16 bit SRAM
     It is negative edged
     addr: the address to read/write data depending on we
     we: write enable. If its one at the negative edge then it writes to address
         otherwise it reads from address
     data_in- input to the spad to be written to the addr if write enable is high
     data_out- the output of the spad that is result of a read
*/

module psum_spad(clk, addr, we, data_in,data_out);
    // 24 * 16bit
    input             clk;
    input       [4:0] addr;
    input             we; // write enable signal, 0: Read; 1: Write
    input       [15:0] data_in;
    output reg  [15:0] data_out;
    reg         [15:0] mem [23:0]; // 24 * 16bit

    //assign data_port = !we ? data_out : 16'bz;
    initial
    begin
        data_out = mem[addr];
    end

    always @ (negedge clk)
    begin
        if (we)
            mem[addr] <= data_in;
        else
        begin
            data_out <= mem[addr];
        end
    end
    
endmodule
