/*
This is a Moore state machine with two states, one input, and one output. Implement this state machine. Notice that the reset state is B.

This exercise is the same as fsm1s, but using asynchronous reset.

https://hdlbits.01xz.net/wiki/File:Fsm1.png
*/


module top_module(
    input clk,
    input areset,
    input in,
    output out);  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin
        if (in) begin
            next_state = state;
        end
        else begin
            next_state = !state;
        end
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= B;
        end
        else begin
            state <= next_state;
        end
    end

    assign out = (state == B);


endmodule