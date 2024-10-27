/*
Consider the function f shown in the Karnaugh map below.

https://hdlbits.01xz.net/wiki/File:Exams_m2014q3.png

Implement this function. d is don't-care, which means you may choose to output whatever value is convenient.
*/


module top_module (
    input [4:1] x, 
    output f );


    assign f = !(
        (!x[0] && x[1] && !x[2] && !x[3]) ||
        (!x[0] && !x[1] && !x[2] && x[3]) ||
        (x[0] && !x[1] && !x[2] && x[3]) ||
        (x[0] && x[1] && x[2] && !x[3])
        
    );

endmodule