/*

Rule 110 is a one-dimensional cellular automaton with interesting properties (such as being Turing-complete).

There is a one-dimensional array of cells (on or off). At each time step, the state of each cell changes. 
In Rule 110, the next state of each cell depends only on itself and its two neighbours, according to the following table:

Left	Center	Right	Center's next state
1	1	1	0
1	1	0	1
1	0	1	1
1	0	0	0
0	1	1	1
0	1	0	1
0	0	1	1
0	0	0	0
(The name "Rule 110" comes from reading the "next state" column: 01101110 is decimal 110.)

In this circuit, create a 512-cell system (q[511:0]), and advance by one time step each clock cycle. 
The load input indicates the state of the system should be loaded with data[511:0]. Assume the boundaries (q[-1] and q[512]) are both zero (off).
*/


module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 

    dff_load dffs [511:0] (
        .clk({512{clk}}),
        .load({512{load}}),
        .l({1'b0, q[511:1]}),
        .r({q[510:0], 1'b0}),
        .d(d),
        .q(q)
    );

endmodule



module dff_load(
    input clk,
    input load,
    input l,
    input r,
    input d,
    output q
);

    always @(posedge clk) begin
        q <= (load) ? d : !(l && q && r || !l && !q && !r || l && !q && !r) ;
    end

endmodule





