/*

Consider the function f shown in the Karnaugh map below. Implement this function.

(The original exam question asked for simplified SOP and POS forms of the function.)

*/


module top_module (
    input [4:1] x,
    output f
);

    assign f = 
    (!x[1] && !x[2] && !x[3] && !x[4]) ||
    (x[1] && !x[2] && !x[3] && !x[4]) ||
    (!x[1] && !x[2] && x[3] && x[4]) ||
    (!x[1] && x[2] && x[3] && x[4]) ||
    (x[1] && x[2] && x[3] && x[4]) ||
    (!x[1] && !x[2] && x[3] && !x[4]) ||
    (!x[1] && x[2] && x[3] && !x[4]) ||
    (x[1] && !x[2] && x[3] && !x[4]);

endmodule