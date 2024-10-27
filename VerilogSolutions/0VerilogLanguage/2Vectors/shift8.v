/*
This exercise is an extension of module_shift. 
Instead of module ports being only single pins, we now have modules with vectors as ports, to which you will attach wire vectors instead of plain wires. 
Like everywhere else in Verilog, the vector length of the port does not have to match the wire connecting to it, but this will cause zero-padding or trucation of the vector. 
This exercise does not use connections with mismatched vector lengths.

You are given a module my_dff8 with two inputs and one output (that implements a set of 8 D flip-flops). 
Instantiate three of them, then chain them together to make a 8-bit wide shift register of length 3. In addition, create a 4-to-1 multiplexer (not provided) 
that chooses what to output depending on sel[1:0]: The value at the input d, after the first, after the second, or after the third D flip-flop. 
(Essentially, sel selects how many cycles to delay the input, from zero to three clock cycles.)

The module provided to you is: module my_dff8 ( input clk, input [7:0] d, output [7:0] q );

The multiplexer is not provided. One possible way to write one is inside an always block with a case statement inside. (See also: mux9to1v)


*/


module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);

    // wires
    wire[7 : 0] dff1_out;
    wire[7 : 0] dff2_out;
    wire[7 : 0] dff3_out;

    // all three data flip flops with 8bit inputs
    my_dff8 dff1 ( .clk(clk), .d(d), .q(dff1_out));
    my_dff8 dff2 ( .clk(clk), .d(dff1_out), .q(dff2_out));
    my_dff8 dff3 ( .clk(clk), .d(dff2_out), .q(dff3_out));


    always @(*) begin // if clk, d, sel changes, this also changes
        case(sel)
            2'b00: q = d;           // When sel is 00, output q = d
            2'b01: q = dff1_out;    // When sel is 01, output q = dff1_out
            2'b10: q = dff2_out;    // When sel is 10, output q = dff2_out
            2'b11: q = dff3_out;    // When sel is 11, output q = dff3_out
        endcase
    end




endmodule