/*
Given the following state machine with 1 input and 2 outputs:

https://hdlbits.01xz.net/wiki/File:Fsmonehot.png

Suppose this state machine uses one-hot encoding, where state[0] through state[9] correspond to the states S0 though S9, respectively. 
The outputs are zero unless otherwise specified.

Implement the state transition logic and output logic portions of the state machine (but not the state flip-flops). 
You are given the current state in state[9:0] and must produce next_state[9:0] and the two outputs. 
Derive the logic equations by inspection assuming a one-hot encoding. 
(The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).
*/


module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

    assign next_state[S0] = (state[S0] && !in) || (state[S1] && !in) || (state[S2] && !in) 
    || (state[S3] && !in) || (state[S4] && !in) || (state[S7] && !in) || (state[S8] && !in) || (state[S9] && !in);
    assign next_state[S1] = (state[S0] && in) || (state[S8] && in) || (state[S9] && in);
    assign next_state[S2] = state[S1] && in;
    assign next_state[S3] = state[S2] && in;
    assign next_state[S4] = state[S3] && in;
    assign next_state[S5] = state[S4] && in;
    assign next_state[S6] = state[S5] && in;
    assign next_state[S7] = state[S6] && in || (state[S7] && in);
    assign next_state[S8] = state[S5] && !in;
    assign next_state[S9] = state[S6] && !in;

    
    assign out1 = (state == S8) || (state == S9);
    assign out2 = (state == S7) || (state == S9);

endmodule