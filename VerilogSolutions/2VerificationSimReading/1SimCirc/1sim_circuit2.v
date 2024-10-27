/*
This is a combinational circuit.
https://hdlbits.01xz.net/wiki/Sim/circuit2
Read the simulation waveforms to determine what the circuit does, then implement it.
*/

/*
a b c d q
0 0 0 0 1
0 0 0 1 0
0 0 1 0 0
0 0 1 1 1
0 1 0 0 0
0 1 0 1 1
0 1 1 0 1
0 1 1 1 0
1 0 0 0 0
1 0 0 1 1
1 0 1 0 1
1 0 1 1 0
1 1 0 0 1
1 1 0 1 0
1 1 1 0 0
1 1 1 1 1
*/
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );

    assign q = 
    (!a && !b && !c && !d) || (!a && !b && c && d) || (!a && b && !c && d) || (!a && b && c && !d) ||
    (a && !b && !c && d) || (a && !b && c && !d) || (a && b && !c && !d) || (a && b && c && d);

endmodule