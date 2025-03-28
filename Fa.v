`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 04:26:13 PM
// Design Name: 
// Module Name: Fa
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fa(
input a,b,cin,
output cout,sum
    );
    wire u1,u2,u3;
    assign u1=a ^ b;
    assign u2= a&b;
    assign sum = u1 ^ cin;
    assign u3= u1 & cin;
    assign cout = u3 | u2;
    
    
    
    
endmodule
