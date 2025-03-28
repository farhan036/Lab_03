module signed_dadda_multiplier (
    input  signed [31:0] A,
    input  signed [31:0] B,
    output signed [63:0] P
);
    // Generate partial products with sign extension
    wire [63:0] pp [0:31];
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : gen_pp
            // For bits 0-30: A shifted left by i
            assign pp[i] = {(64){B[i]}} & {{(32-i){A[31]}}, A[31:0], {i{1'b0}}};
        end
        // For bit 31: special handling for the sign bit (-A shifted left by 31)
        assign pp[31] = {(64){B[31]}} & ~{{32{A[31]}}, A[31:0], {31{1'b0}}} + {{63{1'b0}}, 1'b1};
    endgenerate

    // Sum the partial products 
    // Level 1: 16 sums (each sums 2 partial products)
    wire signed [63:0] sum1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            assign sum1[i] = pp[2*i] + pp[2*i+1];
        end
    endgenerate

    // Level 2: 8 sums
    wire signed [63:0] sum2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2
            assign sum2[i] = sum1[2*i] + sum1[2*i+1];
        end
    endgenerate

    // Level 3: 4 sums
    wire signed [63:0] sum3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3
            assign sum3[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate

    // Level 4: 2 sums
    wire signed [63:0] sum4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4
            assign sum4[i] = sum3[2*i] + sum3[2*i+1];
        end
    endgenerate

    // Final sum to produce the product
    assign P = sum4[0] + sum4[1];
endmodule // q3