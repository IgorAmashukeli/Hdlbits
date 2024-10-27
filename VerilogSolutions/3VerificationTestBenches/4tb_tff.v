/*
You are given a T flip-flop module with the following declaration:

module tff (
    input clk,
    input reset,   // active-high synchronous reset
    input t,       // toggle
    output q
);
Write a testbench that instantiates one tff and will reset the T flip-flop then toggle it to the "1" state.
*/


module top_module ();

    reg t;
    reg reset;
    reg clk;
    wire q;
    initial begin
        t = 0;
        clk = 0;
        reset = 1;

        #10 reset = 0;
        t = 1;

        #10 t = 0;

    end

    always begin
        #5 clk = !clk;
    end

    tff tff_mod (
        .clk(clk),
        .reset(reset),
        .t(t),
        .q(q)
    );

endmodule