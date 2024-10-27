/*
Build a 4-bit shift register (right shift), with asynchronous reset, synchronous load, and enable.

areset: Resets shift register to zero.
load: Loads shift register with data[3:0] instead of shifting.
ena: Shift right (q[3] becomes zero, q[0] is shifted out and disappears).
q: The contents of the shift register.
If both the load and ena inputs are asserted (1), the load input has higher priority.
*/


module top_module(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 

    reg[3:0] in;

    assign in = (load) ? data : ((ena) ? {1'b0, q[3], q[2], q[1]} : q);

    dff_async dffs [3:0] (
        .d(in),
        .areset({4{areset}}),
        .clk({4{clk}}),
        .q(q);
    );


endmodule



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