
/*

Let's find the truth table for data flip flop.
We will use data latch

The following is the truth for data latch


Enabled D    Q_i
    0   0    Q_{j}, where j < i is the last iteration, when there was a change
    0   1    Q_{j}, where j < i is the last iteration, when there was a change
    1   0     0
    1   1     1


Now, let's calculate the truth table for the data flip flop

1) clk = 0, D is input

master d latch input is inverted =>

MasterLatch_q = D

slave d latch input is not inverted =>

SlaveLatch_q = Q_{j}

So, output is Q_{j}

2) clk = 1, D is input

master d latch input is inverted =>

MasterLatch = Q_{j}

slave d latch input is not inverted =>

SlaveLatch_q = slave_d = master_output = Q_{j}

So, output is Q_{j}


3) clk is on positive edge, D is input

It means that clk = 0 for master and 1 for slave

master d latch input is inverted =>

MasterLatch_q = D

slave d latch input is not inverted =>

SlaveLatch_q = slave_d = master_output = D

So, output is Q_{j}

4) clk is on negative edge, D is input

It means that clk = 1 for master and 0 for slave

master d latch input is inverted =>

MasterLatch = Q_{j}


slave d latch input is not inverted =>

SlaveLatch_q = Q_{j}


So, output is Q_{j}


So, the truth table is following:



clk   Q_i

0     Q_{j}, where j < i is the last iteration, when there was a change
1     Q_{j}, where j < i is the last iteration, when there was a change
0->1  D
1->0  Q_{j}, where j < i is the last iteration, when there was a change


*/


module top_module (
    input d, 
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

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));


    // master latch gate
    d_latch_gate d_master(.d(d), .ena(not_clk), .q(master_output), .qbar(not_master_output));


    // not gate to create doubly not clock for the slave input
    not_gate not_2(.e(not_clk), .f(not_not_clk));


    // slave latch gate
    d_latch_gate d_slave(.d(master_output), .ena(not_not_clk), .q(q), .qbar(not_q));


    
    

endmodule


module d_latch_gate(
    input d,
    input ena,
    output reg q,
    output reg qbar
);
    
    wire dbar;
	wire nset;
    wire nreset;
    
    // not of the d
    not_gate not1(.e(d), .f(dbar)); 
    
    // start of the SR flip flop circuit
    
    // nand gate of the d and clk
    nand_gate nand1(.a(d), .b(ena), .c(nset)); 
    
    // nand gate of the dbar and clk: bar goes to nreset
    nand_gate nand2(.a(dbar), .b(ena), .c(nreset)); 
    
    // start of the SR latch circuit
    
    // nand gate
    nand_gate nand3(.a(q), .b(nreset), .c(qbar)); 
    nand_gate nand4(.a(nset), .b(qbar), .c(q)); 
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