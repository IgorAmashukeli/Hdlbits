/*
You are provided with a BCD one-digit adder named bcd_fadd that adds two BCD digits and carry-in, and produces a sum and carry-out.

module bcd_fadd (
    input [3:0] a,
    input [3:0] b,
    input     cin,
    output   cout,
    output [3:0] sum );
Instantiate 100 copies of bcd_fadd to create a 100-digit BCD ripple-carry adder. Your adder should add two 100-digit BCD numbers
(packed into 400-bit vectors) and a carry-in to produce a 100-digit sum and carry out.
*/


module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );

    wire[98:0] carries;

    bcd_fadd bcd_fadders [99:0] ( .a(a), .b(b), .cin({carries, cin}), .cout({cout, carries}), .sum(sum));




endmodule