/*
Consider the state machine shown below, which has one input w and one output z.
https://hdlbits.01xz.net/wiki/File:Exams_m2014q6.png

Implement the state machine. 
(This part wasn't on the midterm, but coding up FSMs is good practice).
*/


module top_module (
    input clk,
    input reset,
    input w,
    output z);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg[3:1] state, next_state;

    always @(*) begin
        case(state)
            A: next_state = (w) ? A : B;
            B: next_state = (w) ? D : C;
            C: next_state = (w) ? D : E;
            D: next_state = (w) ? A : F;
            E: next_state = (w) ? D : E;
            F: next_state = (w) ? D : C;
        endcase
    end


    always @(posedge clk) begin
        state <= (reset) ? 6'b000001 : next_state;
    end

    assign z = (state == E) || (state == F);

endmodule