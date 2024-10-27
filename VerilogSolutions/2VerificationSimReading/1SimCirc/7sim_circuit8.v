/*
This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.
https://hdlbits.01xz.net/wiki/Sim/circuit8
*/


module top_module (
    input clock,
    input a,
    output p,
    output q );

    // it is important to mention:
    // all the triggered values inside if are considered as the ones after triggering
    // all the values inside multiplexer are calculated the same as the values inside input in data flip flop
    // they are calculated just before the triggering

    // it is rather interesting, how we can implement this asyncronous set/reset data flip flop with clock as triggering signal,
    // which is inside if condition, using combinatorial loops
    // the solution and its explanation is given in WithoutAlways directory
    always @(posedge clock, posedge a) begin
        if (clock) begin
            p <= a;
        end
    end 

    always @(negedge clock) begin
        q <= a;
    end

endmodule










