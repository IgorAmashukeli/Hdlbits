/*

See also: Lemmings1, Lemmings2, and Lemmings3.

Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. 
If a Lemming falls for too long then hits the ground, it can splatter. 
In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, 
falling, or digging (all 4 outputs become 0), 
forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. 
Lemmings only splatter when hitting the ground; 
they do not splatter in mid-air.

Extend your finite state machine to model this behaviour.

Falling for 20 cycles is survivable:

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

    parameter LEFT = 3'b000, RIGHT = 3'b001, DIG_LEFT = 3'b010, DIG_RIGHT = 3'b011, FALL_LEFT = 3'b100, FALL_RIGHT = 3'b101, SPLATTER = 3'b110;
    parameter LIM_FALL = 8'd20;

    reg[2:0] state, next_state;
    reg[7:0] count, next_count;


    always @(*) begin
        if (state == LEFT && !ground) begin
            next_state = FALL_LEFT;
            next_count = count;
        end
        else if (state == LEFT && dig) begin
            next_state = DIG_LEFT;
            next_count = count;
        end
        else if (state == LEFT && bump_left) begin
            next_state = RIGHT;
            next_count = count;
        end
        else if (state == LEFT) begin
            next_state = state;
            next_count = count;
        end
        else if (state == RIGHT && !ground) begin
            next_state = FALL_RIGHT;
            next_count = count;
        end
        else if (state == RIGHT && dig) begin
            next_state = DIG_RIGHT;
            next_count = count;
        end
        else if (state == RIGHT && bump_right) begin
            next_state = LEFT;
            next_count = count;
        end
        else if (state == RIGHT) begin
            next_state = state;
            next_count = count;
        end
        else if (state == DIG_LEFT && !ground) begin
            next_state = FALL_LEFT;
            next_count = count;
        end
        else if (state == DIG_LEFT) begin
            next_state = state;
            next_count = count;
        end
        else if (state == DIG_RIGHT && !ground) begin
            next_state = FALL_RIGHT;
            next_count = count;
        end
        else if (state == DIG_RIGHT) begin
            next_state = state;
            next_count = count;
        end
        else if (state == FALL_LEFT && ground && count >= LIM_FALL) begin
            next_state = SPLATTER;
            next_count = 8'd0;
        end
        else if (state == FALL_LEFT && ground) begin
            next_state = LEFT;
            next_count = 8'd0;
        end
        else if (state == FALL_LEFT) begin
            next_state = state;
            next_count = count + 8'd1;
        end
        else if (state == FALL_RIGHT && ground && count >= LIM_FALL) begin
            next_state = SPLATTER;
            next_count = 8'd0;
        end
        else if (state == FALL_RIGHT && ground) begin
            next_state = RIGHT;
            next_count = 8'd0;
        end
        else if (state == FALL_RIGHT) begin
            next_state = state;
            next_count = count + 8'd1;
        end
        else if (state == SPLATTER) begin
            next_state = SPLATTER;
            next_count = count;
        end
        else begin
            next_state = state;
            next_count = count;
        end
    end


    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            count <= 8'd0;
        end
        else begin
            state <= next_state;
            count <= next_count;
        end
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule