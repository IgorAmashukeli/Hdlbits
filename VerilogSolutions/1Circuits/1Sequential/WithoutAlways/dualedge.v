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



    // on rising/falling edge
    // one of the flip flops returns q_i, and the other returns d_current
    // the one that outputs d_current has !ns = 1, the one that outpus q_i has !ns = 0
    // (
    // because: 
    // if edge was 0->1, the positive flip flop will have latch input as clk = 1, so !ns = 1
    // and negative flip flop will have latch input as !clk = 0, so !ns = 0
    //
    // if edge was 1->0, the negative flip flop will have latch input as !clk = 1, so !ns = 0
    // and positive flip flop will have latch input as clk = 0, so !ns = 0
    //)
    // and, after substituion of the !ns we have
    // q = (q_i && 0) || (d_current && 1) = 0 || d_current = d_current
    // on high/low value of the clock
    // both flip flops return the previous value

    // let's look at tick and tock of the clock
    // at that moment, the flip flop that just had the edge
    // (positive for hight and negative for low)
    // only changes the master input clock
    // the clock for the slave remains the same 
    // (0->1 edge has the same slave clock input as 1, while 1->0 edge has the same slave clock input as 0)
    // that means that the clock that just had edge has !ns = 1
    // and the clock that didn't have edge has !ns = 0, because it triggers on the opposite edge
    // (0->1 edge has different slave clock, compared to 1, and 1->0 edge has also different slave clock, compared to 0)
    // at high(tock)/low(tick), suppose, q_i is that the flip flop that acted last outputed and q_j is the one
    // that the one that was before outputed
    // then, !ns_i = 1 and !ns_j = 0, according to the statements above
    // therefore
    // 
    // q = (q_i && 1) || (q_j && 0) = q_i || 0 = q_i

    // Truth table
    // clk     q
    //  0      q of the last flip flop
    //  1      q of the last flip flop
    // 0->1    d
    // 1->0    d

    // let's note that the q of the last flip flop
    // is the value that was outputed by the whole dual edge flip flop on the last edge
    // (it is q for the whole dual edge flip flop)
    // 
    // therefore
    //
    // Truth table
    // clk     q
    //  0      previous q (last q, outputed by the whole dual edge flip flop)
    //  1      previous q (last q, outputed by the whole dual edge flip flop)
    // 0->1    d
    // 1->0    d

    // Therefore, the dual edged flip flop is correct
endmodule



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