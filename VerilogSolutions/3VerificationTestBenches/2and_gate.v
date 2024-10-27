/*
You are given the following AND gate you wish to test:

module andgate (
    input [1:0] in,
    output out
);
Write a testbench that instantiates this AND gate and tests all 4 input combinations, 
by generating the following timing diagram:
*/



module top_module();

    reg[1:0] in;
    wire out;

    initial begin
        in[0] = 0;
        in[1] = 0;
        #10 in[0] = 1;
        #10 in[1] = 1;
        in[0] = 0;
        #10 in[0] = 1;
    end

    andgate and_mod (
        .in(in), .out(out)
    );

    

endmodule
