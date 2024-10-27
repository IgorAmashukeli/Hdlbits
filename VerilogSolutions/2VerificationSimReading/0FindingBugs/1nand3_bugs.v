/*
This three-input NAND gate doesn't work. Fix the bug(s).


module top_module (input a, input b, input c, output out);//

    andgate inst1 ( a, b, c, out );

endmodule

You must use the provided 5-input AND gate:

module andgate ( output out, input a, input b, input c, input d, input e );
*/


module top_module (input a, input b, input c, output out);//

    wire nout;
    andgate inst1 ( .out(nout), .a(a), .b(b), .c(c), .d(1'd1), .e(1'd1)); 

    assign out = !nout;

endmodule