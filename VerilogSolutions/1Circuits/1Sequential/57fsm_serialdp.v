/*
See also: Serial receiver and datapath

We want to add parity checking to the serial receiver. 
Parity checking adds one extra bit after each data byte. 
We will use odd parity, where the number of 1s in the 9 bits received must be odd. 
For example, 101001011 satisfies odd parity (there are 5 1s), but 001001011 does not.

Change your FSM and datapath to perform odd parity checking. 
Assert the done signal only if a byte is correctly received and its parity check passes. 
Like the serial receiver FSM, this FSM needs to identify the start bit, wait for all 9 
(data and parity) bits, then verify that the stop bit was correct. 
If the stop bit does not appear when expected, 
the FSM must wait until it finds a stop bit before attempting to receive the next byte.

You are provided with the following module that can be used to calculate 
the parity of the input stream (It's a TFF with reset). 
The intended use is that it should be given the input bit stream, 
and reset at appropriate times so it counts the number of 1 bits in each byte.

module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule

Note that the serial protocol sends the least significant bit first, 
and the parity bit after the 8 data bits.
*/



module top_module(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    parameter START_WAIT = 0, START = 1, BYTE = 2, PARITY = 3, STOP_WAIT = 4, STOP = 5;
    parameter LAST_BIT = 7;
    reg[2:0] state;
    reg[2:0] next_state;
    reg odd;
    wire next_odd;
    reg is_ok; 
    reg next_is_ok;

    reg[6:0] count;
    wire[6:0] next_count;

    parity par_mod (
        .clk(clk),
        .reset(!(next_state == BYTE || next_state == PARITY)),
        .in(in),
        .odd(next_odd)
    );

    always @(*) begin
        case (state)
            START_WAIT: begin
                next_state = (!in) ? START : state;
                next_is_ok = 1'b0;
            end
            START: begin 
                next_state = BYTE;
                next_is_ok = 1'b0;
            end
            BYTE: begin
                next_state = (count == LAST_BIT) ? PARITY : state;
                next_is_ok = 1'b0;
            end
            PARITY: begin
                next_state = (in) ? STOP : STOP_WAIT;
                next_is_ok = in;
            end
            STOP_WAIT: begin
                next_state = (in) ? STOP : state;
                next_is_ok = 1'b0;
            end
            STOP: begin
                next_state = (!in) ? START : START_WAIT;
                next_is_ok = 1'b0;
            end
            default : begin 
                next_state = state;
                next_is_ok = 1'b0;
            end
        endcase
    end

    assign next_count = (state == BYTE && count < LAST_BIT) ? count + 6'd1 : 6'd0;

    always @(posedge clk) begin
        state <= (reset) ? START_WAIT : next_state;
        count <= (reset) ? 6'd0 : next_count;
        is_ok <= (reset) ? 1'b0 : next_is_ok;
        odd <= next_odd;
        out_byte[next_count] <= (next_state == BYTE) ? in : out_byte[next_count];
    end


    assign done = (is_ok && odd);


endmodule



module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule

