/*
The state diagram for this question is shown again below.
https://hdlbits.01xz.net/wiki/File:Exams_2012q2.png

Assume that a one-hot code is used with the state assignment 
y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F)

Write a logic expression for the signal Y1, which is the input of state flip-flop y[1].

Write a logic expression for the signal Y3, which is the input of state flip-flop y[3].

(Derive the logic equations by inspection assuming a one-hot encoding. 
The testbench will test with non-one hot inputs
to make sure you're not trying to do something more complicated).
*/


module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    wire[5:0] Y;

    assign Y[0] = (y[0] && !w) || (y[3] && !w);
    assign Y[1] = (y[0] && w);
    assign Y[2] = (y[1] && w) || (y[5] && w);
    assign Y[3] = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);
    assign Y[4] = (y[2] && w) || (y[4] && w);
    assign Y[5] = (y[3] && w);


    assign Y1 = Y[1];
    assign Y3 = Y[3];


endmodule