module signed32bit(
  input  signed [31:0] a, x,
  input clk,
  output reg signed [63:0] out
);
  reg [5:0] step = 0;
  reg signed [63:0] partial;
	reg signed [63:0] temp_partial;
  
  always @(posedge clk) begin
    if (step == 0) begin
      // Initialize partial product with multiplier in lower bits
      partial <= {32'b0, x};
      step <= 1;
    end else begin
      
      temp_partial = partial; // Use a temporary variable for calculations
      
      // Add/Subtract multiplicand based on current LSB
      if (temp_partial[0] == 1'b1) begin
        if (step == 32) // Subtract for the sign bit (5th step)
          temp_partial[63:32] = temp_partial[63:32] - a;
        else
          temp_partial[63:32] = temp_partial[63:32] + a;
      end
      
      // Arithmetic right shift
      temp_partial = temp_partial >>> 1;
      partial <= temp_partial; // Update partial with non-blocking
      
      // Control step counter and output result
      if (step == 32) begin
        out <= temp_partial;
        step <= 0;
      end else begin
        step <= step + 1;
      end
    end
  end
endmodule  //q1
