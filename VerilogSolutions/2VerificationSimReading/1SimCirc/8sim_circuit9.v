/*
This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.
https://hdlbits.01xz.net/wiki/Sim/circuit9
*/

module top_module (
    input clk,
    input a,
    output [3:0] q );

    always @(posedge clk) begin
        q <= (a) ? 4'd4 : (q == 4'd6) ? 4'd0 : q + 4'd1;
    end

endmodule