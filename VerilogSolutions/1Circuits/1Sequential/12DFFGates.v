/*

Given the finite state machine circuit as shown, assume that the D flip-flops are initially reset to zero before the machine begins.

Build this circuit.

*/


module top_module (
    input clk,
    input x,
    output z
);

    wire q1;
    wire not_q1;
    wire q2;
    wire not_q2;
    wire q3;
    wire not_q3;

    // the first data flip flop
    my_dff dff1 (

        // clock
        .clk(clk),

        // input of the first data flip flop is x xor its output
        .d(x ^ q1),

        // output of the first data flip flop
        .q(q1),

        // complement output of the first data flip flop
        .not_q(not_q1)
    );


    my_dff dff2 (

        // clock
        .clk(clk),

        // input of the second data flip flop is x and its complement output
        .d(x && not_q2),

        // output of the second data flip flop
        .q(q2),

        // complement output of the second data flip flop
        .not_q(not_q2)
    );


    my_dff dff3 (

        // clock
        .clk(clk),

        // input of the third data flop flop is x or its complement output
        .d(x || not_q3),

        // output of the third data flop flop
        .q(q3),


        // complement output of the third data flip flop
        .not_q(not_q3)

    );

    // assign z = NOR(q1, q2, q3)
    assign z = !(q1 || q2 || q3);

endmodule


module my_dff (
    input clk,
    input d,
    output q,
    output not_q
);

    // flip flop
    always @(posedge clk) begin
        q <= d;
    end

    // calculate complement
    assign not_q = !q;


endmodule
