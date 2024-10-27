/*
This is a sequential circuit. 
The circuit consists of combinational logic and one bit of memory (i.e., one flip-flop). 
The output of the flip-flop has been made observable through the output state.

Read the simulation waveforms to determine what the circuit does, then implement it.
*/



module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );

    parameter A = 0, B = 1;
    reg next_state;


    always @(*) begin
        if (state == A && a && b) begin
            next_state = B;
        end
        else if (state == A) begin
            next_state = state;
        end
        else if (state == B && !a && !b) begin
            next_state = A;
        end
        else if (state == B) begin
            next_state = state;
        end
        else begin
            next_state = state;
        end
    end


    always @(posedge clk) begin
        state <= next_state;
    end

    assign q = ((state == A) && (a != b)) || ((state == B) && (a == b));

endmodule
