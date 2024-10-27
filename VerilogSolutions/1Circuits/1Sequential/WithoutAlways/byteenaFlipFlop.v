/*

Create 16 D flip-flops. It's sometimes useful to only modify parts of a group of flip-flops. The byte-enable inputs control whether each byte of the 16 registers should be written to on that cycle. byteena[1] controls the upper byte d[15:8], while byteena[0] controls the lower byte d[7:0].

resetn is a synchronous, active-low reset.

All DFFs should be triggered by the positive edge of clk.
*/


module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    my_dff dffs [15 : 0] (
        .clk({16{clk}}),

        .resetn({16{resetn}}),

        .byteena({ {8{byteena[1]}}, {8{byteena[0]}} }),

        .d(d),

        .q(q)
    );

endmodule


module my_dff (
    input clk,
    input resetn,
    input byteena,
    input d,
    output q
);
    
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

    // syncronous check:
    // if resetn is low (it is active low) -> input is 0 (reset the output)
    // else if byteena is 1 -> input is d (set the input)
    // else use the previous value of q (latching)
    assign mux_out = (!resetn) ? 1'b0 : ((byteena) ? d : q);

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