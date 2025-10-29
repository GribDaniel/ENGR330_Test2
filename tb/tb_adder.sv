`timescale 1ns / 1ps

module tb_adder;

  // Common signals
  logic [63:0] a, b;
  logic        cin;
  logic [63:0] sum;
  logic        cout;

  // -----------------------------------------------
  // DUT Selection
  // -----------------------------------------------
`ifdef TARGET_RCA
    rca #(.N(64)) dut (.A(a), .B(b), .Cin(cin), .Sum(sum), .Cout(cout));
`elsif TARGET_CLA
    cla #(.N(64)) dut (.A(a), .B(b), .Cin(cin), .Sum(sum), .Cout(cout));
`elsif TARGET_PREFIX
    prefix #(.N(64)) dut (.A(a), .B(b), .Cin(cin), .Sum(sum), .Cout(cout));
`else
    initial $fatal("No TARGET_xxx macro defined!");
`endif

  // -----------------------------------------------
  // File-based test vector input (using plusargs)
  // -----------------------------------------------
  initial begin : READ_VECTORS
    integer fd;
    integer line;
    reg [63:0] A, B, EXP_SUM;
    reg CIN, EXP_COUT;
    string vec_file;

    // Read file name from +VEC_FILE= argument
    if (!$value$plusargs("VEC_FILE=%s", vec_file))
      vec_file = "tb/test_vectors.txt";

    fd = $fopen(vec_file, "r");
    if (fd == 0) begin
      $display("❌ Cannot open vector file: %s", vec_file);
      $finish;
    end

    $display("\n=== Functional Test for Adder ===");
    line = 0;

    while (!$feof(fd)) begin
      line = line + 1;
      if ($fscanf(fd, "%h %h %b %h %b\n", A, B, CIN, EXP_SUM, EXP_COUT) == 5) begin
        a = A;
        b = B;
        cin = CIN;
        #5;
        if (sum !== EXP_SUM || cout !== EXP_COUT)
          $display("❌ [Line %0d] a=%h b=%h cin=%b → sum=%h cout=%b (expected %h %b)",
                   line, a, b, cin, sum, cout, EXP_SUM, EXP_COUT);
        else
          $display("✅ [Line %0d] a=%h b=%h cin=%b OK",
                   line, a, b, cin);
      end
    end

    $fclose(fd);
    $display("=== All vectors processed ===\n");
    $finish;
  end

  // -----------------------------------------------
  // Optional waveform dump (using plusarg)
  // -----------------------------------------------
  initial begin : DUMP_WAVE
    string wavefile;
    if (!$value$plusargs("WAVE_FILE=%s", wavefile))
      wavefile = "results/waves_generic.vcd";

    $dumpfile(wavefile);
    $dumpvars(0, tb_adder);
  end

endmodule
