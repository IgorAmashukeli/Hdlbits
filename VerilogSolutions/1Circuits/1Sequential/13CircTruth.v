/*

A JK flip-flop has the below truth table. Implement a JK flip-flop with only a D-type flip-flop and gates. Note: Qold is the output of the D flip-flop before the positive clock edge.

J	K	Q
0	0	Qold
0	1	0
1	0	1
1	1	~Qold
*/

module top_module (
    input clk,
    input j,
    input k,
    output Q); 

    always @(posedge clk) begin

        // if j != k
        // assign Q the j value on the next positive edge
        if (j ^ k) begin
            Q <= j;
        end
        // if j == 1 (k == j, because else), change negate the previous value
        else if (j) begin
                Q <= !Q;
        end
        // otherwise don't do anything : it is a latch

    end

endmodule