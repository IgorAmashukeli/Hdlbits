/*
A single-output digital system with four inputs (a,b,c,d) generates a logic-1 when 2, 7, or 15 appears on the inputs, 
and a logic-0 when 0, 1, 4, 5, 6, 9, 10, 13, or 14 appears. The input conditions for the numbers 3, 8, 11, and 12 never occur in this system. 
For example, 7 corresponds to a,b,c,d being set to 0,1,1,1, respectively.

Determine the output out_sop in minimum SOP form, and the output out_pos in minimum POS form.

It means, because 3, 8, 11, and 12 are not determined, there exist different logical function

You need to find the one, that has the minimum SOP form
and SOP.

It means, the one that technically fits the criteria for 2, 7, 15, 0, 1, 4, 6, 9, 10, 13, 14 can be wrong.
Actually it will be tested on 3, 8, 11, 12


*/


module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
); 


    assign out_sop = (!a && !b && c) || (c & d);
    assign out_pos = (!a || d) && (!b || d) && c;


endmodule