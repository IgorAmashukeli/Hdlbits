/*
Create a 100-bit wide, 2-to-1 multiplexer. When sel=0, choose a. When sel=1, choose b.

Expected solution length: Around 1 line.
*/


module top_module( 
    input [99:0] a, b,
    input sel,
    output [99:0] out );


    assign out = (a & ~{100{sel}}) ^ (b & {100{sel}});

endmodule
