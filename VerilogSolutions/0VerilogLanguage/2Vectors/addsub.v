/*
An adder-subtractor can be built from an adder by optionally negating one of the inputs, which is equivalent to inverting the input then adding 1. 
The net result is a circuit that can do two operations: (a + b + 0) and (a + ~b + 1). See Wikipedia if you want a more detailed explanation of how this circuit works.

Build the adder-subtractor below.

You are provided with a 16-bit adder module, which you need to instantiate twice:

module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );

Use a 32-bit wide XOR gate to invert the b input whenever sub is 1. (This can also be viewed as b[31:0] XORed with sub replicated 32 times. 
See replication operator.). Also connect the sub input to the carry-in of the adder.
*/


module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire lower_carry_out;
    wire upper_carry_out;

    // sub (0 or 1) - whether to do a + b or a - b

    // if sub = 0 => b_changed = b
    // if sub = 1 => b_changed = ~b
    wire[31:0] b_changed = b ^ {32{sub}};
    
    // we add 1, if it is a - b and 0, when it is a + b => we add sub
    add16 adder_lower(a[15:0], b_changed[15:0], sub, sum[15:0], lower_carry_out);
    add16 adder_upper(a[31:16], b_changed[31:16], lower_carry_out, sum[31:16], upper_carry_out);

endmodule