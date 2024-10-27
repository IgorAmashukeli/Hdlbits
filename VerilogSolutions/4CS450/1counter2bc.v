/*
Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. 
Each table entry usually uses two-bits of state because one-bit of state (remember last outcome) does not have enough hysteresis and flips states too easily.
*/


module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    parameter SNT = 0, WNT = 1, WT = 2, ST = 3;
    reg[1:0] cur_state, next_state;

    always @(*) begin
        if (!train_valid) begin
            next_state = cur_state;
        end
        else if (train_taken && cur_state == ST) begin
            next_state = cur_state;
        end
        else if (train_taken) begin
            next_state = cur_state + 2'd1;
        end
        else if (!train_taken && cur_state == SNT) begin
            next_state = cur_state;
        end
        else if (!train_taken) begin
            next_state = cur_state - 2'd1;
        end
        else begin
            next_state = cur_state;
        end
    end

    always @(posedge clk, posedge areset) begin
        cur_state <= (areset) ? 2'd1 : next_state;
    end

    assign state = cur_state;


endmodule

