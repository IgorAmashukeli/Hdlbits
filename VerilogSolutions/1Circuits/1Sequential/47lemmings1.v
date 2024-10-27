/*
The game Lemmings involves critters with fairly simple brains. 
So simple that we are going to model it using a finite state machine.

In the Lemmings' 2D world, Lemmings can be in one of two states: walking left or walking right. 
It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left, it will walk right. 
If it's bumped on the right, it will walk left. If it's bumped on both sides at the same time, it will still switch directions.

Implement a Moore state machine with two states, two inputs, and one output that models this behaviour.
*/


module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right);  

    parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        if (state == LEFT && bump_left) begin
            state = RIGHT;
        end
        else if (state == RIGHT && bump_right) begin
            state = LEFT;
        end
        else begin
            next_state = state;
        end
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            next_state <= state;
        end
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule
