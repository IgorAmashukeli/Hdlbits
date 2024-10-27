/*
You are to design a one-input one-output serial 2's complementer Moore state machine. 
The input (x) is a series of bits (one per clock cycle) beginning 
with the least-significant bit of the number, and the output (Z) is the 2's complement of the input. 
The machine will accept input numbers of arbitrary length. 
The circuit requires an asynchronous reset. 
The conversion begins when Reset is released and stops when Reset is asserted.
*/


// two's complement of M is ~M + 1
module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    reg carry, next_carry, next_z, cur_z;

    always @(*) begin
        // how to calculate next carry
        next_carry = (carry && !x);

        // how to calculate z
        // it should be outputed on the next cycle
        next_z = carry ^ !x;
    end

    always @(posedge clk, posedge areset) begin
        // changing carry
        // if reset -> carry = 1
        carry <= (areset) ? 1'b1 : next_carry;
        // changing z
        // if reset -> z = 0, 
        // because, we output carry ^ !x[0] only on the next cycle
        // and on this cycle we output nothing
        cur_z <= (areset) ? 1'b0 : next_z;
    end

    assign z = cur_z;

endmodule