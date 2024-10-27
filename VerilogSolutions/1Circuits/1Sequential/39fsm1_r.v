/*

This is a Moore state machine with two states, one input, and one output. 
Implement this state machine. Notice that the reset state is B.

This exercise is the same as fsm1, but using synchronous reset.

*/


module top_module(clk, reset, in, out);
    input clk;
    input reset;
    input in;
    output out;
    reg out;

    parameter A=0, B=1; 
    reg present_state, next_state;

    if (in) begin
        next_state = present_state;
    end
    else begin
        next_state = !present_state;
    end

    always @(posedge clk) begin
        if (reset) begin  
            present_state <= B;
        else
            present_state <= next_state;   
        end
    end

    assign out = (present_state == B);

endmodule