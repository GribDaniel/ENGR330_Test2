`timescale 1ns / 1ps
//======================
// Module Name: N-bit Ripple-Carry Adder (RCA)
// File: rca.v
// Engineer: Daniel Grib
// Create Date: 10/23/25
//
// Description: This is my implementation for the ripple-carry adder.
//              It is based on the traditional interpretation of this
//              type of adder. It combines Full Adders in a chain
//              using a structural behavior.
//======================
module rca (
    parameter N,
    input  logic [N-1:0] A, B,
    input  logic       Cin,
    output logic [N-1:0] Sum,
    output logic       Cout);

    // Wires between Full Adders
    logic [N:0] carry;
    assign carry[0] = Cin;

    // Instantiate Full Adder Loop using genvar
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : adderStage
            fullAdder fA (
                .a(A[i]), .b(B[i]),
                .cin(carry[i]), .sum(Sum[i]),
                .cout(carry(i+1))
            );
        end
    endgenerate

    assign Cout = carry[N];

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

    // Logic Equations
    // assign sum  = a ^ b ^ cin;
    // assign cout = (a & b) | (b & cin) | (a & cin);
endmodule