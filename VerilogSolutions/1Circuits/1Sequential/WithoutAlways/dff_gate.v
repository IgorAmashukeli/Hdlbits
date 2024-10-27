/*

Exams/m2014 q4d

*/


module top_module (
    input clk, 
    input in,
    output out);
    
    wire q;
    
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
    
    wire in2;

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));
    
    
	assign in2 = in ^ q;

    // master latch gate
    d_latch_gate d_master(.d(in2), .ena(not_clk), .q(master_output), .qbar(not_master_output));


    // not gate to create doubly not clock for the slave input
    not_gate not_2(.e(not_clk), .f(not_not_clk));


    // slave latch gate
    d_latch_gate d_slave(.d(master_output), .ena(not_not_clk), .q(q), .qbar(not_q));

    // somehow, it depends on the initialization of out
    // and there in my implementation it somehow differs from their
    // so I need to inverse the result
	assign out = !q;
    
    

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