/*
Create a 100-bit binary ripple-carry adder by instantiating 100 full adders. 
The adder adds two 100-bit numbers and a carry-in to produce a 100-bit sum and carry out. 
To encourage you to actually instantiate full adders, also output the carry-out from each full adder in the ripple-carry adder. 
cout[99] is the final carry-out from the last full adder, and is the carry-out you usually see.
*/


module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );

    // instantiating 100 full adders
    // a and b are used accordingly (a[i] and b[i] is used in i-th full adder)
    // cin is the concatenation of cout[98:0] - the first 99 carry inputs + external input carry
    // cout is cout (used accordingly as a and b)
    // sum is sum (used according as a, band cout)
    full_adder fadder[99:0] (.a(a), .b(b), .cin({cout[98:0], cin}, .cout(cout), .sum(sum)));

endmodule