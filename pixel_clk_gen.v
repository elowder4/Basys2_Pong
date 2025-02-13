`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2025 09:01:40 PM
// Design Name: 
// Module Name: pixel_clk_gen
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


module pixel_clk_gen(
	input clk_in,
	output reg clk_out = 1'b1
 );
 
	always @(posedge clk_in) begin
		clk_out <= ~clk_out;
	end
endmodule
