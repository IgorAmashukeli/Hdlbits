/*

implement the following circuit:

https://hdlbits.01xz.net/wiki/File:Exams_m2014q4b.png

*/


module top_module (
    input clk,
    input d, 
    input ar,   // asynchronous reset
    output q);

    always @(posedge clk or posedge ar) begin
        if (ar) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end

    end

endmodule