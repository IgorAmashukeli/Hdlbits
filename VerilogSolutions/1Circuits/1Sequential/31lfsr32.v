/*
See Lfsr5 for explanations.

Build a 32-bit Galois LFSR with taps at bit positions 32, 22, 2, and 1.
*/


module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 

    dff_res dffs [31:0] (
        .clk({32{clk}}),
        .reset({32{reset}}),
        .res_val(32'h1),
        .in({q[0], q[31:23], q[22] ^ q[0], q[21:3], q[2] ^ q[0], q[1] ^ q[0]}),
        .out(q)
    );

endmodule



module dff_res (
    input clk,
    input reset,
    input res_val,
    input in,
    output out
);

    always @(posedge clk) begin
        out <= (reset) ? res_val : in;
    end

endmodule