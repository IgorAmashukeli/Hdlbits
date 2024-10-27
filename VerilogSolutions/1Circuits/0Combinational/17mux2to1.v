/*

Create a one-bit wide, 2-to-1 multiplexer. When sel=0, choose a. When sel=1, choose b.

Expected solution length: Around 1 line.
*/



module top_module( 
    input a, b, sel,
    output out ); 

    assign out = (a && !sel) ^ (b && sel);

endmodule