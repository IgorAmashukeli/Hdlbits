/*
This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.
https://hdlbits.01xz.net/wiki/Sim/circuit5
*/


module top_module (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q );

    assign q = ( {4{(c == 4'd0)}} & b) | 
               ( {4{(c == 4'd1)}} & e) | 
               ( {4{(c == 4'd2)}} & a) | 
               ( {4{(c == 4'd3)}} & d) | 
               ( {4{(c != 4'd0) && (c != 4'd1) && (c != 4'd2) && (c != 4'd3)}} & 4'hf);

endmodule