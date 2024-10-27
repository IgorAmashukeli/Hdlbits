/*
Conway's Game of Life is a two-dimensional cellular automaton.

The "game" is played on a two-dimensional grid of cells, where each cell is either 1 (alive) or 0 (dead). 
At each time step, each cell changes state depending on how many neighbours it has:

0-1 neighbour: Cell becomes 0.
2 neighbours: Cell state does not change.
3 neighbours: Cell becomes 1.
4+ neighbours: Cell becomes 0.
The game is formulated for an infinite grid. In this circuit, we will use a 16x16 grid. 
To make things more interesting, we will use a 16x16 toroid, where the sides wrap around to the other side of the grid. 
For example, the corner cell (0,0) has 8 neighbours: (15,1), (15,0), (15,15), (0,1), (0,15), (1,1), (1,0), and (1,15). 
The 16x16 grid is represented by a length 256 vector, where each row of 16 cells is represented by a sub-vector: q[15:0] is row 0, q[31:16] is row 1, etc. 
(This tool accepts SystemVerilog, so you may use 2D vectors if you wish.)

load: Loads data into q at the next clock edge, for loading initial state.
q: The 16x16 current state of the game, updated every clock cycle.
The game state should advance by one timestep every clock cycle.
*/



module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 

    // variable to generate 255 instantiations of modules of dff_game
    wire [15:0][15:0] q_2D;
    wire [15:0][15:0] data_2D;

    genvar i;
    genvar j;

    generate
        for (int i = 0; i < 16; i = i + 1) begin : loop1
            for (int j = 0; j < 16; j = j + 1) begin : loop2
                assign q_2D[i][j] = q[16 * i + j];
                assign data_2D[i][j] = data[16 * i + j];
            end
        end
    endgenerate


    generate
        for (int i = 0; i < 16; i = i + 1) begin : loop1
            for (int j = 0; j < 16; j = j + 1) begin : loop2
                 dff_game dff_game_i (
                        .clk(clk),
                        .load(load),
                        .data(),
                        .l(l[i]),
                        .r(r[i]),
                        .u(u[i]),
                        .d(d[i]),
                        .lu(lu[i]),
                        .ru(ru[i]),
                        .ld(ld[i]),
                        .rd(rd[i]),
                        .q(q[i])
                    );
            end
        end
    endgenerate
    


endmodule





module dff_game(
    input clk,
    input load,
    input data,
    input l,
    input r,
    input u,
    input d,
    input lu,
    input ru,
    input ld,
    input rd,
    output reg q
);

    wire[3:0] count = l + r + u + d + lu + ld + ru + rd;

    

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
        else if (count == 4'b000 || count == 4'b001 || count > 4'b011) begin
            q <= 1'b0;
        end
        else if (count == 4'b011) begin
            q <= 1'b1;
        end
        else begin
            q <= q;
        end
    end

endmodule

