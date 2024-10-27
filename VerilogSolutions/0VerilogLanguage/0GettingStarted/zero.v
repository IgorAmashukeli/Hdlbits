/*
Build a circuit with no inputs and one output that outputs a constant 0
*/

module top_module(output zero);
    
    // width is 0 bit
    // format is binary
    // value is 1
    assign zero = 1'b0;

endmodule