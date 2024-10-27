/*

For each bit in an 8-bit vector, detect when the input signal changes from one clock cycle to the next (detect any edge). 
The output bit should be set the cycle after a 0 to 1 transition occurs.
*/

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    detect_any detectors [7:0] (
        .clk({8{clk}}),

        .in(in),

        .anyedge(anyedge)

    );

endmodule


module detect_any (
    input clk,
    input in,
    output reg anyedge
);

    reg old_in;

    always @(posedge clk) begin
        pedge <= (old_in ^ in);
        old_in <= in;
    end


endmodule