`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2025 16:52:55
// Design Name: 
// Module Name: halfadder_tb
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


module halfadder_tb();
reg t_a,t_b;
wire SUM,CARRY;
halfadder dut(.a(t_a),.b(t_b),.sum(SUM),.carry(CARRY));
initial begin
t_a=0;t_b=0;
#10t_a=1;t_b=0;
#10t_a=0;t_b=1;
#10t_a=1;t_b=1;
#10
$stop;
end

endmodule
