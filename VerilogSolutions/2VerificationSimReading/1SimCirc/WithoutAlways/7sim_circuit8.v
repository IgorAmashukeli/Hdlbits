/*
This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.
https://hdlbits.01xz.net/wiki/Sim/circuit8
*/


// the q output is just a data flip flop with negative clock
// it is easy to implement, using master-slave data latche design
// we just need to use clk input for the master data latch
// and use !clk for the slave data latch


// let's figure out how the p output is calculated
// first of all, the output changes, whenever clock is high asyncronously with a
// secondly, the output doesn't change, whenever the clock is low
// and when clock is high, it changes together with a input
// this is the way, how it should be written with always:
//

// Here, below everywhere, we use q instead of p
// We are now talking about the idea itself, and forget about the other output

/*
    always @(posedge clock, posedge a) begin
        if (clock) begin
            q <= a;
        end
    end
*/

// but it is more interesting to do it with
// combinatorial loop without always block

// as we can see, we need to use asyncrous inputs
// so we use both anset and anreset inputs
// anreset is just input (d)
// when d is low (0), anreset = 0, that means areset = 1
// anset is just inverted input (!d)
// when d is high (1), anset = 0, that means set = 1

// Moreover, what is more important
// we need to use anreset and anset in both in slave and master data latches
// Using them in slave output just close to the final output nset/nreset pins
// is logical
// However, let's see, what happens, if forget to use them inside master data latch
// Suppose, master data latch is simple data flip flop
// Suppose, slave data latch is asyncronous data flip flop
// In that case, the output will never change from being 1
// Let's prove this
// Suppose, the output q_slave = 1
// To make q_slave = 0, when a changes to 0 asyncronously,
// we need to make all three inputs to the nand3 gate of q output of slave data latch high
// For that we need to make:
// anset = 1
// q_bar_slave = 1
// NS_slave = 1

// a = 0 => anset = !a = 1
// q_bar_slave = NAND3(NR_slave, anreset, q_slave) = NAND3(NR_slave, a, q_slave) = NAND3(NR_slave, 0, q_slave) = 1
// Thus, anset = 1, q_bar_slave = 1
// We need to make NS_slave = 1
// NS_slave = NAND(clk, q_master) = NAND(1, q_master)
// (clk = 1, because, we are now, talking about the situation, when we need to make output change asyncronously)
// For that we need to make q_master = 0
// On the previous output, q_master was 1, making q_slave = 1
// q_master = NAND(q_bar_master, NS_master)
// Now, to make q_master = 0
// q_bar_master must be 1
// NS_master must be 1
// let's check situations, when !clk = 0 (just after trigger) and !clk = 1 (before triggering)
// In the second case, NS_master = NAND(!clk, data) = NAND(0, data) = 1
// But NR_master = NAND(!clk, !data) = NAND(0, !data) = 1
// Thus, it makes, q_bar_slave = NAND(NR_master, q_master_output) = NAND(1, 1) = 0
// But we needed q_bar_master to be 1
// This is a problem
// Now, suppose, !clk = 1
// then clk = 0
// we need to make data input equal to 0 to make NS_master = 1
// Moreover, to make q_bar_master = 1
// because q_bar_master = NAND(q_master, NR_master)
// and q_master = 1
// we need NR_master to be 0 to make q_bar_master = 1
// thereofre, NS_master should be 1, NR_master should be 0
// for that, because !clk = 1, data should be 0 (then NS_master = NAND(!clk, data) = NAND(1, 0) = 1)
// for that, because !clk = 1, !data should be 1 (then NR_master = NAND(!clk, !data) = NAND(1, 1) = 0)
// for that data should be 0
// for that data = (clk) ? a : q; should be 0
// q = 1
// a = 0
// for that clk should be 1
// but for master data latch
// the working condition (the one we are investigating now, the other one, when !clk = 0 we 
// considered and found out, it won't change out master output)
// is clk = 0
// therefore data = q = 1
// thus making no changes to master output, making it 1
// this making no changes to slave output, making it 1
// so, once output is 1, it never changes


// What changes, when we adding asyncronous inputs not only to slave data latch, but to the master also
// Suppose, we are in the clk = 1 phase (when a should change asyncronously)
// In that case, the clk signal can be 1 at that moment
// the data, that is being used in that case is data = (0) ? a : q = a;
// Therefore, we have additional anreset = a = 0 input to the NAND3 gate of q_bar_master
// When all other inputs were 1, this one is 0, making NAND output q_bar_master = 1
// Before that q_bar_master was 0, making q_master output 1
// But now, q_bar_master = 1, making output 0 (all three inputs to NAND3 gate of q_master are 1 now)
// Therefore, the q_master = 0, therefore, as we figure out before, when clk = 1, a = 0, q_master = 0, q_slave_output = 0

// Now, let's figure out, that the output will change, when output is 0 and we want to make it 1
// Suppose, q_slave = 0
// We want to make q_slave = 1
// For that we need to make at least one NAND3 gate input to the q_slave output equal to 0
// We are now talking about the moment, when clk = 1 (when positive edge triggering already happened)
// That means that data = (clk) ? a : q = (1) ? a : q = 1;
// That means anset = !data = 0, which is one of the inputs of slave output
// That means that the output will also change to 1, which is correct
// This shows, that slave asyncronous input is already enough for 0->1 asyncronous
// change of a value during clk = 1
// But change 1->0 will not happen without asyncronous input to the master slave

// Therefore, we proved that with both asyncronous inputs to master and slave data latches
// whenever clk = 1, the output will change, whenever a is changing
// This is one property of the waveform, that is correct

// Finally, let's make sure, that whenever clk = 0, the output will not change
// Suppose, clk = 0
// This means, that q_slave = NAND3(anset, !q, NS_slave) = NAND3(!data, !q, NS_slave)
// Because, clk = 0, the mux input data = (clk) ? a : q = q;
// Therefore, q_slave = NAND3(!q, !q, NS_slave) = NAND(!q, NS_slave) = q || !NS_slave
// To make it equal to q we need to NS_slave be 1
// Moreover, q_bar_slave should also not change
// q_bar_slave = NAND3(anreset, q, NR_slave) = NAND3(data, q, NR_slave) = NAND3(q, q, NR_slave) = q || !NR_slave = q
// For that we need to make NR_master be 1
// For that we need to make that at least one input is 0 in both NAND gates that output NS_slave and NR_slave
// And we see, that clk input to slave data latch (which is also input to these NAND gates) is 0
// Therefore, the output will not change

// Therefore,
// whenever, the clk = 0, the output doesn't change
// whenever, the clk = 1, the output changes asyncronously together with a
// Thus, we made the following code

/*
    always @(posedge clock, posedge a) begin
        if (clock) begin
            q <= a;
        end
    end
*/

// with the help of 4 (2 in each data latches, master and slave) asyncronous inputs
// proved it works and found that only asyncronous inputs to slave data latch will not help
// Moreover, we figured out that q output change 0->1 will work, but 1->0 will not
// Furthermore, we remembered, that for the asyncronous reset data flip flop
// slave asyncronous input was ok
// It was due to the fact that data input didn't change from 0 to 1 at the moment when clk changes from 0 to 1
// Here, the input is dependent on the clock input, which changes from 0 to 1
// And the master data latch should get the correct new updated version of the signal (1)
// Which it can get only from asyncronous inputs to itself
// This makes a good rule, whenever there is an signal in triggering list, which is also
// the one that is used as a condition or input inside always block,
// this means that this signal should be given the correct value aftet the edge trigger
// and this can be done through careful management of the asyncronous inputs
// For the anreset signal, the asyncronous reset in slave data latch is ok
// because, we can use multiplexer (areset) ? 1'b0 : d;
// this will work, because areset is 1, because the master latch will work, when areset = 1
// because it is not the clock signal
// For the clock signal condition, it is different
// Master data latch is dependant on the !clk signal and works for clk = 0
// Thus, the input data, which is dependant on the clk being 1 will not be correctly updated

module top_module (
    input clock,
    input a,
    output p,
    output q );

    dff_async(
        .d(a),
        .clk(clock),
        .q(p)
    );

    dff_negative(
        .d(a),
        .clk(clock),
        .q(q)
    );

endmodule


module dff_negative(
    input d,
    input clk,
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

    // not gate to create not clock for the master input
    not_gate not_1(.e(clk), .f(not_clk));


    // master latch gate
    d_latch_gate d_master(.d(d), .ena(clk), .q(master_output), .qbar(not_master_output));


    // slave latch gate
    d_latch_gate d_slave(.d(master_output), .ena(not_clk), .q(q), .qbar(not_q));


    


endmodule




module dff_async (
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
    
    // additional syncronous check
    wire mux_out;

    assign mux_out = (clk) ? d : q;


    // master latch gate
    d_latch_gate_async d_master(.d(mux_out), .ena(not_clk), .q(master_output), .ad(mux_out), .qbar(not_master_output));


    // not gate to create doubly not clock for the slave input
    not_gate not_2(.e(not_clk), .f(not_not_clk));


    // slave latch gate
    d_latch_gate_async d_slave(.d(master_output), .ena(not_not_clk), .ad(mux_out), .q(q), .qbar(not_q));

endmodule


module d_latch_gate_async(
    input d,
    input ena,
    input ad,
    output reg q,
    output reg qbar
);
    
    wire dbar;
    wire adbar;
	wire nset;
    wire nreset;
    
    // not of the d
    not_gate not1(.e(d), .f(dbar)); 
    not_gate not2(.e(ad), .f(adbar));
    
    // start of the SR flip flop circuit
    
    // nand gate of the d and clk
    nand_gate nand1(.a(d), .b(ena), .c(nset)); 
    
    // nand gate of the dbar and clk: bar goes to nreset
    nand_gate nand2(.a(dbar), .b(ena), .c(nreset)); 
    
    // start of the SR latch circuit
    
    // nand gate
    nand3_gate nand3(.a(q), .b(nreset), .c(ad), .d(qbar)); 
    nand3_gate nand4(.a(nset), .b(qbar), .c(adbar), .d(q)); 
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