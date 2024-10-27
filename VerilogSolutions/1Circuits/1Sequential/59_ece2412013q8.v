/*
Implement a Mealy-type finite state machine that recognizes the sequence "101" 
on an input signal named x.
Your FSM should have an output signal, z, that is asserted to logic-1 when 
the "101" sequence is detected.
Your FSM should also have an active-low asynchronous reset.
You may only have 3 states in your state machine.
Your FSM should recognize overlapping sequences.
*/


module top_module (
    input clk,
    input aresetn,
    input x,
    output z ); 

    parameter W = 0, F = 1, S = 2;
    reg[1:0] state, next_state;

    always @(*) begin
        if (state == W && !x) begin
            next_state = state;
        end
        else if (state == W && x) begin
            next_state = F;
        end
        else if (state == F && x) begin
            next_state = state;
        end
        else if (state == F && !x) begin
            next_state = S;
        end
        else if (state == S && !x) begin
            next_state = W;
        end
        else if (state == S && x) begin
            next_state = F;
        end

        // placeholder for removing latch warning
        else begin
            next_state = state;
        end
    end

    always @(posedge clk, negedge aresetn) begin
        state <= (!aresetn) ? W : next_state;
    end

    assign z = (state == S) && (next_state == F);

endmodule