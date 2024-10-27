/*

implement the following circuit

https://hdlbits.01xz.net/wiki/File:Exams_m2014q4c.png

*/


module top_module (
    input clk,
    input d, 
    input r,   // synchronous reset
    output q);

    always @(posedge clk) begin
        if (r) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    
    end

endmodule
