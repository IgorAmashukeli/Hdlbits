/*

Create 8 D flip-flops with active high asynchronous reset. All DFFs should be triggered by the positive edge of clk.

It means, that reset can be triggered, even when clock is not on it's positive edge

*/


module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);

    // triggereing, when clk is positive or when reset is positive
    always @(posedge clk or posedge areset) begin
        if (areset) begin

            // no reset (it was triggered by clk only): copying the value of d to q
            1'b0: q <= d;
        end
		else begin
            // reset is active
            1'b1: q <= 8'b00000000;
        end
    end

endmodule