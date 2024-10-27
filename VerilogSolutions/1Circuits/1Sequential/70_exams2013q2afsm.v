/*
Consider the FSM described by the state diagram shown below:
https://hdlbits.01xz.net/wiki/File:Exams_2013q2.png


This FSM acts as an arbiter circuit, 
which controls access to some type of resource by three requesting devices. 
Each device makes its request for the resource by setting a signal r[i] = 1, 
where r[i] is either r[1], r[2], or r[3]. Each r[i] is an input signal to the FSM, 
and represents one of the three devices. 
The FSM stays in state A as long as there are no requests. 
When one or more request occurs, then the FSM decides 
which device receives a grant to use the resource 
and changes to a state that sets that device’s g[i] signal to 1. 
Each g[i] is an output from the FSM. 
There is a priority system, in that device 1 has a higher priority than device 2, 
and device 3 has the lowest priority. 
Hence, for example, device 3 will only receive a grant if it is 
the only device making a request when the FSM is in state A. 
Once a device, i, is given a grant by the FSM, that device continues 
to receive the grant as long as its request, r[i] = 1.

Write complete Verilog code that represents this FSM. 
Use separate always blocks for the state table and the state flip-flops, as done in lectures. 
Describe the FSM outputs, g[i], using either continuous assignment statement(s) or an always block (at your discretion). 
Assign any state codes that you wish to use.
*/


module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output [3:1] g
);

    parameter A = 0, B = 1, C = 2, D = 3;
    reg[1:0] state, next_state;

    always @(*) begin
        if (state == A && !r[1] && !r[2] && !r[3]) begin
            next_state = state;
        end
        else if (state == A && r[1]) begin
            next_state = B;
        end
        else if (state == A && r[2]) begin
            next_state = C;
        end
        else if (state == A && r[3]) begin
            next_state = D;
        end
        else if (state == B && r[1]) begin
            next_state = state;
        end
        else if (state == B && !r[1]) begin
            next_state = A;
        end
        else if (state == C && r[2]) begin
            next_state = state;
        end
        else if (state == C && !r[2]) begin
            next_state = A;
        end
        else if (state == D && r[3]) begin
            next_state = state;
        end
        else if (state == D && !r[3]) begin
            next_state = A;
        end
        else begin
            next_state = state;
        end
    end


    always @(posedge clk) begin
        state <= (!resetn) ? A : next_state;
    end

    assign g[1] = (state == B);
    assign g[2] = (state == C);
    assign g[3] = (state == D);

endmodule