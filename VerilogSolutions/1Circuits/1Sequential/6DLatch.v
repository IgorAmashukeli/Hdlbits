/*

Implement the following circuit:

https://hdlbits.01xz.net/wiki/File:Exams_m2014q4a.png


*/

module top_module (
    input d, 
    input ena,
    output q);

    always @(*) begin
        if (ena) begin
            q <= d;
        end
    end

endmodule