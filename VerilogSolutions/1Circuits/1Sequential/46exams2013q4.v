/*
https://hdlbits.01xz.net/wiki/File:Ece241_2013_q4.png
*/

module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 

    reg[1:0] state, next_state;
    wire comp;

    always @(*) begin
        if (s[1] && s[2] && s[3]) begin
            next_state <= 2'b11;
        end
        else if (s[1] && s[2]) begin
            next_state <= 2'b10;
        end
        else if (s[1]) begin
            next_state <= 2'b01;
        end
        else begin
            next_state <= 2'b00;
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            comp <= 1'b1;
        end
        else begin
            state <= next_state;
            if (state < next_state) begin
                comp <= 1'b1;
            end
            else if (state > next_state) begin
                comp <= 1'b0;
            end
        end
    end


    always @(*) begin
        if (state == 2'b11) begin
            fr1 = 0;
            fr2 = 0;
            fr3 = 0;
            dfr = 0;
        end
        else if (state = 2'b00) begin
            fr1 = 1;
            fr2 = 1;
            fr3 = 1;
            dfr = 1;
        end
        else if (state = 2'b10) begin
            fr1 = 1;
            fr2 = 0;
            fr3 = 0;
            dfr = !comp;
        end
        else begin
            fr1 = 1;
            fr2 = 1;
            fr3 = 0;
            dfr = !comp;
        end
    end


endmodule