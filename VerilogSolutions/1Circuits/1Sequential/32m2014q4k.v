/*
Implement the following circuit:
*/


module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);

    reg[2:0] prel_outs;

    dff_res dffs [3:0] (
        .clk({4{clk}}),
        .resetn({4{resetn}}),
        .in({prel_outs, in}),
        .out({out, prel_outs}),
    );


endmodule



module dff_res (
    input clk,
    input resetn,
    input in,
    output reg out
);

    always @(posedge clk) begin
        out <= (!resetn) ? 1'b0 : in;
    end

endmodule