/*
Given the following state machine with 3 inputs, 3 outputs, and 10 states:
https://hdlbits.01xz.net/wiki/File:Exams_review2015_fsmonehot.png

Derive next-state logic equations and output logic equations by inspection assuming the following one-hot encoding is used: 
(S, S1, S11, S110, B0, B1, B2, B3, Count, Wait) = (10'b0000000001, 10'b0000000010, 10'b0000000100, ... , 10'b1000000000)

Derive state transition and output logic equations by inspection assuming a one-hot encoding. Implement only the state transition logic and output logic (the combinational logic portion) for this state machine. (The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated. See fsm3onehot for a description of what is meant by deriving logic equations "by inspection" for one-hot state machines.)

Write code that generates the following equations:

B3_next -- next-state logic for state B3
S_next
S1_next
Count_next
Wait_next
done -- output logic
counting
shift_ena
*/


module top_module(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,    // 10-bit one-hot current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
); //

    // You may use these parameters to access state bits using e.g., state[B2] instead of state[6].
    parameter S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9;
    wire[9:0] next_state;

    assign next_state[S] = (state[S] && !d) || (state[S1] && !d) || (state[S110] && !d) || (state[Wait] && ack);
    assign next_state[S1] = (state[S] && d);
    assign next_state[S11] = (state[S1] && d) || (state[S11] && d);
    assign next_state[S110] = (state[S11] && !d);
    assign next_state[B0] = (state[S110] && d);
    assign next_state[B1] = state[B0];
    assign next_state[B2] = state[B1];
    assign next_state[B3] = state[B2];
    assign next_state[Count] = state[B3] || (state[Count] && !done_counting);
    assign next_state[Wait] = (state[Count] && done_counting) || (state[Wait] && !ack);

    assign B3_next = next_state[B3];
    assign S_next = next_state[S];
    assign S1_next = next_state[S1];
    assign Count_next = next_state[Count];
    assign Wait_next = next_state[Wait];

    assign done = state[Wait];
    assign counting = state[Count];
    assign shift_ena = state[B0] || state[B1] || state[B2] || state[B3];

endmodule