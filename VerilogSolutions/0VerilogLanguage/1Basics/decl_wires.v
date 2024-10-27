/*
Declaring wires
The circuits so far have been simple enough that the outputs are simple functions of the inputs.
As circuits become more complex, you will need wires to connect internal components together. 
When you need to use a wire, you should declare it in the body of the module, somewhere before it is first used. 
(In the future, you will encounter more types of signals and variables that are also declared the same way, but for now, we'll start with a signal of type wire).

Create two intermediate wires (named anything you want) to connect the AND and OR gates together. 
Note that the wire that feeds the NOT gate is really wire out, so you do not necessarily need to declare a third wire here. 
Notice how wires are driven by exactly one source (output of a gate), but can feed multiple inputs.
*/


`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   );

    wire aANDb;
    wire cANDd;

    assign out_n = !out;
    assign out = aANDb || cANDd;
    assign aANDb = a && b;
    assign cANDd = c && d;
    

endmodule