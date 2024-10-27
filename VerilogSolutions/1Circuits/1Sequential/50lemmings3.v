/*
See also: Lemmings1 and Lemmings2.

In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when dig=1). 
A Lemming can dig if it is currently walking on ground (ground=1 and not falling), and will continue digging until it reaches the other side (ground=0). 
At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. 
As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored.

(In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, 
fall has higher precedence than dig, which has higher precedence than switching directions.)

Extend your finite state machine to model this behaviour.
*/


module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter LEFT = 0, RIGHT = 1, DIG_LEFT = 2, DIG_RIGHT = 3, FALL_LEFT = 4, FALL_RIGHT = 5;

    reg[2:0] state, next_state;


    always @(*) begin
        if (state == LEFT && !ground) begin
            next_state = FALL_LEFT;
        end
        else if (state == LEFT && dig) begin
            next_state = DIG_LEFT;
        end
        else if (state == LEFT && bump_left) begin
            next_state = RIGHT;
        end
        else if (state == LEFT) begin
            next_state = state;
        end
        else if (state == RIGHT && !ground) begin
            next_state = FALL_RIGHT;
        end
        else if (state == RIGHT && dig) begin
            next_state = DIG_RIGHT;
        end
        else if (state == RIGHT && bump_right) begin
            next_state = LEFT;
        end
        else if (state == RIGHT) begin
            next_state = state;
        end
        else if (state == DIG_LEFT && !ground) begin
            next_state = FALL_LEFT;
        end
        else if (state == DIG_LEFT) begin
            next_state = state;
        end
        else if (state == DIG_RIGHT && !ground) begin
            next_state = FALL_RIGHT;
        end
        else if (state == DIG_RIGHT) begin
            next_state = state;
        end
        else if (state == FALL_LEFT && ground) begin
            next_state = LEFT;
        end
        else if (state == FALL_LEFT) begin
            next_state = state;
        end
        else if (state == FALL_RIGHT && ground) begin
            next_state = RIGHT;
        end
        else if (state == FALL_RIGHT) begin
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
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule