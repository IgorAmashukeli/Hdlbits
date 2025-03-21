/*

A "population count" circuit counts the number of '1's in an input vector. Build a population count circuit for a 255-bit input vector.

*/


module top_module( 
    input [254:0] in,
    output [7:0] out );

    integer i;

    always @(*) begin

        out = 8'b00000000;

        for (i = 0; i < 255; i = i + 1) begin

            out = out + in[i];
        
        end
    
    end

endmodule