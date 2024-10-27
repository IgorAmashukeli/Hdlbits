/*
This 8-bit wide 2-to-1 multiplexer doesn't work. Fix the bug(s).

module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output out  );

    assign out = (~sel & a) | (sel & b);

endmodule
*/

module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,

    // add [7:0] to output
    output[7:0] out  );

    // changed a and b => if 1 => return a; if 0 => return b
    // added concatenation of 1-bit wide sel and !sel bits
    assign out = ({8{sel}} & a) | ({8{!sel}} & b);

endmodule