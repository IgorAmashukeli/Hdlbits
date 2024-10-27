module top_module (
    input clk,
    input reset,
    input slowena,
    output [3:0] q);

    reg[3:0] q_new;
    reg count_end;

    initial begin
        count_end = 0;
    end

    full_adder4 fadd4s(
        .a(q),
        .b(4'b0001),
        .out(q_new)
    );

    eq4 eq4s(
        .a(q),
        .b(4'b1001),
        .out(count_end)
    );

    always @(posedge clk) begin
        q <= (reset || (count_end && slowena)) ? 4'b0000 : ((slowena) ? q_new : q);
    end

endmodule


module eq4 (
    input[3:0] a,
    input[3:0] b,
    output out
);
    wire[3:0] outs;

    eq eqs [3:0] (
        .a(a),
        .b(b),
        .out(outs)
    );

    assign out = outs[0] && outs[1] && outs[2] && outs[3];

endmodule


module eq(
    input a,
    input b,
    output out
);
    assign out = !(a ^ b);

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