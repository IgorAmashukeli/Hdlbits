/*
implement dual-edged flip flop

Truth table
clk     q
0      previous q (last q, outputed by the whole dual edge flip flop)
1      previous q (last q, outputed by the whole dual edge flip flop)
0->1    d
1->0    d
*/


module top_module (
    input clk,
    input d,
    output q
);
    wire pos_q;
    wire neg_q;

    wire pos_ns_out;
    wire neg_ns_out;


    // positive edge dff
    pos_edge_dff dff1(input clk,
        .d(d),
        .q(pos_q),
        .ns_out(pos_ns_out)
    );

    // negative edge dff
    neg_edge_dff dff2(input clk,
        .d(d),
        .q(neg_q),
        .ns_out(neg_ns_out)
    );
    
    
    assign q = (pos_q && !pos_ns_out) || (neg_q && !neg_ns_out);

    // let's proof it is correct
    // suppose we have a rising clock edge (0 -> 1)
    // as we know at the end of rising edge:
    // pos_q = d_current
    // as we also know at the end of rising edge:
    // neg_q = q_current
    
    // pos_ns_out = NAND(d_current, clk) = NAND(d_current, 1) = !d_current
    // !pos_ns_out = d_current
    // pos_q && !pos_ns_out = d_current && d_current

    // neg_ns_out = NAND(q_current, !clk) = NAND(q_current, 0) = 1
    // !neg_ns_out = 0
    // neg_q && !neg_ns_out = q_current && 0 = 0
    // q = d_current || 0 = d_current

    // suppose, we have a falling clock edge (1 -> 0)
    // as we know at the end of falling edge
    // neg_q = d_current
    // pos_q = q_current
    // neg_ns_out = NAND(d_current, !clk) = NAND(d_current, 1) = !d_current
    // !neg_ns_out = d_current
    // pos_ns_out = NAND(q_current, clk) = NAND(q_current, 0) = 1
    // !pos_ns_out = 0
    // (pos_q && !pos_ns_out) = q_current && 0 = 0
    // (neg_q && !neg_ns_out) = d_current && d_current = d_current
    // q = d_current || 0 = d_current


    // now, when clk = 1 (for example), the output is the same as it was just after the rising edge
    // (d_current, found on the rising edge)
    // because the output of slave data latches in each dff won't change throughout the same clk value



module neg_edge_dff (
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q,
    output reg ns_out
    );
    
    // output of the master data latch
    wire master_output;

    // complement of the master data latch
    wire not_master_output;

    // complement of the slave data latch
    wire not_q;

    // ns_out wire
    wire mast_ns_out;

    // master latch gate
    d_latch_gate d_master(
        .d(d),
        .ena(clk),
        .q(master_output),
        .qbar(not_master_output),
        .ns_out(mast_ns_out)
    );

    // slave latch gate
    d_latch_gate d_slave(
        .d(master_output),
        .ena(!clk),
        .q(q),
        .qbar(not_q),
        .ns_out(ns_out)
    );
    

endmodule


module pos_edge_dff (
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q,
    output reg ns_out
    );
    
    // output of the master data latch
    wire master_output;

    // complement of the master data latch
    wire not_master_output;

    // complement of the slave data latch
    wire not_q;

    // ns_out wire
    wire mast_ns_out;

    // master latch gate
    d_latch_gate d_master(
        .d(d),
        .ena(!clk),
        .q(master_output),
        .qbar(not_master_output),
        .ns_out(mast_ns_out)
    );

    // slave latch gate
    d_latch_gate d_slave(
        .d(master_output),
        .ena(clk),
        .q(q),
        .qbar(not_q),
        .ns_out(ns_out)
    );
    

endmodule



module d_latch_gate(
    input d,
    input ena,
    output reg q,
    output reg qbar,
    output reg ns_out
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

    assign ns_out = nset;
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