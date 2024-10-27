/*
Write a top-level Verilog module (named top_module) for the shift register, assuming that n = 4. 
Instantiate four copies of your MUXDFF subcircuit in your top-level module. 
Assume that you are going to implement the circuit on the DE2 board.

Connect the R inputs to the SW switches,
clk to KEY[0],
E to KEY[1],
L to KEY[2], and
w to KEY[3].
Connect the outputs to the red lights LEDR[3:0].
(Reuse your MUXDFF from exams/2014_q4a.)
*/


module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
);



    MUXDFF muxs [3:0](
        .clk({4{KEY[0]}}),
        .w({KEY[3], LEDR[3:1]}),
        .R(SW),
        .E({4{KEY[1]}}),
        .L({4{KEY[2]}}),
        .Q(LEDR)
    );


endmodule



module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);

    always @(posedge clk) begin
        Q <= (L) ? R : ((E) ? w : Q);
    
    end

endmodule