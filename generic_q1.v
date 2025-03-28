module signed32bitgeneric #(parameter N =32) (
  input  signed [N-1:0] a, x,
  input clk,
  output reg signed [(2*N)-1:0] out
);
  reg [$clog2(N):0] step = 0;
  reg signed [(2*N)-1:0] partial;
	reg signed [(2*N)-1:0] temp_partial;
  
  always @(posedge clk) begin
    if (step == 0) begin
      // Initialize partial product with multiplier in lower bits
      partial <= {{(N){1'b0}}, x};
      step <= 1;
    end else begin
      
      temp_partial = partial; // Use a temporary variable for calculations
      
      // Add/Subtract multiplicand based on current LSB
      if (temp_partial[0] == 1'b1) begin
        if (step == N) // Subtract for the sign bit (5th step)
          temp_partial[(2*N)-1:N] = temp_partial[(2*N)-1:N] - a;
        else
          temp_partial[(2*N)-1:N] = temp_partial[(2*N)-1:N] + a;
      end
      
      // Arithmetic right shift
      temp_partial = temp_partial >>> 1;
      partial <= temp_partial; // Update partial with non-blocking
      
      // Control step counter and output result
      if (step == N) begin
        out <= temp_partial;
        step <= 0;
      end else begin
        step <= step + 1;
      end
    end
  end
endmodule  //q1
