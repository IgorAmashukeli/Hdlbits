
/*
truth table for NOR gate:

a b NOR
0 0 1
0 1 0
1 0 0
1 1 0



truth table for SR latch explained:

1) case 1

set = 0; reset = 1

reset = 1 => NOR(reset, not_q) = NOR(1, not_q) = 0 => q = 0
not_q = NOR(q, set) = NOR(0, 0) = 1 => not_q = 1

Now, suppose, we turned it off:

set = 0; reset = 0;
but we have q = 0 and not_q = 1

NOR(reset, not_q) = NOR(0, 1) = 0, so q = 0
NOR(q, set) = NOR(0, 0) = 1, so not_q = 1

the output remained the same


2) case 2

set = 1; reset = 0

set = 1 => NOR(q, set) = NOR(q, 1) = 0 => not_q = 0
NOR(reset, not_q) = NOR(0, 0) = 1 => q = 1

Now, suppose, we turned it off:

set = 0; reset = 0;
but we have q = 1 and not_q = 0

NOR(reset, not_q) = NOR(0, 0) = 1 => q = 1
NOR(q, set) = NOR(1, 0) = 0 => not_q = 0


3) case 3

set = 1; reset = 1;

set = 1 => NOR(q, set) = NOR(q, 1) = 0 => not_q = 0
NOR(reset, not_q) = NOR(1, 0) = 0 => q = 0

q = not_q - this should not happen

so this case is never used


4) case 4

set = 0; reset = 0 and we have no memory stored:
q = 0 and not_q = 0

NOR(q, set) = NOR(0, 0) = 1
NOR(reset, not_q) = NOR(0, 0) = 1
q = 1 and not_q = 1 => the output changed

now, if q = 1 and not_q = 1 at some point:
NOR(q, set) = NOR(1, 0) = 0
NOR(reset, not_q) = NOR(0, 1) = 0
q = 0 and not_q = 0 => the output changed again

set = 0 and reset = 0 can be used only, when there was previous data stored


S R Q_i+1 !Q_i+1
0 0 Q_i   !Q_i (can be used only if there was Q = 0, !Q = 1 or Q = 1, !Q = 0)
0 1 1      0
1 0 0      1
1 1 Never used

*/


module SR_NOR_latch (
    input set,
    input reset,
    output q
);

    wire not_q;
    my_NOR nor1 (
        .a(reset),
        .b(not_q),
        .out(q)
    );

    my_NOR nor2 (
        .a(q),
        .b(set),
        .out(not_q)
    );
    


endmodule




module my_NOR (
    input a,
    input b,
    output out
);

    assign out = ! (a || b);

endmodule