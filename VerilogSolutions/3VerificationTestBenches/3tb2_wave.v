/*
The waveform below sets clk, in, and s:

Module q7 has the following declaration:

module q7 (
    input clk,
    input in,
    input [2:0] s,
    output out
);
Write a testbench that instantiates module q7 and 
generates these input signals exactly as shown in the waveform above.
*/


module top_module();

    reg clk;
    reg in;
    reg[2:0] s;

    q7 q7_module (
        .clk(clk),
        .in(in),
        .s(s),
        .out(out)
    );

    initial begin
        clk = 0;
        in = 0;
        s = 3'd2;

        #10 s = 3'd6;
        #10 s = 3'd2;
        in = 1;

        #10 s = 3'd7;
        in = 0;

        #10 s = 3'd0;
        in = 1;

        #30 in = 0;

    end



    always begin
        #5 clk = !clk;
    end

endmodule