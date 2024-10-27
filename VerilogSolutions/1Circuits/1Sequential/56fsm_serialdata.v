/*
See also: Serial receiver

Now that you have a finite state machine that can identify when bytes are correctly received in
 a serial bitstream, add a datapath that will output the correctly-received data byte. 
out_byte needs to be valid when done is 1, and is don't-care otherwise.

Note that the serial protocol sends the least significant bit first.
*/

module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
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

        // we are using next_state and next_count
        // because these are already correctly calculated
        // values of the current state and current count
        // state and count will be correctly calculated
        // only on the positive edge of the next cycle of the clock
        // this out_byte will have the correct value
        // on the next cycle at the stop
        // so it will have the correct value at the next cycle
        if (next_state == BYTE) begin
            out_byte[next_count] <= in;
        end
        else begin
        end
    end

    assign done = (is_ok);


endmodule