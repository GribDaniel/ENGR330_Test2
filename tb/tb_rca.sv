`timescale 1ns/1ps
//======================================================
// Testbench: Multi-width Ripple-Carry Adder Verification
// Engineer: Daniel Grib
//======================================================

module tb_rca;

  localparam int NUM_TESTS = 8;

  // Shared 64-bit test vectors
  logic [63:0] testA [0:NUM_TESTS-1];
  logic [63:0] testB [0:NUM_TESTS-1];
  logic        testCin [0:NUM_TESTS-1];

  // DUT outputs
  logic [7:0]   sum8;   logic cout8;
  logic [15:0]  sum16;  logic cout16;
  logic [31:0]  sum32;  logic cout32;
  logic [63:0]  sum64;  logic cout64;

  // Expected values
  logic [8:0]   exp8;
  logic [16:0]  exp16;
  logic [32:0]  exp32;
  logic [64:0]  exp64;

  // Temporary slices (updated each loop)
  logic [7:0]   A8,  B8;
  logic [15:0]  A16, B16;
  logic [31:0]  A32, B32;
  logic [63:0]  A64, B64;
  logic         Cin_local;

  // Instantiate one RCA per width (constant-sized connections)
  rca #(8)   dut8  (.A(A8),  .B(B8),  .Cin(Cin_local), .Sum(sum8),  .Cout(cout8));
  rca #(16)  dut16 (.A(A16), .B(B16), .Cin(Cin_local), .Sum(sum16), .Cout(cout16));
  rca #(32)  dut32 (.A(A32), .B(B32), .Cin(Cin_local), .Sum(sum32), .Cout(cout32));
  rca #(64)  dut64 (.A(A64), .B(B64), .Cin(Cin_local), .Sum(sum64), .Cout(cout64));

  integer i;

  // Initialize deterministic test cases
  initial begin
    testA[0] = 64'h0000000000000065; testB[0] = 64'h0000000000000065; testCin[0] = 0;
    testA[1] = 64'hFFFFFFFFFFFFFFFF; testB[1] = 64'h0000000000000000; testCin[1] = 0;
    testA[2] = 64'h00000000000000FF; testB[2] = 64'h0000000000000001; testCin[2] = 0;
    testA[3] = 64'h00000000000000AA; testB[3] = 64'h0000000000000055; testCin[3] = 0;
    testA[4] = 64'h000000000000007F; testB[4] = 64'h0000000000000001; testCin[4] = 1;
    testA[5] = 64'h000000000000A5A5; testB[5] = 64'h0000000000005A5A; testCin[5] = 0;
    testA[6] = 64'h0000000000000010; testB[6] = 64'h0000000000000020; testCin[6] = 0;
    testA[7] = 64'h00000000000000FE; testB[7] = 64'h0000000000000001; testCin[7] = 1;
  end

  // Main stimulus
  initial begin
    $dumpfile("results/waves_rca.vcd");
    $dumpvars(0, tb_rca);

    $display("==============================================");
    $display("Running RCA tests for all widths");
    $display("==============================================");

    for (i = 0; i < NUM_TESTS; i++) begin
      // Update local slices (constants for this iteration)
      A8  = testA[i][7:0];    B8  = testB[i][7:0];
      A16 = testA[i][15:0];   B16 = testB[i][15:0];
      A32 = testA[i][31:0];   B32 = testB[i][31:0];
      A64 = testA[i][63:0];   B64 = testB[i][63:0];
      Cin_local = testCin[i];

      #10;

      exp8  = A8  + B8  + Cin_local;
      exp16 = A16 + B16 + Cin_local;
      exp32 = A32 + B32 + Cin_local;
      exp64 = A64 + B64 + Cin_local;

      $display("\n--- Test %0d ---", i);
      $display("Inputs: A=%h, B=%h, Cin=%b", testA[i], testB[i], testCin[i]);

      check8({cout8,  sum8},  exp8);
      check16({cout16, sum16}, exp16);
      check32({cout32, sum32}, exp32);
      check64({cout64, sum64}, exp64);
    end

    $display("\nAll RCA width tests complete.");
    $finish;
  end

  // ---- Static check tasks ----
  task check8(input logic [8:0] got, input logic [8:0] expected);
    if (got !== expected)
      $display("8-bit mismatch | Got=%h | Exp=%h", got, expected);
    else
      $display("8-bit OK | Sum=%h", expected[7:0]);
  endtask

  task check16(input logic [16:0] got, input logic [16:0] expected);
    if (got !== expected)
      $display("16-bit mismatch | Got=%h | Exp=%h", got, expected);
    else
      $display("16-bit OK | Sum=%h", expected[15:0]);
  endtask

  task check32(input logic [32:0] got, input logic [32:0] expected);
    if (got !== expected)
      $display("32-bit mismatch | Got=%h | Exp=%h", got, expected);
    else
      $display("32-bit OK | Sum=%h", expected[31:0]);
  endtask

  task check64(input logic [64:0] got, input logic [64:0] expected);
    if (got !== expected)
      $display("64-bit mismatch | Got=%h | Exp=%h", got, expected);
    else
      $display("64-bit OK | Sum=%h", expected[63:0]);
  endtask

endmodule
