/*
Consider a finite state machine that is used to control some type of motor. 
The FSM has inputs x and y, which come from the motor, and produces outputs f and g, 
which control the motor. There is also a clock input called clk and a reset input called resetn.

The FSM has to work as follows. 
As long as the reset input is asserted, the FSM stays in a beginning state, called state A. 
When the reset signal is de-asserted, then after the next clock edge the FSM has to set 
the output f to 1 for one clock cycle. Then, the FSM has to monitor the x input. 
When x has produced the values 1, 0, 1 in three successive clock cycles, 
then g should be set to 1 on the following clock cycle. 
While maintaining g = 1 the FSM has to monitor the y input. 
If y has the value 1 within at most two clock cycles, 
then the FSM should maintain g = 1 permanently (that is, until reset). 
But if y does not become 1 within two clock cycles, 
then the FSM should set g = 0 permanently (until reset).

(The original exam question asked for a state diagram only. But here, implement the FSM.)
*/

module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    parameter A = 0, B = 1, C1 = 2, C2 = 3, C3 = 4, C4 = 5, C5 = 6, C6 = 7, C7 = 8;

    reg[3:0] state, next_state;
    
    always @(*) begin
        if (state == A && resetn) begin
            next_state = B;
        end
        else if (state == B) begin
            next_state = C1;
        end
        else if (state == C1) begin
            next_state = (x) ? C2 : C1;
        end
        else if (state == C2) begin
            next_state = (!x) ? C3 : C2;
        end
        else if (state == C3) begin
            next_state = (x) ? C4 : C1;
        end
        else if (state == C4) begin
            next_state = (y) ? C5 : C6;
        end
        else if (state == C5) begin
            next_state = state;
        end
        else if (state == C6) begin
            next_state = (y) ? C5 : C7;
        end
        else if (state == C7) begin
            next_state = state;
        end
        else begin
            next_state = state;
        end
    end


    always @(posedge clk) begin
        state <= (!resetn) ? A : next_state;
    end

    assign f = (state == B);
    assign g = (state == C4) || (state == C5) || (state == C6);

endmodule
