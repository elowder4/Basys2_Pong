`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2025 11:13:47 AM
// Design Name: 
// Module Name: frame_gen
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


module frame_gen
#(
	parameter width = 'd800,
	parameter height = 'd600, 
	parameter ball_size = 'd5,
	parameter paddle_length = 'd30, 
	parameter paddle_width = 'd5,
	parameter fph = 'd56, 
	parameter sph = 'd120,
	parameter bph = 'd64,
	parameter fpv = 'd37,
	parameter spv = 'd6,
	parameter bpv = 'd23
	)(
	input clk, 
	input [9:0] ball_x,
	input [9:0] ball_y,
	input [9:0] paddle_r,
	input [9:0] paddle_l,
	output [2:0] red,
	output [2:0] green,
	output [1:0] blue,
	output HS,
	output VS
);
    
	 
	reg [11:0] ih = width + fph;
	reg [9:0] iv = height + fpv;
	
	wire left_paddle, right_paddle, ball, border;
	
	always @(posedge clk) begin
		// Manage indices
		if (ih >= (width + fph + sph + bph - 'd1)) begin
			if (iv >= (height + fpv + spv + bpv - 'd1)) begin
				iv <= 'd0;
			end else begin
				iv <= iv + 'd1;
			end
			
			ih <= 'd0;
		end else begin
			ih <= ih + 'd1;
		end
	end
	
	assign red = {3{((ih < width) && (iv < height) && (ball || left_paddle || right_paddle || border))}};
	assign green = {3{((ih < width) && (iv < height) && (ball || left_paddle || right_paddle || border))}};
	assign blue = {2{((ih < width) && (iv < height) && (ball || left_paddle || right_paddle || border))}};
	
	assign VS = !((iv >= (height + fpv)) && (iv < (height + fpv + spv)));
	assign HS = !((ih >= (width + fph)) && (ih < (width + fph + sph)));
  
	
	assign ball = (((iv >= ball_y) && (iv <= (ball_y + ball_size))) &&
					  ((ih >= ball_x) && (ih <= (ball_x + ball_size))));
					  
	assign left_paddle = (((iv >= paddle_l) && (iv <= (paddle_l + paddle_length))) &&
								((ih >= 'd0) && (ih <= (paddle_width - 'd1))));
								
	assign right_paddle = (((iv >= paddle_r) && (iv <= (paddle_r + paddle_length))) &&
								 ((ih >= (width - paddle_width - 'd1)) && (ih <= (width - 'd1))));
								 
	assign border = (((ih <= 'd0) || (ih == (width - 'd1)) || (iv <= 'd0) || (iv == (height - 'd1))));
								 
endmodule
