/*

This is a Moore state machine with two states, two inputs, and one output. Implement this state machine.

This exercise is the same as fsm2s, but using asynchronous reset.

*/


module top_module(
    input clk,
    input areset,
    input j,
    input k,
    output out);

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        if (state == OFF && j == 1 || state == ON && k == 0) begin
            next_state = ON;
        end
        else if (state == OFF && j == 0 || state == ON && k == 1) begin
            next_state = OFF;
        end
        else begin
            next_state = next_state;
        end
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= OFF;
        end
        else begin
            state <= next_state;
        end
        
    end

    assign out = (state == ON);

endmodule