/*
Build a combinational circuit with 100 inputs, in[99:0].

There are 3 outputs:

out_and: output of a 100-input AND gate.
out_or: output of a 100-input OR gate.
out_xor: output of a 100-input XOR gate.
*/


module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);

    assign out_and = &in[99:0];
    assign out_or = |in[99:0];
    assign out_xor = ^in[99:0];

endmodule
