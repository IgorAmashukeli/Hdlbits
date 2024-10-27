/*
This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.
https://hdlbits.01xz.net/wiki/Sim/circuit4
*/



/*
a b c d q
0 0 0 0 0
0 0 0 1 0
0 0 1 0 1
0 0 1 1 1
0 1 0 0 1
0 1 0 1 1
0 1 1 0 1
0 1 1 1 1
1 0 0 0 0
1 0 0 1 0
1 0 1 0 1
1 0 1 1 1
1 1 0 0 1
1 1 0 1 1
1 1 1 0 1
1 1 1 1 1
*/

module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );

    q = !( (!a && !b && !c && !d) || (!a && !b && !c && d) || (a && !b && !c && !d) || (a && !b && !c && d));

endmodule