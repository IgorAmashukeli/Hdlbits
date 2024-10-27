/*
One drawback of the ripple carry adder (See previous exercise) is that the delay for an adder to compute the carry out (from the carry-in, in the worst case) is fairly slow,
and the second-stage adder cannot begin computing its carry-out until the first-stage adder has finished.
This makes the adder slow. One improvement is a carry-select adder, shown below.
The first-stage adder is the same as before, but we duplicate the second-stage adder,
one assuming carry-in=0 and one assuming carry-in=1, then using a fast 2-to-1 multiplexer to select which result happened to be correct.

In this exercise, you are provided with the same module add16 as the previous exercise, which adds two 16-bit numbers with carry-in and produces a carry-out and 16-bit sum. 
You must instantiate three of these to build the carry-select adder, using your own 16-bit 2-to-1 multiplexer.

Connect the modules together as shown in the diagram below. The provided module add16 has the following declaration:

module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );
*/

module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire add16_lower_carry_out;
    wire[15:0] add16_upper_carry0_sum;
    wire[15:0] add16_upper_carry1_sum;
    wire add16_upper_carry_0_carry_out;
    wire add16_upper_carry_1_carry_out;

    add16 lower_adder(a[15:0], b[15:0], 0, sum[15:0], add16_lower_carry_out);

    add16 upper_adder_carry0(a[31:16], b[31:16], 0, add16_upper_carry0_sum, add16_upper_carry_0_carry_out);
    add16 upper_adder_carry1(a[31:16], b[31:16], 1, add16_upper_carry1_sum, add16_upper_carry_0_carry_out);

    always @(*) begin
        case(add16_lower_carry_out)
            1'b0: sum[31:16] = add16_upper_carry0_sum;
            1'b1: sum[31:16] = add16_upper_carry1_sum;

        endcase
    
    end



endmodule