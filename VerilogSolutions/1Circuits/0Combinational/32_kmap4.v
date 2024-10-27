/*

Implement the circuit described by the Karnaugh map below.

https://hdlbits.01xz.net/wiki/File:Kmap4.png

Try to simplify the k-map before coding it. Try both product-of-sums and sum-of-products forms. 
We can't check whether you have the optimal simplification of the k-map. 
But we can check if your reduction is equivalent, and we can check whether you can translate a k-map into a circuit

*/



module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 

    assign out = (
        // it is wrong that a == c and b == d : in that case it is 0
        !(!(a ^ c) && !(b ^ d)) &&

        // it is wrong that a != c and b == d : in that case it is 0
        !((a ^ c) && (b ^ d))
    );

endmodule

