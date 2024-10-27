/*
This combinational circuit is supposed to recognize 8-bit keyboard scancodes for keys 0 through 9. 
It should indicate whether one of the 10 cases were recognized (valid), and if so, which key was detected. 
Fix the bug(s).


module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid=1 );//

     always @(*)
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'd26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            6'h46: out = 9;
            default: valid = 0;
        endcase

endmodule
*/



module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid);

     always @(*) begin
        case (code)
            8'h45: out = 4'd0;
            8'h16: out = 4'd1;
            8'h1e: out = 4'd2;
            8'h26: out = 4'd3;
            8'h25: out = 4'd4;
            8'h2e: out = 4'd5;
            8'h36: out = 4'd6;
            8'h3d: out = 4'd7;
            8'h3e: out = 4'd8;
            8'h46: out = 4'd9;
            default: out = out;
        endcase
     end
    
    assign valid = 
    (code == 8'h45) || (code == 8'h16) || (code == 8'h1e) ||
    (code == 8'd26) || (code == 8'h25) || (code == 8'h2e) ||
    (code == 8'h36) || (code == 8'h3d) || (code == 8'h3e) ||
    (code == 8'h46);
    
    
endmodule