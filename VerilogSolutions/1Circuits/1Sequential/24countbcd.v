/*

Build a 4-digit BCD (binary-coded decimal) counter. 
Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. For digits [3:1], also output an enable signal indicating when each of the upper three digits should be incremented.

You may want to instantiate or modify some one-digit decade counters.
*/


module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);


    assign ena[1] = 1'b1;
    

    bcdcount counter1(
        .clk(clk),
        .reset(reset),
        .ena(ena[1]),
        .q(q[3:0])
    );

    assign ena[2] = (q[3:0] == 4'b1011);

    bcdcount counter2(
        .clk(clk),
        .reset(reset),
        .ena(ena[2]),
        .q(q[7:4])
    );

    assign ena[3] = (q[7:0] == 8'b10111011);

    bcdcount counter3(
        .clk(clk),
        .reset(reset),
        .ena(ena[3]),
        .q(q[11:8])
    );



endmodule


module bcdcount (
    input clk,
    input reset,
    input ena,
    output[3:0] q
);

    wire[3:0] q_new;

    full_adder4 fadd4 (
        .a(q),
        .b(4'b0001),
        .out(q_new)
    );    

    always @(posedge clk) begin
        q <= (reset || ((q == 4'b1001) && (ena))) ? 4'b0000 : ((ena) ? q_new : q);
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