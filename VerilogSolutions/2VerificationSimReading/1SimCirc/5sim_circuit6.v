/*
This is a combinational circuit. 
Read the simulation waveforms to determine what the circuit does, then implement it.
*/


module top_module (
    input [2:0] a,
    output [15:0] q );

    assign q = 
    ( ({16{(a == 3'd0)}}) & (q == 16'h1232) ) |
    ( ({16{(a == 3'd1)}}) & (q == 16'haee0) ) |
    ( ({16{(a == 3'd2)}}) & (q == 16'h27d4) ) |
    ( ({16{(a == 3'd3)}}) & (q == 16'h5a0e) ) |
    ( ({16{(a == 3'd4)}}) & (q == 16'h2066) ) |
    ( ({16{(a == 3'd5)}}) & (q == 16'h64ce) ) |
    ( ({16{(a == 3'd6)}}) & (q == 16'hc526) ) |
    ( ({16{(a == 3'd7)}}) & (q == 16'h2f19) );


endmodule