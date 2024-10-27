/*
From a 1000 Hz clock, derive a 1 Hz signal, called OneHertz, 
that could be used to drive an Enable signal for a set of hour/minute/second counters to create a digital wall clock. 
Since we want the clock to count once per second, the OneHertz signal must be asserted for exactly one cycle each second. 
Build the frequency divider using modulo-10 (BCD) counters and as few other gates as possible. 
Also output the enable signals from each of the BCD counters you use (c_enable[0] for the fastest counter, 
c_enable[2] for the slowest).

The following BCD counter is provided for you. 
Enable must be high for the counter to run. 
Reset is synchronous and set high to force the counter to zero. 
All counters in your circuit must directly use the same 1000 Hz signal.

module bcdcount (
	input clk,
	input reset,
	input enable,
	output reg [3:0] Q
);


the first tick should be at 999, not at 0
*/



module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);

    reg[11:0] counter_outputs;

    // the fastest counter counts everytime
    assign c_enable[0] = 1'b1;

    assign c_enable[1] = (counter_outputs[3:0] == 4'b1001);
    // the middle counter adds 1 when the fast counter hits 9
    // 0 middle; 0 ... 9 fast -> 0-9
    // 1 middle; 0 ... 9 fast -> 10-19
    // 2 middle; 0 ... 9 fast -> 20-29
    // 3 middle; 0 ... 9 fast -> 30-39
    // 4 middle; 0 ... 9 fast -> 40-49
    // 5 middle; 0 ... 9 fast -> 50-59
    // 6 middle; 0 ... 9 fast -> 60-69
    // 7 middle; 0 ... 9 fast -> 70-79
    // 8 middle; 0 ... 9 fast -> 80-89
    // 9 middle; 0 ... 9 fast -> 90-99
    
    
    assign c_enable[2] = (counter_outputs[7:0] == 8'b10011001);
    // the slowest counter adds 1 when the middle and lower counter hit 99
    // 0 slow; 0 ... 9 middle -> 0-99
    // 1 slow; 0 ... 9 middle -> 100-199
    // 2 slow; 0 ... 9 middle -> 200-299
    // 3 slow; 0 ... 9 middle -> 300-399
    // 4 slow; 0 ... 9 middle -> 400-499
    // 5 slow; 0 ... 9 middle -> 500-599
    // 6 slow; 0 ... 9 middle -> 600-699
    // 7 slow; 0 ... 9 middle -> 700-799
    // 8 slow; 0 ... 9 middle -> 800-899
    // 9 slow; 0 ... 9 middle -> 900-999

    

    bcdcount counter0 (clk, reset, c_enable[0], counter_outputs[3:0]);
    bcdcount counter1 (clk, reset, c_enable[1], counter_outputs[7:4]);
    bcdcount counter2 (clk, reset, c_enable[2], counter_outputs[11:8]);

    // OneHertz == 1 <=> all counters give 999.
    assign OneHertz = (counter_outputs == 12'b100110011001);

endmodule