/*
See also: Lemmings1.

In addition to walking left and right, Lemmings will fall (and presumably go "aaah!") if the ground disappears underneath them.

In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". 
When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. 
Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), 
or when the ground reappears while still falling, also does not affect the walking direction.

Build a finite state machine that models this behaviour.
*/


module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 


    parameter LEFT = 0, RIGHT = 1, LEFT_FALLING = 2, RIGHT_FALLING = 3;

    wire[2:0] state, next_state;

    always @(*) begin
        if (state == LEFT && ground == 0) begin
            next_state = LEFT_FALLING;
        end
        else if (state == LEFT && bump_left) begin
            next_state = RIGHT;
        end
        else if (state == LEFT) begin
            next_state = state;
        end
        else if (state == RIGHT && ground == 0) begin
            next_state = RIGHT_FALLING;
        end
        else if (state == RIGHT && bump_right) begin
            next_state = LEFT;
        end
        else if (state == RIGHT) begin
            next_state = state;
        end
        else if (state == LEFT_FALLING && ground == 1) begin
            next_state = LEFT;
        end
        else if (state == LEFT_FALLING) begin
            next_state = LEFT_FALLING;
        end
        else if (state == RIGHT_FALLING && ground == 1) begin
            next_state = RIGHT;
        end
        else if (state == RIGHT_FALLING) begin
            next_state = state;
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
            state <= next_state;
        end
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aah = (state == LEFT_FALLING || state == RIGHT_FALLING);

endmodule