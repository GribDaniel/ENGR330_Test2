`timescale 1ns / 1ps

module tb_rca;

    parameter N = 8;   // Change this to test different widths

    // DUT Inputs
    reg  [N-1:0] A, B;
    reg          Cin;

    // DUT Outputs
    wire [N-1:0] Sum;
    wire         Cout;

    // Reference (golden model)
    reg  [N:0] expected;

    // Instantiate DUT
    rca #(N) DUT (
        .A(A), .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    integer i;

    initial begin
        $display("====== Testing %0d-bit RCA ======", N);

        // --- Directed Test Cases ---
        A = 0; B = 0; Cin = 0; #5;
        expected = A + B + Cin;
        check_output;

        A = 5; B = 10; Cin = 0; #5;
        expected = A + B + Cin;
        check_output;

        A = 8'hFF; B = 1; Cin = 0; #5;   // overflow
        expected = A + B + Cin;
        check_output;

        A = 8'hAA; B = 8'h55; Cin = 1; #5;
        expected = A + B + Cin;
        check_output;

        // --- Random Testing ---
        for (i = 0; i < 50; i = i + 1) begin
            A   = $urandom;
            B   = $urandom;
            Cin = $urandom & 1;
            #5;
            expected = A + B + Cin;
            check_output;
        end

        $display("ALL TESTS PASSED!");
        $finish;
    end

    task check_output;
        if ({Cout, Sum} !== expected) begin
            $display("ERROR: A=%0d B=%0d Cin=%0d | Got %b%b Expected %b",
                     A, B, Cin, Cout, Sum, expected);
            $stop;
        end
    endtask

endmodule
