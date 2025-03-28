module CSA #(parameter n=8)(
    input  [n-1:0] a, b, cin,
    output [n:0] sum,   // Extra bit for final carry
    output [n:0] cout   // Extra bit for shifting carry
); 
    wire [n-1:0] carry; // Temporary carry storage
    wire [n-1:0] summ;
    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin
            Fa full_adder (
                .a(a[i]),
                .b(b[i]),
                .cin(cin[i]),
                .sum(summ[i]),
                .cout(carry[i])  // Store intermediate carry
            );
        end
    endgenerate
    
    // Properly shift the carry left
    assign cout = {carry, 1'b0}; // Append 0 at LSB to shift
	assign sum = {1'b0,summ};
  
endmodule
