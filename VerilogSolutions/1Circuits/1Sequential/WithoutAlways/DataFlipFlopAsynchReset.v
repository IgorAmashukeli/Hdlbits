/*
Data flip flop with asyncronous reset
We modify the data latches in syncronous reset data flip flop
(both the master and slave)
We add a third input to nreset nand gate in data latch: the !areset input


First of all let's note that NAND(x, y, 1) = NAND(x, y)
Indeed:

x y NAND
0 0  1
0 1  1
1 0  1
1 1  0

x y 1 NAND
0 0 1  1
0 1 1  1
1 0 1  1
1 1 1  0

Therefore, if areset is 0 (!areset = 1)
the modified data latch works the same as the original data latch

Therefore:

areset  clk   Q_i
  0     0     Q_{j}, where j < i is the last iteration, when there was a change (because, input is not propogated to slave data latch)
  0     1     Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch)
  0     1->0  Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch and not propogated in slave data latch)
  0     0->1  D (result is captured, and propogated, the areset was 0, so the output is D, mux selected D)


Now, for areset = 1

On any situation, the output is definetly 0

areset       clk            Q_i
   1      0/1/1->0/0->1      0


Let's consider cases:

a) clck is 0 for slave latch (it is 0 or 1->0) situation.
In that case:
NS = NAND(clk, master_output) = NAND(0, master_output) = 1
q_bar = NAND(NR, q, !areset) = NAND(NR, q, 0) = 1
Therefore, q = NAND(NS, q_bar) = NAND(1, 1) = 0
Q_i is, indeed, 0 in that case
Thus, we checked the cases: 0 and 1->0


b) clk is 1 for both latches
Because, master latch gets its clock input inverted
NS = NAND(!clk, d) = NAND(0, d) = 1
q_bar_master = NAND(NR, q, !areset) = NAND(NR, q, 0) = 1
Therefore, q_master = NAND(NS, q_bar_master) = NAND(1, 1) = 0

Then, in slave data latch:
NS = NAND(clk, master_output) = NAND(clk, 0) = 1
q_bar = NAND(NR, q, !areset) = NAND(NR, q, 0) = 1
Therefore, q = NAND(NS, q_bar) = NAND(1, 1) = 0
Q_i is, indeed, 0 in that case
Thus, we checked the case 1

Now lets consider the positive edge (0->1):

First of all, because areset is 1, mux_out = 0
For master data latch:
clk is inverted =>
NS = NAND(!clk, mux_out) = NAND(1, 0) = 1
q_bar_master = NAND(NR, q, !areset) = NAND(NR, q, 0) = 1
q_master = NAND(NS, q_bar_master) = NAND(1, 1) = 0

For slave data latch
clk is not inverted =>
NS = NAND(clk, 0) = NAND(1, 0) = 1
q_bar = NAND(NR, q, !areset) = NAND(NR, q, 0) = 1
q = NAND(NS, q_bar) = NAND(1, 1) = 0
So, on the positive edge, the output is also 0

We checked all four cases (tick (0), tock(1), negative edge(1->0) positive edge(0->1)) with reset 1
The output is always 0

Also, we understood, the importance of multiplexer even in that case: otherwise, the output is going to
be 1, when d = 1, clk is 0->1, and the areset is 1, but is should be 0

The truth table for the asyncronous reset data flip flop


areset  clk                Q_i
  0     0                  Q_{j}, where j < i is the last iteration, when there was a change (because, input is not propogated to slave data latch)
  0     1                  Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch)
  0     1->0               Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch and not propogated in slave data latch)
  0     0->1               D (result is captured, and propogated, the areset was 0, so the output is D, mux selected D)
  1     0/1/1->0/0->1      0


*/



module dff_async (
    input d, 
    input areset,
    input clk,
    output q);
    
    // output of the master data latch
    wire master_output;

    // complement of the master data latch
    wire not_master_output;

    // complement of the slave data latch
    wire not_q;

    // negated clock
    wire not_clk;

    // doubly negated clk
    wire not_not_clk;

    // mux_out input
    wire mux_out;

    // additional check for positive edge triggering case
    assign mux_out = (areset) ? 1'b0 : d;

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));


    // master latch gate, areset is feeded as asyncronous input
    d_latch_gate_ar d_master(.d(mux_out), .ena(not_clk), .areset(areset), .q(master_output), .qbar(not_master_output));


    // not gate to create doubly not clock for the slave input
    not_gate not_2(.e(not_clk), .f(not_not_clk));


    // slave latch gate, areset is also feeded here as asyncronous input
    d_latch_gate_ar d_slave(.d(master_output), .areset(areset), .ena(not_not_clk), .q(q), .qbar(not_q));


    
    

endmodule


// data latch with asyncronous reset
module d_latch_gate_ar(
    input d,
    input ena,
    input areset,
    output reg q,
    output reg qbar
);
    
    wire dbar;
	wire nset;
    wire nreset;
    wire anreset;
    
    // not of the d
    not_gate not1(.e(d), .f(dbar)); 
    not_gate not2(.e(areset), .f(anreset));
    
    // start of the SR flip flop circuit
    
    // nand gate of the d and clk
    nand_gate nand1(.a(d), .b(ena), .c(nset)); 
    
    // nand gate of the dbar and clk: bar goes to nreset
    nand_gate nand2(.a(dbar), .b(ena), .c(nreset)); 
    
    // start of the SR latch circuit
    
    // asyncronous areset in the nreset nand gate
    nand3_gate nand3(.a(q), .b(nreset), .c(anreset), .d(qbar)); 

    // nset nand gate
    nand_gate nand4(.a(nset), .b(qbar), .c(q)); 
endmodule


module nand3_gate (
    input a,
    input b,
    input c,
    output d
);

    assign d = !(a && b && c);


endmodule



module nand_gate(
    input a,
    input b,
    output c
 );
    assign c= ~(a & b);
endmodule


module not_gate(
    input e, output f
);
	assign f = ~e;
endmodule