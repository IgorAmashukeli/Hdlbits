/*

Let's find the truth table for data latch.
We will use NAND SR latch:
The following is the truth for the NAND SR latch:

NS NR Q_i+1 !Q_i+1
 0 0 not used
 0 1  1      0
 1 0  0      1
 1 1  Q_i    Q_i (only in case, when Q = 0, !Q = 1 or Q = 1, !Q = 0)

Data latch:

1) Enabled = 1, D = 0

NS = NAND(D, Enabled) = NAND(0, 1) = 1
NR = NAND(!D, Enabled) = NAND(1, 1) = 0

Q_i+1 = 0
!Q_i+1 = 1

D was set to its value


2) Enabled = 1, D = 1

NS = NAND(D, Enabled) = NAND(1, 1) = 0
NR = NAND(!D, Enabled) = NAND(0, 1) = 1

Q_i+1 = 1
!Q_i+1 = 0


3) Enabled = 0

NS = NAND(0, D) = 1
NR = NAND(0, !D) = 1


Q_i+1 = Q_i
Q_i+1 = Q_i


Thus, we get the following truth table



Enabled D    Q_i
    0   0    Q_{j}, where j < i is the last iteration, when there was a change
    0   1    Q_{j}, where j < i is the last iteration, when there was a change
    1   0     0
    1   1     1
*/

module top_module (
    input d, 
    input ena,
    output q);
    
    wire qbar;
    
    d_ff_struct some_dff(.d(d), .ena(ena), .q(q), .qbar(qbar));

endmodule


module d_ff_struct(
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