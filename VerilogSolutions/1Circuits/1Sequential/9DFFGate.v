/*

Implement the following circuit

https://hdlbits.01xz.net/wiki/File:Exams_m2014q4d.png

*/


module top_module (
    input clk,
    input in, 
    output out);

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule