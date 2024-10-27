/*
This is a sequential circuit. 
https://hdlbits.01xz.net/wiki/Sim/circuit7
Read the simulation waveforms to determine what the circuit does, then implement it.
*/


module top_module (
    input clk,
    input a,
    output q );

    always @(posedge clk) begin
        q <= !a;
    end

endmodule