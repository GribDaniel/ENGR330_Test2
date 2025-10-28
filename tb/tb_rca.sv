`timescale 1ns / 1ps

module tb_rca;

    // WIDTH LIST
    localparam int NUM_CONFIGS = 4;
    localparam int WIDTH_0 = 8;
    localparam int WIDTH_1 = 16;
    localparam int WIDTH_2 = 32;
    localparam int WIDTH_3 = 64;

    


    // Loop through each width
    genvar i;
    generate
        for (i = 0; i < NUM_CONFIGS; i++) begin : WIDTH_TEST
            localparam int N =
                (i == 0) ? WIDTH_0 :
                (i == 1) ? WIDTH_1 :
                (i == 2) ? WIDTH_2 : WIDTH_3;

            // DUT Inputs
            logic  [N-1:0] A, B;
            logic          Cin;

            // DUT Outputs
            logic [N-1:0] Sum;
            logic         Cout;

            // Expected
            logic  [N:0]   expected;
            logic  [N-1:0] expected_sum;
            logic          expected_cout;

            // Instantiate DUT
            rca #(.N(N)) DUT (
                .A(A), .B(B),
                .Cin(Cin),
                .Sum(Sum),
                .Cout(Cout)
            );

            initial begin : SIM
                int j;
                $display("=== Testing %d-bit RCA ===", N);

                //Waveform dump
                #(1000*i); // delay start time for each config
                $dumpfile($sformatf("rca_%0dbit.vcd", N));
                $dumpvars(0, WIDTH_TEST[i]);

                // --- Directed tests ---
                A = '0; B = '0; Cin = 0; #5;
                expected = A + B + Cin; check_output();

                A = 5; B = 10; Cin = 0; #5;
                expected = A + B + Cin; check_output();

                A = '1; B = 1; Cin = 0; #5;  // overflow
                expected = A + B + Cin; check_output();

                // --- Random tests ---
                for (j = 0; j < 20; j++) begin
                    A   = $urandom;
                    B   = $urandom;
                    Cin = $urandom & 1;
                    #5;
                    expected = A + B + Cin;
                    expected_sum = expected[N-1:0];
                    expected_cout = expected[N];
                    check_output();
                end

                $display("%d-bit RCA PASSED ALL TESTS\n", N);
            end : SIM

            // Self-checking task (lexically scoped)
            task check_output;
                if ({Cout, Sum} !== expected) begin
                    $display("ERROR (%d-bit): A=%h B=%h Cin=%b -> Got %b%b Expected %b",
                             N, A, B, Cin, Cout, Sum, expected);
                    $stop;
                end
            endtask

        end : WIDTH_TEST
    endgenerate

    // Stop the entire simulation when all instances finish
    initial begin
        #10000;
        $display("=== ALL WIDTH TESTS COMPLETED ===");
        $finish;
    end

endmodule