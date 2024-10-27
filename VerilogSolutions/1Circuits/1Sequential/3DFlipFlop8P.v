/*
Create 8 D flip-flops with active high synchronous reset. 
The flip-flops must be reset to 0x34 rather than zero. All DFFs should be triggered by the negative edge of clk.
*/


module top_module (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // triggering on the negative edge of the clk
    always @(negedge clk) begin
        case(reset)
            // copying q to d, when there is no reset
            1'b0: q <= d;

            // reseting value of q to hexadecimal value of 0x34
            1'b1: q <= 8'h34;
        endcase
    end

endmodule