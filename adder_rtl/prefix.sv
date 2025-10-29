`timescale 1ns/1ps
//======================
// Module Name: N-bit Prefix Adder
// File: prefix.sv
// Engineer: Daniel Grib
// Create Date: 10/27/25
//
// Description: This is my implementation for the prefix adder.
//              It is based off of the behavioral design that we had in class.
//              It creates a block of propagates and generates before sending them
//              through a set of stages like we learned in class.
//======================
module prefix #(
  parameter int N = 32
)(
  input  logic [N-1:0] A, B,
  input  logic         Cin,
  output logic [N-1:0] Sum,
  output logic         Cout
);

  // --------------------------------------
  // Stage 0: bitwise propagate and generate
  // --------------------------------------
  logic [N-1:0] P0, G0;
  assign P0 = A ^ B;   // propagate
  assign G0 = A & B;   // generate

  // --------------------------------------
  // Prefix computation
  // --------------------------------------
  localparam int STAGES = $clog2(N);

  logic [STAGES:0][N-1:0] P;
  logic [STAGES:0][N-1:0] G;

  assign P[0] = P0;
  assign G[0] = G0;

  genvar s, i;
  generate
    for (s = 0; s < STAGES; s++) begin : stage
      localparam int D = (1 << s);
      for (i = 0; i < N; i++) begin : col
        if (i >= D) begin
          assign G[s+1][i] = G[s][i] | (P[s][i] & G[s][i-D]);
          assign P[s+1][i] = P[s][i] & P[s][i-D];
        end else begin
          assign G[s+1][i] = G[s][i];
          assign P[s+1][i] = P[s][i];
        end
      end
    end
  endgenerate

  // --------------------------------------
  // Carry propagation and sum computation
  // --------------------------------------
  logic [N:0] C;
  assign C[0] = Cin;

  generate
    for (i = 0; i < N; i++) begin : carry
      assign C[i+1] = G[STAGES][i] | (P[STAGES][i] & Cin);
      assign Sum[i] = P0[i] ^ C[i];
    end
  endgenerate

  assign Cout = C[N];

endmodule
