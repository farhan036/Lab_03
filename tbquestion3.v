`timescale 1ns/1ps

module tb_signed_dadda_multiplier;
    reg signed [31:0] A, B;
    wire signed [63:0] P;
    
    // Instantiate the multiplier
    signed_dadda_multiplier uut (
        .A(A),
        .B(B),
        .P(P)
    );
    
    // Helper task to display results
    task display_result;
        input [31:0] a, b;
        input [63:0] p;
        begin
            $display("A = %0d (0x%h), B = %0d (0x%h)", a, a, b, b);
            $display("P = %0d (0x%h)", p, p);
            $display("Expected = %0d", $signed(a) * $signed(b));
            if (p === $signed(a) * $signed(b))
                $display("PASS");
            else
                $display("FAIL");
            $display("----------------------------------");
        end
    endtask
    
    initial begin
        $dumpfile("signed_dadda_multiplier.vcd");
        $dumpvars(0, tb_signed_dadda_multiplier);
        
        // Test case 1: Simple positive numbers
        A = 5;
        B = 3;
        #10;
        display_result(A, B, P);
        
        // Test case 2: Positive * Negative
        A = 7;
        B = -4;
        #10;
        display_result(A, B, P);
        
        // Test case 3: Negative * Negative
        A = -8;
        B = -9;
        #10;
        display_result(A, B, P);
        
        // Test case 4: Zero cases
        A = 0;
        B = 12345;
        #10;
        display_result(A, B, P);
        
        A = -6789;
        B = 0;
        #10;
        display_result(A, B, P);
        
        // Test case 5: Maximum positive values
        A = 2147483647;  // 2^31-1
        B = 2147483647;
        #10;
        display_result(A, B, P);
        
        // Test case 6: Minimum negative values
        A = -2147483648;  // -2^31
        B = -2147483648;
        #10;
        display_result(A, B, P);
        
        // Test case 7: Mixed large values
        A = 123456789;
        B = -987654321;
        #10;
        display_result(A, B, P);
        
        // Test case 8: Random values
        A = $random;
        B = $random;
        #10;
        display_result(A, B, P);
        
        A = $random;
        B = $random;
        #10;
        display_result(A, B, P);
        
        $finish;
    end
endmodule