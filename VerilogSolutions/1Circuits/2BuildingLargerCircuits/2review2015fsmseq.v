/*
This is the second component in a series of five exercises that builds a complex counter out of several smaller circuits. 
See the final exercise for the overall design.

Build a finite-state machine that searches for the sequence 1101 in an input bit stream. 
When the sequence is found, it should set start_shifting to 1, forever, until reset. 
Getting stuck in the final state is intended to model going to other states in a bigger FSM that is not yet implemented. 
We will be extending this FSM in the next few exercises.
*/


module top_module (
    input clk,
    input reset,
    input data,
    output start_shifting);

    parameter START = 0, FIRST = 1, SECOND = 2, THIRD = 3, FOURTH = 4;
    reg[] state, next_state;

    always @(*) begin
        case (state)
            START: next_state = (data) ? FIRST : state;
            FIRST: next_state = (data) ? SECOND : START;
            SECOND: next_state = (data) ? SECOND : THIRD;
            THIRD: next_state = (data) ? FOURTH : START;
            FOURTH: next_state = state;
            default: next_state = state;
        endcase
    end

    always @(posedge clk) begin
        state <= (reset) ? A : next_state;
    end

    assign start_shifting = (state == FOURTH);

endmodule