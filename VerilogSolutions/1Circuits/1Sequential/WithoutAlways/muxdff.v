

module top_module (
    input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    
    // output of the master data latch
    wire master_output;

    // complement of the master data latch
    wire not_master_output;

    // complement of the slave data latch
    wire not_q;

    // negated clock
    wire not_clk;

    wire mux_out = (L) ? r_in : q_in;

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));


    // master latch gate
    d_latch_gate d_master(.d(mux_out), .ena(not_clk), .q(master_output), .qbar(not_master_output));


    // slave latch gate
    d_latch_gate d_slave(.d(master_output), .ena(clk), .q(Q), .qbar(not_q));


    
    

endmodule


module d_latch_gate(
    input d,
    input ena,
    output reg q,
    output reg qbar
);

    // may be initial will help?
    initial begin
        q = 0;
    end
    
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