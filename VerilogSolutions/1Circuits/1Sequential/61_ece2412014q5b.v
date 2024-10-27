/*
The following diagram is a Mealy machine implementation of the 2's complementer. 
https://hdlbits.01xz.net/wiki/File:Ece241_2014_q5b.png
Implement using one-hot encoding.
*/


module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    wire next_state;

    assign next_state = state || x;

    always @(posedge clk, posedge areset) begin
        state <= (areset) ? 1'b0 : next_state;
    end

    assign z = (state != x);

endmodule