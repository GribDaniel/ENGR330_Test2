`timescale 1ns / 1ps
//====================== 
// Module Name: N-bit Carry-Lookahead Adder (CLA) 
// File: cla.v 
// Engineer: Daniel Grib 
// Create Date: 10/24/25
//
// Description: This is my implementation for the carry-lookahead adder. 
//              It is based off of the structural design that we had in class. 
//              There is a creation of 4-bit CLAs that are strung together using full adders. 
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

//=======================================================
// Top-level parameterized CLA using 4-bit CLA blocks
//=======================================================
module cla #(
    parameter integer WIDTH = 32
)(
    input  logic [WIDTH-1:0] A, B,
    input  logic             Cin,
    output logic [WIDTH-1:0] Sum,
    output logic             Cout
);

    localparam int N_BLOCKS = WIDTH / 4;
    logic [N_BLOCKS:0] C;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < N_BLOCKS; i++) begin : CLA_BLOCKS
            logic [3:0] a4, b4, s4;
            logic pBlock, gBlock;
            assign a4 = A[i*4 +: 4];
            assign b4 = B[i*4 +: 4];

            cla4 cla_inst (
                .a(a4),
                .b(b4),
                .cin(C[i]),
                .sum(s4),
                .cout(),
                .pBlock(pBlock),
                .gBlock(gBlock)
            );

            assign Sum[i*4 +: 4] = s4;
            assign C[i+1] = gBlock | (pBlock & C[i]);
        end
    endgenerate

    assign Cout = C[N_BLOCKS];
endmodule