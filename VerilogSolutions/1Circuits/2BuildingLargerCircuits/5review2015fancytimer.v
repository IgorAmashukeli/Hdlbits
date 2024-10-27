/*
This is the fifth component in a series of five exercises that builds a complex counter out of several smaller circuits. 
You may wish to do the four previous exercises first (counter, sequence recognizer FSM, FSM delay, and combined FSM).

We want to create a timer with one input that:

is started when a particular input pattern (1101) is detected,
shifts in 4 more bits to determine the duration to delay,
waits for the counters to finish counting, and
notifies the user and waits for the user to acknowledge the timer.
The serial data is available on the data input pin. When the pattern 1101 is received, 
the circuit must then shift in the next 4 bits, most-significant-bit first. 
These 4 bits determine the duration of the timer delay. I'll refer to this as the delay[3:0].

After that, the state machine asserts its counting output to indicate it is counting. 
The state machine must count for exactly (delay[3:0] + 1) * 1000 clock cycles. e.g., delay=0 means count 1000 cycles, 
and delay=5 means count 6000 cycles. Also output the current remaining time. This should be equal to delay for 1000 cycles, 
then delay-1 for 1000 cycles, and so on until it is 0 for 1000 cycles. When the circuit isn't counting, 
the count[3:0] output is don't-care (whatever value is convenient for you to implement).

At that point, the circuit must assert done to notify the user the timer has timed out, 
and waits until input ack is 1 before being reset to look for the next occurrence of the start sequence (1101).

The circuit should reset into a state where it begins searching for the input sequence 1101.

Here is an example of the expected inputs and outputs. The 'x' states may be slightly confusing to read. 
They indicate that the FSM should not care about that particular input signal in that cycle. 
For example, once the 1101 and delay[3:0] have been read, 
the circuit no longer looks at the data input until it resumes searching after everything else is done. 
In this example, the circuit counts for 2000 clock cycles because the delay[3:0] value was 4'b0001. 
The last few cycles starts another count with delay[3:0] = 4'b1110, which will count for 15000 cycles.
*/


module top_module (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack);

    parameter S = 0, S1 = 1, S11 = 2, S110 = 3,
    B0 = 4, B1 = 5, B2 = 6, B3 = 7,
    COUNT = 8, WAIT = 9;
    reg stop_count;
    reg start_count;
    reg shift_state;
    reg decrement;
    reg do_count;

    reg[3:0] state, next_state;
    reg[3:0] delay;
    reg [9:0] q;

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
            COUNT: next_state = (stop_count) ? WAIT : COUNT;
            WAIT: next_state = (ack) ? S : WAIT;
            default: next_state = state;
        endcase
    end

    always @(*) begin
        start_count = (state == B3);
        stop_count = (state == COUNT) && (q == 10'd999) && (delay == 4'd0);
        shift_state = (state == B0) || (state == B1) || (state == B2) || (state == B3);
        decrement = (state == COUNT) && (q == 10'd999) && (delay != 4'd0);
        do_count = (next_state == COUNT);
    end


    always @(posedge clk) begin
        if (shift_state) begin
            delay <= {delay[2], delay[1], delay[0], data};
        end
        else if (decrement) begin
            delay <= delay - 4'd1;
        end
    end

    always @(posedge clk) begin
        if (do_count) begin
            q <= (start_count || q == 10'd999) ? 10'd0 : q + 10'd1;
        end
    end

    always @(posedge clk) begin
        state <= (reset) ? S : next_state;
    end

    assign counting = (state == COUNT);
    assign done = (state == WAIT);
    assign count = delay;
    
endmodule




