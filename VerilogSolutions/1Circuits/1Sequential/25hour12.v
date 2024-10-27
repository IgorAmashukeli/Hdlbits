/*
Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator). 
Your counters are clocked by a fast-running clk, with a pulse on ena whenever your clock should increment (i.e., once per second).

reset resets the clock to 12:00 AM. 
pm is 0 for AM and 1 for PM. 
hh, mm, and ss are two BCD (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). 
Reset has higher priority than enable, and can occur even when not enabled.

The following timing diagram shows the rollover behaviour from 11:59:59 AM to 12:00:00 PM 
and the synchronous reset and enable behaviour.

Note that 11:59:59 PM advances to 12:00:00 AM, and 12:59:59 PM advances to 01:00:00 PM. There is no 00:00:00.
*/




module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    wire[3:1] enas;

    ms2bcd seconds(
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .q(ss)
    );

    assign enas[1] = (ss == 8'h59) && ena;

    ms2bcd minutes(
        .clk(clk),
        .reset(reset),
        .ena(enas[1]),
        .q(mm)
    );

    assign enas[2] = ((ss == 8'h59) && (mm == 8'h59)) && ena;

    hour2bcd hours(
        .clk(clk),
        .reset(reset),
        .ena(enas[2]),
        .q(hh)
    );


    assign enas[3] = ((ss == 8'h59) && (mm == 8'h59) && (hh == 8'h11)) && ena;


    pmamc pmam(
        .clk(clk),
        .reset(reset),
        .ena(enas[3]),
        .q(pm)
    );


endmodule



module pmamc(
    input clk,
    input reset,
    input ena,
    output q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end
        else if (ena) begin
            q <= !q;
        end
    end

endmodule



module ms2bcd (
    input clk,
    input reset,
    input ena,
    output[7:0] q
);

    wire[7:0] q_new;

    fullincr8 finc (
        .a(q),
        .out(q_new)
    );   

    always @(posedge clk) begin
        if (reset || ((q == 8'h59) && (ena))) begin
            q <= 8'h00;
        end
        else if (ena) begin
            q <= q_new;
        end
    end



endmodule




module hour2bcd (
    input clk,
    input reset,
    input ena,
    output[7:0] q
);

    wire[7:0] q_new;

    fullincr8 finc (
        .a(q),
        .out(q_new)
    );    

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'h12;
        end
        else if (ena && q == 8'h12) begin
            q <= 8'h01;
        end
        else if (ena) begin
            q <= q_new;
        end
    end

endmodule



module fullincr8(
    input[7:0] a,
    output[7:0] out
);

    wire carry;

    full_adder4 faddlow(
        .a(a[3:0]),
        .b(4'b0001),
        .carry_in(1'b0),
        .dec_carry(carry),
        .out(out[3:0])
    );


    full_adder4 faddupp(
        .a(a[7:4]),
        .b(4'b0000),
        .carry_in(carry),
        .out(out[7:4])
    );


endmodule



module full_adder4(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output dec_carry,
    output [3:0] out
);

    wire [3:0] sum;
    wire [3:0] carry_out;


    assign dec_carry = (a == 4'b1001);
    
    full_adder fadds [3:0] (
        .a(a),
        .b(b),
        .carry_in({carry_out[2:0], carry_in}),
        .carry_out(carry_out),
        .sum(sum)
    );

    assign out = sum & {4{!dec_carry}};

    
    

endmodule


module full_adder(
    input a,
    input b,
    input carry_in,
    output carry_out,
    output sum
);

    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a && b || a && carry_in || b && carry_in);

endmodule