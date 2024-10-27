/*

Implement one stage of the following circuit

https://hdlbits.01xz.net/wiki/Exams/2014_q4a

*/



module top_module (
    input clk,
    input w, R, E, L,
    output Q
);

    always @(posedge clk) begin
        Q <= (L) ? R : ((E) ? W : Q);
    
    end

endmodule