


module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );

    
    wire aANDb;
    wire cANDd;
    wire aANDbANDc;
    wire dANDeANDf;

    assign p1y = aANDbANDc || dANDeANDf;
    assign p2y = aANDb || cANDd;

    assign aANDb = p2a && p2b;
    assign cANDd = p2c && p2d;
    
    assign aANDbANDc = (p1a && p1c) && p1b;
    assign dANDeANDf = (p1d && p1e) && p1f;




endmodule