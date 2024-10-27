/*

Build a 4-bit binary counter that counts from 0 through 15, inclusive,
with a period of 16. 
The reset input is synchronous, and should reset the counter to 0.

*/

module top_module (
    input clk,
    input reset,
    output [3:0] q);

    reg[3:0] q_new;

    full_adder4 (
        .a(q),
        .b(4'b0001),
        .out(q_new)
    );

    always @(posedge clk) begin
        q <= (reset) ? 4'b0 : q_new;
    end

endmodule



module full_adder4(
    input [3:0] a,
    input [3:0] b,
    output [3:0] out
);

    wire [3:0] carry_out;
    
    full_adder fadds [3:0] (
        .a(a),
        .b(b),
        .carry_in({carry_out[2:0], 1'b0}),
        .carry_out(carry_out),
        .sum(out)
    );
    

endmodule


module full_adder(
    input a,
    input b,
    input carry_in,
    output carry_out,
    output sum
);

    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a && b || a && carry_in || b && carry_in);

endmodule