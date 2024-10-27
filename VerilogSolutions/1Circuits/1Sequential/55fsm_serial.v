/*

In many (older) serial communications protocols, each data byte is sent along 
with a start bit and a stop bit, to help the receiver delimit bytes from the stream of bits. 
One common scheme is to use one start bit (0), 8 data bits, and 1 stop bit (1). 
The line is also at logic 1 when nothing is being transmitted (idle).

Design a finite state machine that will identify when bytes have been correctly received 
when given a stream of bits. 
It needs to identify the start bit, wait for all 8 data bits, 
then verify that the stop bit was correct. 
If the stop bit does not appear when expected, 
the FSM must wait until it finds a stop bit before attempting to receive the next byte.
*/


module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
);

    parameter START_WAIT = 0, START = 1, BYTE = 2, STOP_WAIT = 3, STOP = 4;
    parameter LAST_BIT = 7;
    reg[2:0] state, next_state;
    reg is_ok, next_is_ok;

    reg[6:0] count, next_count;


    always @(*) begin
        if (state == START_WAIT && !in) begin
            next_state = START;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == START_WAIT) begin
            next_state = state;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == START) begin
            next_state = BYTE;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == BYTE && count < LAST_BIT) begin
            next_state = BYTE;
            next_count = count + 1;
            next_is_ok = 1'b0;
        end
        else if (state == BYTE && in) begin
            next_state = STOP;
            next_count = 6'd0;
            next_is_ok = 1'b1;
        end
        else if (state == BYTE) begin
            next_state = STOP_WAIT;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == STOP_WAIT && in) begin
            next_state = STOP;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == STOP_WAIT) begin
            next_state = STOP_WAIT;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == STOP && !in) begin
            next_state = START;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else if (state == STOP) begin
            next_state = START_WAIT;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
        else begin
            next_state = state;
            next_count = 6'd0;
            next_is_ok = 1'b0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= START_WAIT;
            count <= 6'd0;
            is_ok <= 1'b0;
        end
        else begin
            state <= next_state;
            count <= next_count;
            is_ok <= next_is_ok;
        end
    end

    assign done = (is_ok);


endmodule