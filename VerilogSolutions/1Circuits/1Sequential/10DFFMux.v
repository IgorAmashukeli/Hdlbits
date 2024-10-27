/*

Implement one stage of the following circuit

https://hdlbits.01xz.net/wiki/File:Mt2015_muxdff.png


*/



module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);

    always @(posedge clk) begin
        Q <= (L) ? q_in : r_in;
    
    end

endmodule