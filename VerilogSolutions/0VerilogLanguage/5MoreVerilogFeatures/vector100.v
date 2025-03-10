/*
Given a 100-bit input vector [99:0], reverse its bit ordering.
*/


module top_module( 
    input [99:0] in,
    output [99:0] out
);

    always @(*) begin
        
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i];

        end

    end

endmodule