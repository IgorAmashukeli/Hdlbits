/*

For each bit in a 32-bit vector, capture when the input signal changes from 1 in one clock cycle to 0 the next. 
"Capture" means that the output will remain 1 until the register is reset (synchronous reset).

Each output bit behaves like a SR flip-flop: The output bit should be set (to 1) the cycle after a 1 to 0 transition occurs. 
The output bit should be reset (to 0) at the positive clock edge when reset is high. If both of the above events occur at the same time, reset has precedence. 
In the last 4 cycles of the example waveform below, the 'reset' event occurs one cycle earlier than the 'set' event, so there is no conflict here.

In the example waveform below, reset, in[1] and out[1] are shown again separately for clarity.
*/

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    detect detectors [31:0] (
        .clk({32{clk}}),

        .in(in),

        .reset({32{reset}}),

        .out(out),
    );

endmodule


module detect (
    input clk,
    input reset,
    input in,
    output reg out
);

    reg old_in;

    always @(posedge clk) begin
        // reset has presedence
        if (reset) begin
            out <= 1'b0;
        end
        else begin
            out <= (

                // triggering negative edge
                (old_in && !in) || 

                // saving the previous value, if it was equal to 1
                // (if it is 1 => it remains the same value)
                // (if it is 0 and there is no reset the value equal to (old_in && !in) -> whether there was a negative edge)
            out);
        end

        // save the old value of in
        old_in <= in;
    end


endmodule
