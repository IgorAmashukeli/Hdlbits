/*
Create 8 D flip-flops with active high synchronous reset. All DFFs should be triggered by the positive edge of clk.
*/


module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);

    // triggering on the positive edge of the clk
    always @(posedge clk) begin

        // checking reset bit
        case(reset)

            // if bit is 0, then q is updated to d
            1'b0: q <= d;

            // if bit is 1, then q is reset to 0
            1'b1: q <= 1'b0;
            
        endcase
    end

endmodule