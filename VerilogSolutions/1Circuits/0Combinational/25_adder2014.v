/*

Implement the following circuit

https://hdlbits.01xz.net/wiki/File:Exams_m2014q4j.png

*/



module top_module (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);

    wire[2:0] carry_ins;


    add1 adders [3:0] (
        .a(x), .b(y), .cin({carry_ins, 1'b0}), .cout({ sum[4], carry_ins}), .sum(sum[3:0])
    );

    

endmodule



module add1( 
    input a, b, cin,
    output cout, sum );

    assign sum = a ^ b ^ cin;
    assign cout = (a && b) || (a && cin) || (b && cin);

endmodule