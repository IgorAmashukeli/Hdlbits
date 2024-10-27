/*
Design a 1-12 counter with the following inputs and outputs:

Reset Synchronous active-high reset that forces the counter to 1
Enable Set high for the counter to run
Clk Positive edge-triggered clock input
Q[3:0] The output of the counter
c_enable, c_load, c_d[3:0] 
Control signals going to the provided 4-bit counter, so correct operation can be verified.
You have the following components available:

the 4-bit binary counter (count4) below,
which has Enable and synchronous parallel-load inputs (load has higher priority than enable).
The count4 module is provided to you. Instantiate it in your circuit.
logic gates


module count4(
	input clk,
	input enable,
	input load,
	input [3:0] d,
	output reg [3:0] Q
);

The c_enable, c_load, and c_d outputs
are the signals that go to the internal counter's enable, load, and d inputs, respectively. 
Their purpose is to allow these signals to be checked for correctness.


Because the requirements are vague
This is what they mean by count4:

count4 module implementation:

always @(posedge clk) begin
    Q <= (c_load) : c_d ? ((c_enable) ? Q+1 : Q);
end


// if c_load = 0, c_d can be any value (1 or 0)
*/

module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);

    count4 the_counter (clk, c_enable, c_load, c_d, Q);

    assign c_enable = enable;
    assign c_d = 4'b0001;
    assign c_load = reset || (Q == 4'b1100 && enable);
    

endmodule