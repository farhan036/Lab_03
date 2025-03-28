`timescale 1ns/1ps

module question2tb;
    reg clk, rst;
    reg [32:0] x, a;
    wire [65:0] final;

    // Instantiate DUT
    question2 uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .a(a),
        .final(final)
    );

    // Generate 100MHz clock
    always #5 clk = ~clk;

    // Automated test task with proper clock synchronization
    task automatic run_test;
        input [32:0] test_x;
        input [32:0] test_a;
        begin
            // Apply reset and inputs
            rst = 1;
            x = test_x;
            a = test_a;
            #10;       // 1 full clock cycle
            
            // Release reset and wait for operation
            rst = 0;
            repeat(13) @(posedge clk); // Wait 13 full clock cycles
            
            // Capture result at stable clock edge
            @(negedge clk); // Capture during clock low phase
            $display("Time = %0t | X = %h | A = %h | Result = %d", 
                    $time, x, a, final);
            
            // Re-assert reset for clean transition
            rst = 1;
            #10;
        end
    endtask

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        #20; // Initial stabilization

        // Test 8 operations
        run_test(33'h00000000, 33'h00000000); // 0 * 0
        run_test(33'h00000001, 33'h00000000); // 1 * 0
        run_test(33'h00000000, 33'h00000001); // 0 * 1
        run_test(33'h00000006, 33'h00000001); // 6 * 1
        run_test(33'h00000007, 33'h00000003); // 7 * 3
        run_test(33'h00000003, 33'h00000003); // 3 * 3
        run_test(33'h1FFFFFFF, 33'h00000007); // Max * 7
        run_test(33'h1FFFFFFF, 33'h1FFFFFFF); // Max * Max

        // End simulation
        #100;
        $finish;
    end
endmodule