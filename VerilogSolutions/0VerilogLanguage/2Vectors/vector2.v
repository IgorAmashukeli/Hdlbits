/*
A 32-bit vector can be viewed as containing 4 bytes (bits [31:24], [23:16], etc.). Build a circuit that will reverse the byte ordering of the 4-byte word.

AaaaaaaaBbbbbbbbCcccccccDddddddd => DdddddddCcccccccBbbbbbbbAaaaaaaa
This operation is often used when the endianness of a piece of data needs to be swapped, 
for example between little-endian x86 systems and the big-endian formats used in many Internet protocols.
*/


module top_module( 
    input [31:0] in,
    output [31:0] out );

    assign out[24+:8] = in[0+:8];
    assign out[16+:8] = in[8+:8];
    assign out[8+:8] = in[16+:8];
    assign out [0+:8] = in[24+:8];

endmodule