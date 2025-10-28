`timescale 1ns/1ps
// N-bit Kogge-Stone prefix adder (structural/arrayed logic)
module prefix_adder #(
  parameter int N = 32
)(
  input  logic [N-1:0] A, B,
  input  logic         Cin,
  output logic [N-1:0] Sum,
  output logic         Cout
);
  // bitwise propagate/generate
  logic [N-1:0] P0, G0;
  assign P0 = A ^ B;
  assign G0 = A & B;

  // prefix tree stages
  localparam int STAGES = $clog2(N);
  logic [STAGES:0][N-1:0] P, G; // [stage][bit]
  assign P[0] = P0;
  assign G[0] = G0;

  genvar s, i;
  generate
    for (s = 0; s < STAGES; s++) begin : stage
      localparam int D = (1<<s);
      for (i = 0; i < N; i++) begin : col
        if (i >= D) begin
          // Black cell: (G,P) • (Gshift,Pshift) = (G | (P&Gshift), P & Pshift)
          assign G[s+1][i] = G[s][i] | (P[s][i] & G[s][i-D]);
          assign P[s+1][i] = P[s][i] & P[s][i-D];
        end else begin
          assign G[s+1][i] = G[s][i];
          assign P[s+1][i] = P[s][i];
        end
      end
    end
  endgenerate

  // carry out of each bit: C[i+1] = G* [i] | (P* [i] & Cin)
  logic [N:0] C;
  assign C[0] = Cin;
  for (genvar j = 0; j < N; j++) begin : gen_carry
    assign C[j+1] = G[STAGES][j] | (P[STAGES][j] & Cin);
  end

  // sum and cout
  assign Sum  = P0 ^ C[N-1:0];
  assign Cout = C[N];
endmodule
