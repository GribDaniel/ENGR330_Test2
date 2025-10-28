`timescale 1ns/1ps

module tb_adders;

  // WIDTH can now be overridden by compile-time define
  parameter int WIDTH = 32;
  parameter int NUM_TESTS = 16; // fewer for readability

  logic [WIDTH-1:0] a, b;
  logic cin;
  logic [WIDTH-1:0] sum_rca, sum_cla, sum_pre;
  logic cout_rca, cout_cla, cout_pre;

  // Instantiate DUTs
  rca #(WIDTH) dut_rca (.A(a), .B(b), .Cin(cin), .Sum(sum_rca), .Cout(cout_rca));
  cla #(WIDTH) dut_cla (.A(a), .B(b), .Cin(cin), .Sum(sum_cla), .Cout(cout_cla));
  prefix_adder #(WIDTH) dut_pre (.A(a), .B(b), .Cin(cin), .Sum(sum_pre), .Cout(cout_pre));

  logic [WIDTH:0] expected;
  integer i;

  task run_test(input logic [WIDTH-1:0] aa, bb, input logic cc);
    begin
        a = aa; b = bb; cin = cc; #10;  // <--- added small delay for waveform spacing
        expected = a + b + cin;

        $display("T=%0t ns | A=%h B=%h Cin=%b => RCA=%b%h CLA=%b%h PRE=%b%h | Exp=%h",
                $time, a, b, cin,
                cout_rca, sum_rca, cout_cla, sum_cla, cout_pre, sum_pre, expected);

        if ({cout_rca, sum_rca} !== expected)
        $display("❌ RCA mismatch");
        if ({cout_cla, sum_cla} !== expected)
        $display("❌ CLA mismatch");
        if ({cout_pre, sum_pre} !== expected)
        $display("❌ PREFIX mismatch");
    end
    endtask


    initial begin
        $display("Running %0d-bit adder tests...", WIDTH);
        $dumpfile($sformatf("results/waves_W%0d.vcd", WIDTH));
        $dumpvars(0, tb_adders);

        run_test({WIDTH{1'b0}}, {WIDTH{1'b0}}, 1'b0);
        run_test({WIDTH{1'b1}}, {WIDTH{1'b1}}, 1'b0);
        run_test({WIDTH{1'b1}}, {WIDTH{1'b0}}, 1'b1);
        run_test({WIDTH{1'b0}}, {WIDTH{1'b1}}, 1'b1);

        for (i = 0; i < NUM_TESTS; i++) begin
            a = $urandom;
            b = $urandom;
            cin = $random;
            run_test(a, b, cin);
        end

        $display("All tests complete for WIDTH=%0d.", WIDTH);
        $finish;
    end

endmodule
