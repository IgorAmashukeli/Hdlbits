/*

Create a 100-bit binary adder. The adder adds two 100-bit numbers and a carry-in to produce a 100-bit sum and carry out.

Expected solution length: Around 1 line.

*/

module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );

    wire[98:0] prelim_carry_outs;


    adder1 adders [99:0] (
        .a(a), .b(b), .cin({prelim_carry_outs, cin}), .cout({cout, prelim_carry_outs}), .sum(sum)
    );


endmodule



module adder1( 
    input a, b, cin,
    output cout, sum );

    assign sum = a ^ b ^ cin;
    assign cout = (a && b) || (a && cin) || (b && cin);

endmodule