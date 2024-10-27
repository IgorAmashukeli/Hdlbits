/*
Consider a finite state machine with inputs s and w. 
Assume that the FSM begins in a reset state called A, as depicted below. 
The FSM remains in state A as long as s = 0, and it moves to state B when s = 1. 
Once in state B the FSM examines the value of the input w in the next three clock cycles. 
If w = 1 in exactly two of these clock cycles, 
then the FSM has to set an output z to 1 in the following clock cycle. 
Otherwise z has to be 0. The FSM continues checking w for the next three clock cycles, and so on. 
The timing diagram below illustrates the required values of z for different values of w.

Use as few states as possible. 
Note that the s input is used only in state A, so you need to consider just the w input.
*/


module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    parameter A = 0, B1 = 1, B2 = 2, B3 = 3;
    reg[1:0] state, next_state;
    reg[3:0] count, next_count;
    reg cur_z, next_z;

    always @(*) begin
        if (state == A && !s) begin
            next_state = state;
            next_count = 4'd0;
            next_z = 1'b0;
        end
        else if (state == A && s) begin
            next_state = B1;
            next_count = 4'd0;
            next_z = 1'b0;
        end
        else if (state == B1) begin
            next_state = B2;
            next_count = count + {3'd0, w};
            next_z = 1'b0;
        end
        else if (state == B2) begin
            next_state = B3;
            next_count = count + {3'd0, w};
            next_z = 1'b0;
        end
        else if (state == B3) begin
            next_state = B1;
            // z is calculated on B3 step
            // z is assigned on the step after B3
            next_z = (count == 4'd2 && !w) || (count == 4'd1 && w);

            // next state is already B1
            // so, we need to make next_count = 0
            // therefore, we need to 
            next_count = 4'd0;
        end
        else begin
            next_state = state;
            next_count = count;
            next_z = 1'b0;
        end
    end

    always @(posedge clk) begin
        state <= (reset) ? A : next_state;
        count <= (reset) ? 4'd0 : next_count;
        cur_z <= (reset) ? 1'd0 : next_z;
    end

    assign z = cur_z;
    

endmodule