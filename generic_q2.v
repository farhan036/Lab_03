//The output will be generated in the N-th cycle, depending on N
module generic_question2 #(parameter N =8 )( 
    input clk, rst,
    input [N:0] x, a,
    output  [((2*N)+1):0] final 
);
    reg [N+2:0] inp1, inp2, inp3;
    wire [N+3:0] s1, c1;
    wire [N+5:0] s3, c3;
    reg [N+5:0] s3r, c3r;
    wire [N+4:0] s2, c2;
    reg [N:0] local_x;
    reg [N:0] lower;
    reg [N:0] upper;
    
    // First CSA
    CSA #((N+3)) csa1(
        .a(inp1),
        .b(inp2),
        .cin(inp3),
        .sum(s1),
        .cout(c1)
    );
    
    // Second CSA
    CSA #((N+4)) csa2(
        .a(s1),
        .b(s3r[(N+3):0]),
        .cin(c3r[(N+3):0]),
        .sum(s2),
        .cout(c2)
    );
    
    // Third CSA
    CSA #((N+5)) csa3(
        .a({1'b0, c1}),
        .b(s2),
        .cin(c2),
        .sum(s3),
        .cout(c3)
    );
    
    // Sequential logic
   reg [((2*N)+1):0] final_reg;
assign final = final_reg;

always @(posedge clk) begin
    if (rst) begin
        inp1 <= 0;
        inp2 <= 0;
        inp3 <= 0;
        s3r  <= 0;
        c3r  <= 0;
        local_x<=x;
        lower<=0;
        upper<=0;
        final_reg <= 0;
    end

    else begin
        // Partial products
        inp1 <= (local_x[0]) ? {2'b00, a} : 0;
        inp2 <= (local_x[1]) ? {1'b0, a, 1'b0} : 0;
        inp3 <= (local_x[2]) ? {a, 2'b00} : 0;
        
        // Store CSA outputs shifted
        s3r <= (s3 >> 3);
        c3r <= (c3 >> 3);

        // Lower and upper update
        
        lower <= {3'b000, lower[N:3]} + { (s3[2:0] + c3[2:0]), {{(N-2){1'b0}}} };
        upper = s3r + c3r;


    
        final_reg = {upper, lower};  // After updating upper/lower, concatenate
        local_x<=local_x>>3;
    end
end

endmodule
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
  
endmodule //final 