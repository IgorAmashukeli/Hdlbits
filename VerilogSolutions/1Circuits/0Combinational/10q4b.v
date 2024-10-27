/*

Implement the following circuit

x/y/z low  low  high
      high low  low
      low  high low
      high high high
*/


module top_module ( input x, input y, output z );

    assign z = !(x ^ y);

endmodule