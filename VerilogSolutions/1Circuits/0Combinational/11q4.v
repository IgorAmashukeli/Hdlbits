/*

Implement the circuit, shown on the picture by the following link

https://hdlbits.01xz.net/wiki/File:Mt2015_q4.png

*/



module top_module (input x, input y, output z);

    wire instA1_out;
    wire instA2_out;
    wire instB1_out;
    wire instB2_out;
    wire inst1_out;
    wire inst2_out;

    Amodule instanceA1 ( .x(x), .y(y), .z(instA1_out));
    Amodule instanceA2 ( .x(x), .y(y), .z(instA2_out));

    Bmodule instanceB1 ( .x(x), .y(y), .z(instB1_out));
    Bmodule instanceB2 ( .x(x), .y(y), .z(instB2_out));

    assign inst1_out = instA1_out || instA2_out;
    assign inst2_out = instB1_out && instB2_out;

    assign z = inst1_out ^ inst2_out;

    



endmodule


module Amodule (input x, input y, output z);

    assign z = (x ^ y) && x;

endmodule


module Bmodule ( input x, input y, output z );

    assign z = !(x ^ y);

endmodule

