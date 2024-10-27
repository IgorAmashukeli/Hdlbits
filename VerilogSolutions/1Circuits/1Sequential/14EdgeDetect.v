/*

For each bit in an 8-bit vector, detect when the input signal changes from 0 in one clock cycle to 1 the next (similar to positive edge detection). 
The output bit should be set the cycle after a 0 to 1 transition occurs.


*/

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    detect_bit_pos detectors [7:0] (
        .clk ({8{clk}}),

        .in(in),

        .pedge(pedge)

    );

endmodule


module detect_bit_pos (
    input clk,
    input in,
    output reg pedge
);

    reg old_in;
    // triggering on positive edge of clk
    always @(posedge clk) begin
        pedge <= (!old_in && in) ? 1'b1 : 1'b0;
        old_in <= in;
    end

endmodule