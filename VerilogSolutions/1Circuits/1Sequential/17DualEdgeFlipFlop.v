/*

You're familiar with flip-flops that are triggered on the positive edge of the clock, or negative edge of the clock.
A dual-edge triggered flip-flop is triggered on both edges of the clock. 
However, FPGAs don't have dual-edge triggered flip-flops, and always @(posedge clk or negedge clk) is not accepted as a legal sensitivity list.

Build a circuit that functionally behaves like a dual-edge triggered flip-flop:

(Note: It's not necessarily perfectly equivalent: 
The output of flip-flops have no glitches, but a larger combinational circuit that emulates this behaviour might. 
But we'll ignore this detail here.)

*/


// I implemented dual-edge flip flop fully without always block: look to the dedicated page
// now with them:


module top_module (
    input clk,
    input d,
    output q
);

    reg p, n;


	
	// A positive-edge triggered flip-flop
    always @(posedge clk)
        p <= d ^ n;
        
    // A negative-edge triggered flip-flop
    always @(negedge clk)
        n <= d ^ p;
    
    assign q = p ^ n;
    
    // 1) on the positive edge:
    // 1->0:
    // p_new = d_new ^ n_old
    // n_new = n_old
    // q = p_new ^ n_new = (d_new ^ n_old) ^ n_old = d_new

    // 2) on the negative edge:
    // 0->1
    // p_new = p_old
    // n_new = d_new ^ p_old
    // q = p_new ^ n_new = (p_old ^ d_new ^ p_old) = d_new

    // 3) on the high value:
    // is just after the positive edge, so:
    // p_new = p_pos_edge = d_pos_edge ^ n_old = [d_pos_edge = q(pos_edge) = q_prev [because, now it is high value of clock]] = q_prev ^ n_old = 
    // n_new = n_old
    // q = p_new ^ n_new = (q_prev ^ n_old ^ n_old) = q_prev


    // 4) on the low value
    // p_new = p_old
    // is just after the negative edge, so:
    // n_new = n_pos_edge = d_pos_edge ^ p_old = [d_neg_edge = q(neg_edge) = q_prev [because, now it is low value of clock]] = q_prev ^ p_old = 
    // q = p_new ^ n_new = (p_old ^ q_prev ^ p_old) = q_prev


    // therefore
    // it is correct:

    // clk    q
    //  0    q_prev
    //  1    q_prev
    // 0->1    d
    // 1-> 0   d
    
    
endmodule

    

