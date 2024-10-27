/*
See also: State transition logic for this FSM
The following is the state transition table for a Moore state machine with one input, one output, and four states. 
Implement this state machine. Include an asynchronous reset that resets the FSM to state A.

State	Next state	Output
in=0	in=1
A	A	B	0
B	C	B	0
C	A	D	0
D	C	B	1
*/



module top_module(
    input clk,
    input in,
    input areset,
    output out);

    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg[2:0] state, next_state;

    always @(*) begin
        if ((state == A && !in) || (state == C && !in)) begin
            next_state = A;
        end
        else if ((state == A && in) || (state == B && in) || (state == D && in)) begin
            next_state = B;
        end
        else if ((state == B && !in) || (state == D && !in)) begin
            next_state = C;
        end
        else begin
            next_state = D;
        end
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end


    assign out = (state[D]);
    

endmodule


