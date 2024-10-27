/*

Data flip flop with syncronous reset: reset is checked on 0->1 edge
mux is calculated before using it in latches
we use precalculated mux_out on master latch, so the reset value is the value
that is calculated on the positive edge of the cycle


reset   clk   Q_i
  0/1   0     Q_{j}, where j < i is the last iteration, when there was a change (because, input is not propogated to slave data latch)
  0/1   1     Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch)
  0/1   1->0  Q_{j}, where j < i is the last iteration, when there was a change (because, input is not captured in master data latch and not propogated in slave data latch)
  0     0->1  D (result is captured, and propogated, the reset was 0, so the output is D)
  1     0->1  0 (result is captured, and propogated, the reset was 1, so the output is 0)
*/



module top_module (
    input d, 
    input reset,
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

    // checks if reset is need
    wire mux_out;

    assign mux_out = (reset) ? 1'b0 : d;

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));


    // master latch gate
    d_latch_gate d_master(.d(mux_out), .ena(not_clk), .q(master_output), .qbar(not_master_output));


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