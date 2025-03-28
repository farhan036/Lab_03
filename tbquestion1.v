`timescale 1ns/1ps

module signed32bit_tb;
    reg signed [31:0] a, x;
    reg clk;
    wire signed [63:0] out;

    // Instantiate the DUT (Device Under Test)
    signed32bit uut (
        .a(a),
        .x(x),
        .clk(clk),
        .out(out)
    );

    // Clock Generation: 10ns period (100MHz)
    always #5 clk = ~clk;

    // Test Procedure
    initial begin
        clk = 0;

        // Test Case 1: Positive * Positive
        a = 32'd15;  
        x = 32'd3;   
        #330;  // Wait for 32 cycles (320ns)
        $display("Test 1 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 2: Positive * Negative
        a = 32'd20;  
        x = -32'd4;  
        #330;
        $display("Test 2 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 3: Negative * Positive
        a = -32'd25;  
        x = 32'd6;  
        #330;
        $display("Test 3 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 4: Negative * Negative
        a = -32'd8;  
        x = -32'd2;  
        #330;
        $display("Test 4 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 5: Large Positive Numbers
        a = 32'd100000;  
        x = 32'd50000;  
        #330;
        $display("Test 5 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 6: Large Negative Numbers
        a = -32'd123456;  
        x = -32'd654321;  
        #330;
        $display("Test 6 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 7: Zero * Any Number
        a = 32'd0;  
        x = 32'd500;  
        #330;
        $display("Test 7 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 8: Any Number * Zero
        a = 32'd12345;  
        x = 32'd0;  
        #330;
        $display("Test 8 -> a = %d, x = %d, out = %d", a, x, out);

        // Test Case 9
        a = -32'sd1000000000;
        x = 32'sd2000000000;  
        #330;
        $display("Test 9 -> a = %d, x = %d, out = %d", a, x, out);

        // End Simulation
        $finish;
    end
endmodule
