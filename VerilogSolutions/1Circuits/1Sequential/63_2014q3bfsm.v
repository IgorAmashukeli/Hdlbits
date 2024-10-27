/*
Given the state-assigned table shown below, implement the finite-state machine. 
Reset should reset the FSM to state 000.

Present state
y[2:0]	Next state Y[2:0]	Output z
            x=0	x=1
000	        000 001	           0
001	        001	100	           0
010	        010	001	           0
011	        001	010	           1
100	        011	100	           1
*/


module top_module (
    input clk,
    input reset,
    input x,
    output z
);

    reg[2:0] y, Y;

    always @(*) begin
        case(y)
            3'b000: Y = (x) ? 3'b001 : 3'b000;
            3'b001: Y = (x) ? 3'b100 : 3'b001;
            3'b010: Y = (x) ? 3'b001 : 3'b010;
            3'b011: Y = (x) ? 3'b010 : 3'b001;
            3'b100: Y = (x) ? 3'b100 : 3'b011; 
        endcase
    end

    always @(posedge clk) begin
        y <= (reset) ? 3'b0 : Y;
    end

    assign z = (y == 3'b011) || (y == 3'b100);

endmodule