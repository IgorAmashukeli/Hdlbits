/*
Now that you have a state machine that will identify three-byte messages in a PS/2 byte stream, 
add a datapath that will also output the 24-bit (3 byte) message whenever a packet is received 
(out_bytes[23:16] is the first byte, out_bytes[15:8] is the second byte, etc.).

out_bytes needs to be valid whenever the done signal is asserted. 
You may output anything at other times (i.e., don't-care).

For example:
*/


module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    // FSM from fsm_ps2
    parameter WAIT = 0, FIRST = 1, SECOND = 2, THIRD = 3;
    reg[1:0] state, next_state;

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

    // New: Datapath to store incoming bytes.
    always @(posedge clk) begin

        if (reset) begin
            state <= WAIT;
        end
        else begin
            state <= next_state;
        end

        // we are using next_state
        // it is the state that was calculated
        // just on this posedge
        // state will be equal to FIRST, TWO, THIRD
        // on the positive edge of the next cycle
        // if the current state is correct
        // we save out_bytes to memory
        // so we will save all bytes
        // the first will be inputed on FIRST and outputed on TWO
        // the second will be inputed on TWO and outputed on THIRD
        // the third will be inputed on THIRD and outputed on the next
        // together with the done flag
        if (next_state == FIRST) begin
            out_bytes[23:16] <= in;
        end
        else if (next_state == SECOND) begin
            out_bytes[15:8] <= in;
        end
        else if (next_state == THIRD) begin
            out_bytes[7:0] <= in;
        end
    end

    assign done = (state == THIRD);

endmodule