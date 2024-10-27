/*

Now that you know how to build a full adder, make 3 instances of it to create a 3-bit binary ripple-carry adder. 
The adder adds two 3-bit numbers and a carry-in to produce a 3-bit sum and carry out. 
To encourage you to actually instantiate full adders, also output the carry-out from each full adder in the ripple-carry adder. 
cout[2] is the final carry-out from the last full adder, and is the carry-out you usually see.

*/



module top_module( 
    input [2:0] a, b,
    input cin,
    output [2:0] cout,
    output [2:0] sum );

    add1 adders [2:0] (.a(a), .b(b), .cin({cout[1:0], cin}), .cout(cout), .sum(sum));
    

endmodule



module add1( 
    input a, b, cin,
    output cout, sum );

    assign sum = a ^ b ^ cin;
    assign cout = (a && b) || (a && cin) || (b && cin);

endmodule