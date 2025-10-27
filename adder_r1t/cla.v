`timescale 1ns / 1ps
//======================
// Module Name: N-bit Carry-Lookahead Adder (CLA)
// File: cla.v
// Engineer: Daniel Grib
// Create Date: 10/24/25
//
// Description: This is my implementation for the carry-lookahead adder.
//======================
module cla4 (
    input  logic [3:0] a, b,
    input  logic       cin,
    output logic [3:0] sum,
    output logic       cout,
    output logic       pBlock,
    output logic       gBlock);

    // Generate: g = a * b
    wire g0, g1, g2, g3;
    and (g0, a[0], b[0]);
    and (g1, a[1], b[1]);
    and (g2, a[2], b[2]);
    and (g3, a[3], b[3]);

    // Propagate: p = a + b
    wire p0, p1, p2, p3;
    or (p0, a[0], b[0]);
    or (p1, a[1], b[1]);
    or (p2, a[2], b[2]);
    or (p3, a[3], b[3]);

    // Carry wires
    wire c1, c2, c3;

    // c1 = g0 + p0*cin
    wire p0cin;
    and  propEq1 (p0cin, p0, cin);
    or   carry1  (c1, g0, p0cin);

    // c2 = g1 + p1*g0 + p1*p0*cin
    wire p1g0, p1p0cin;
    and  propEq2a (p1g0, p1, g0);
    and  propEq2b (p1p0cin, p1, p0cin);
    or   carry2   (c2, g1, p1g0, p1p0cin);


    // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
    wire p2g1, p2p1g0, p2p1p0cin;
    and  propEq3a (p2g1, p2, g1);
    and  propEq3b (p2p1g0, p2, p1g0);
    and  propEq3c (p2p1p0cin, p2, p1p0cin);
    or   carry3   (c3, g2, p2g1, p2p1g0, p2p1p0cin);

    // cout = g3 + p3·c3
    wire p3c3;
    and  propEq4 (p3c3, p3, c3);
    or   carryout(cout, g3, p3c3);

    //x = a XOR b
    wire x0, x1, x2, x3;
    xor sumb4carry0 (x0, a[0], b[0]);
    xor sumb4carry1 (x1, a[1], b[1]);
    xor sumb4carry2 (x2, a[2], b[2]);
    xor sumb4carry3 (x3, a[3], b[3]);

    //sum = x XOR carry
    xor sum0 (sum[0], x0, cin);
    xor sum1 (sum[1], x1, c1);
    xor sum2 (sum[2], x2, c2);
    xor sum3 (sum[3], x3, c3);

    // Block Propagate & Generate (for multiblock CLA)
    and pBlock_and (pBlock, p0, p1, p2, p3);

    wire p3g2, p3p2g1, p3p2p1g0;
    and(p3g2,     p3, g2);
    and(p3p2g1,   p3, p2, g1);
    and(p3p2p1g0, p3, p2, p1, g0);
    or gBlock_or (gBlock, g3, p3g2, p3p2g1, p3p2p1g0);

endmodule

module fullAdder (
    input  logic a, b, cin,
    output logic sum, cout);

    wire w1, w2, w3;

    xor g1 (w1, a, b);
    and g2 (w2, a, b);

    xor g3 (sum, w1, cin);
    and g4 (w3, w1, cin);

    or g5 (cout, w3, w2);
    
endmodule