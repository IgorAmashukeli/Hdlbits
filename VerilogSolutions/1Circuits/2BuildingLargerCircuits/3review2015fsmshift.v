/*
This is the third component in a series of five exercises that builds
a complex counter out of several smaller circuits. 
See the final exercise for the overall design.

As part of the FSM for controlling the shift register, 
we want the ability to enable the shift register for exactly 4 clock cycles 
whenever the proper bit pattern is detected. 
We handle sequence detection in Exams/review2015_fsmseq, 
so this portion of the FSM only handles enabling the shift register for 4 cycles.

Whenever the FSM is reset, assert shift_ena for 4 cycles, then 0 forever (until reset).
*/


module top_module (
    input clk,
    input reset,
    output shift_ena);

    parameter START1 = 0, START2 = 1, START3 = 2, START4 = 3, IDLE = 4;
    reg[2:0] state, next_state;

    always @(*) begin
        case(state)
            START1: next_state = START2;
            START2: next_state = START3;
            START3: next_state = START4;
            START4: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        state <= (reset) ? START1 : next_state;
    end

    assign shift_ena = (state != IDLE);

endmodule