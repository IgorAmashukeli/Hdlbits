/*
We want to create a timer that:

is started when a particular pattern (1101) is detected,
shifts in 4 more bits to determine the duration to delay,
waits for the counters to finish counting, and
notifies the user and waits for the user to acknowledge the timer.
In this problem, implement just the finite-state machine that controls the timer. 
The data path (counters and some comparators) are not included here.

The serial data is available on the data input pin. When the pattern 1101 is received, 
the state machine must then assert output shift_ena for exactly 4 clock cycles.

After that, the state machine asserts its counting output to indicate it is waiting for the counters, 
and waits until input done_counting is high.

At that point, 
the state machine must assert done to notify the user the timer has timed out, 
and waits until input ack is 1 before being reset to look for the next occurrence 
of the start sequence (1101).

The state machine should reset into a state where it begins searching for the input sequence 1101.

Here is an example of the expected inputs and outputs. 
The 'x' states may be slightly confusing to read. 
They indicate that the FSM should not care about that particular input signal in that cycle. 
For example, once a 1101 pattern is detected, 
the FSM no longer looks at the data input until it resumes searching after everything else is done.
*/



module top_module (
    input clk,
    input reset,
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );

    parameter S = 0, S1 = 1, S11 = 2, S110 = 3,
    B0 = 4, B1 = 5, B2 = 6, B3 = 7,
    COUNT = 8, WAIT = 9;
    reg[3:0] state, next_state;

    always @(*) begin
        case(state)
            S: next_state = (data) ? S1 : S;
            S1: next_state = (data) ? S11 : S;
            S11: next_state = (!data) ? S110 : S11;
            S110: next_state = (data) ? B0 : S;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = COUNT;
            COUNT: next_state = (done_counting) ? WAIT : COUNT;
            WAIT: next_state = (ack) ? S : WAIT;
        endcase
    end


    always @(posedge clk) begin
        state <= (reset) ? S : next_state;
    end

    assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);
    assign counting = (state == COUNT);
    assign done = (state == WAIT);
    
endmodule


