/*
Synchronous HDLC framing involves decoding a continuous bit stream of data 
to look for bit patterns that indicate the beginning and end of frames (packets). 
Seeing exactly 6 consecutive 1s (i.e., 01111110) is a "flag" that indicate frame boundaries. 
To avoid the data stream from accidentally containing "flags", the sender inserts a zero after 
every 5 consecutive 1s which the receiver must detect and discard. 
We also need to signal an error if there are 7 or more consecutive 1s.

Create a finite state machine to recognize these three sequences:

0111110: Signal a bit needs to be discarded (disc).
01111110: Flag the beginning/end of a frame (flag).
01111111...: Error (7 or more 1s) (err).
When the FSM is reset, it should be in a state that behaves as though the previous input were 0.
*/


module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    // all possible states:
    // start - no ones so far
    // data - ones reading
    // 
    parameter IDLE = 0, DATA = 1, DISC = 3, FLAG = 4, ERROR = 5;
    reg [2:0] state, next_state;
    reg [7:0] count, next_count;

    always @(*) begin
        if (state == IDLE) begin
            next_state = (in) ? DATA : state;
            next_count = 8'd0;
        end
        else if (state == DATA) begin
            if (count < 8'd4 && in) begin
                next_state = state;
                next_count = count + 8'd1;
            end
            else if (count < 8'd4 && !in) begin
                next_state = IDLE;
                next_count = 8'd0;
            end
            else if (count == 8'd4 && !in) begin
                next_state = DISC;
                next_count = 8'd0;
            end
            else if (count == 8'd4 && in) begin
                next_state = state;
                next_count = count + 8'd1;
            end
            else if (count == 8'd5 && !in) begin
                next_state = FLAG;
                next_count = 8'd0;
            end
            else if (count == 8'd5 && in) begin
                next_state = ERROR;
                next_count = 8'd0;
            end
            else begin
                next_state = state;
                next_count = count;
            end
        end
        else if (state == DISC || state == FLAG) begin
            next_state = (in) ? DATA : IDLE;
            next_count = 8'd0;
        end
        else if (state == ERROR) begin
            next_state = (in) ? ERROR : IDLE;
            next_count = 8'd0;
        end
        else begin
            next_state = state;
            next_count = count;
        end

    end



    always @(posedge clk) begin
        state <= (reset) ? IDLE : next_state;
        count <= (reset) ? 8'd0 : next_count;
    end

    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err = (state == ERROR);

endmodule
