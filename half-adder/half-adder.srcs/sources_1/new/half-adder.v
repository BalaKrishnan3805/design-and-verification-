`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2025 16:38:35
// Design Name: 
// Module Name: half-adder
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


module half-adder(a,b,sum,carry);
input a,b;
outpt sum,carry;
assign sum=a^b;
assign carry=a&b;
endmodule
