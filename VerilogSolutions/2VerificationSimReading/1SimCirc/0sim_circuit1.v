/*
This is a combinational circuit.
https://hdlbits.01xz.net/wiki/Sim/circuit1
Read the simulation waveforms to determine what the circuit does, then implement it.
*/


/*
a b q
0 0 0
0 1 0
1 0 0
1 1 1
*/
module top_module (
    input a,
    input b,
    output q );//

    assign q = a && b;

endmodule