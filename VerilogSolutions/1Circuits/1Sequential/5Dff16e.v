/*
Create 16 D flip-flops. 
It's sometimes useful to only modify parts of a group of flip-flops. 
The byte-enable inputs control whether each byte of the 16 registers should be written to on that cycle. 
byteena[1] controls the upper byte d[15:8], while byteena[0] controls the lower byte d[7:0].

resetn is a synchronous, active-low reset.

All DFFs should be triggered by the positive edge of clk.
*/


module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    dff dffs [15 : 0] (
        .clk({16{clk}}),

        .resetn({16{resetn}}),

        .byteena({ {8{byteena[1]}}, {8{byteena[0]}} }),

        .d(d),

        .q(q)
    );

endmodule


module dff (input clk,
    input resetn,
    input byteena,
    input d,
    output q
);

    always @(posedge clk) begin
        if (resetn) begin
            q <= 1'b0;
        end
        else begin
            if (byteena) begin
                q <= d;
            end
            else begin
                q <= q;
            end
        end
    end

endmodule
