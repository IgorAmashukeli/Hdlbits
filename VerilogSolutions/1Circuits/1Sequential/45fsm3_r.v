module top_module(
    input clk,
    input in,
    input reset,
    output out);

    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg[1:0] state;
    reg[1:0] next_state;

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

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end


    assign out = (state == D);
    

endmodule
