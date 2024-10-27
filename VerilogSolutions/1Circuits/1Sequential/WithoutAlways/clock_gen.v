`timescale 1ns/1ps  // Set the time unit to 1ns and time precision to 1ps

module clock_gen;
    reg clk;  // Declare the clock signal

    // Generate clock signal
    initial begin
        clk = 0;           // Initialize the clock to 0
        forever #5 clk = ~clk; // Toggle clock every 5 time units (5ns high, 5ns low)
    end

    // Dump waveform data to VCD file
    initial begin
        $dumpfile("waveform.vcd");  // Create the VCD file
        $dumpvars(0, clock_gen);     // Dump all variables in this module
        #100 $finish;                // End simulation after 100 ns
    end
endmodule

