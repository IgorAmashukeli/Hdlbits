/*

Assume that you have two 8-bit 2's complement numbers, a[7:0] and b[7:0]. These numbers are added to produce s[7:0]. 
Also compute whether a (signed) overflow has occurred.

Module Declaration
module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); 

*/



module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
 
    wire[7:0] carry_outs;

    add1 adders [7:0] (
        .a(a), .b(b), .cin({carry_outs[6:0], 1'b0}), .cout(carry_outs), .sum(s)
    );

    // overflow : adding two positive numbers resulted in negative number
    //       or : adding two negative numbers resulted in positive number
    assign overflow = (!a[7] && !b[7] && s[7]) || (a[7] && b[7] && !s[7]);
    
    

endmodule



module add1( 
    input a, b, cin,
    output cout, sum );

    assign sum = a ^ b ^ cin;
    assign cout = (a && b) || (a && cin) || (b && cin);

endmodule



