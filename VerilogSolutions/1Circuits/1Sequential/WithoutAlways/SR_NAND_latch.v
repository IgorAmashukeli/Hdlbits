
/*
truth table for NAND gate:

a b NAND
0 0  1
0 1  1
1 0  1
1 1  0


1) case 1: 

nset = 0; nreset = 1

q = NAND(nset, not_q) = NAND(0, not_q) = 1
not_q = NAND(nreset, q) = NAND(1, 1) = 0

aftwer we make nset = 1 and nreset = 1
but q = 1; not_q = 0

q = NAND(nset, not_q) = NAND(1, 0) = 1
not_q = NAND(nreset, q) = NAND(1, 1) = 0

q = 1; not_q = 0

it saved the previous output


2) case 2:

nset = 1; nreset = 0

not_q = NAND(nreset, q) = NAND(0, q) = 1
q = NAND(nset, not_q) = NAND(1, 1) = 0

aftwer we make nset = 1 and nreset = 1
but q = 0; not_q = 1

q = NAND(nset, not_q) = NAND(1, 1) = 0
not_q  = NAND(nreset, q) = NAND(0, 0) = 1

q = 0; not_q = 1

it saved the previous output

3) case 3:

nset = 0; nreset = 0

not_q = NAND(0, q) = 1
q = NAND(0, q) = 1

it is wrong : q = not_q

so this case is never used

4) case 4

nset = 1; nreset = 1

but q = 1 and not_q = 1

not_q = NAND(1, 1) = 0
q = NAND(1, 1) = 0

so q = 0 and not_q = 0

now, when q = 0 and not_q = 0:

not_q = NAND(0, 1) = 1
q = NAND(0, 1) = 1

so q = 1 and not_q = 1

again, if q = not_q (both 0 or both 1), this case with nset = 1 and nreset = 1 is not used




NS NR Q_i+1 !Q_i+1
 0 0 not used
 0 1  1      0
 1 0  0      1
 1 1  Q_i    Q_i (only in case, when Q = 0, !Q = 1 or Q = 1, !Q = 0)



*/


module SR_NAND_latch (
    input nset,
    input nreset,
    output q
);

    wire not_q;

    my_NAND nand1
     (
        .a(nset),
        .b(not_q),
        .out(q)
    );

    my_NAND nand2 (
        .a(q),
        .b(nreset),
        .out(not_q)
    );
    


endmodule




module my_NAND (
    input a,
    input b,
    output out
);

    assign out = ! (a && b);

endmodule