/*
The PS/2 mouse protocol sends messages that are three bytes long. 
However, within a continuous byte stream, it's not obvious where messages start and end. 
The only indication is that the first byte of each three byte message always has bit[3]=1 
(but bit[3] of the other two bytes may be 1 or 0 depending on data).

We want a finite state machine that will search for message boundaries 
when given an input byte stream. 
The algorithm we'll use is to discard bytes until we see one with bit[3]=1. 
We then assume that this is byte 1 of a message, 
and signal the receipt of a message once all 3 bytes have been received (done).

The FSM should signal done in the cycle immediately after the third byte 
of each message was successfully received.

Under error-free conditions, every three bytes form a message.
When an error occurs, search for byte 1.
Note that this is not the same as a 1xx sequence recognizer. 
Overlapping sequences are not allowed here:
*/


module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //


    parameter WAIT = 0, FIRST = 1, SECOND = 2, THIRD = 3;
    reg[1:0] state;
    reg[1:0] prev_state;
    reg[1:0] next_state;

    // State transition logic (combinational)
    always @(*) begin
        if (state == WAIT && in[3]) begin
            next_state = FIRST;
        end
        else if (state == WAIT) begin
            next_state = state;
        end
        else if (state == FIRST) begin
            next_state = SECOND;
        end
        else if (state == SECOND) begin
            next_state = THIRD;
        end
        else if (state == THIRD && in[3]) begin
            next_state = FIRST;
        end
        else if (state == THIRD) begin
            next_state = WAIT;
        end
    end
    

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= state;
            state <= WAIT;
        end
        else begin
            prev_state <= state;
            state <= next_state;
        end
    end
 
    // Output logic
    assign done = (prev_state == THIRD);

endmodule