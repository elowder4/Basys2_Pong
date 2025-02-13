`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2025 04:24:06 PM
// Design Name: 
// Module Name: pong
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


module pong 
	#(
	  parameter width = 'd800,
	  parameter height = 'd600, 
	  parameter ball_size = 'd10,
	  parameter paddle_length = 'd30, 
	  parameter paddle_width = 'd10,
	  parameter paddle_travel = 'd10,
	  parameter front_porch_h = 'd56, 
	  parameter sync_pulse_h = 'd120,
	  parameter back_porch_h = 'd64,
	  parameter front_porch_v = 'd37,
	  parameter sync_pulse_v = 'd6,
	  parameter back_porch_v = 'd23
	)
	(
	  input clk,
	  input sw_r_u,
	  input sw_r_d,
	  input sw_l_u,
	  input sw_l_d,
	  output reg [9:0] ball_x = (width >> 1), 
	  output reg [9:0] ball_y = (height >> 1),
	  output reg [9:0] paddle_r = (height >> 1), 
	  output reg [9:0] paddle_l = (height >> 1),
	  output [2:0] Red,
	  output [2:0] Green,
	  output [1:0] Blue,
	  output HS,
	  output VS
	);

	localparam up_l = 2'b00, dw_l = 2'b01, dw_r = 2'b10, up_r = 2'b11;
	
	reg [1:0] ball_dir = 'd2;
	
	wire frm_clk;
	//wire clk;
	wire collision_paddle, collision_side; 
	wire [3:0] buttons_out;
	wire sw_0, sw_1, sw_2, sw_3;

	// Process and update paddle positions
	always @(posedge frm_clk) begin
		// Debounce and synchronize
		if ((buttons_out[0]) && ((paddle_r <= (height - paddle_length - 'd2)))) begin
			if ((paddle_r + paddle_travel) > (height - paddle_length - 'd1)) begin
				paddle_r <= (height - paddle_length - 'd1);
			end else begin
				paddle_r <= paddle_r + paddle_travel;
			end
		end else if ((buttons_out[1]) && (paddle_r >= 'd1)) begin
			if (paddle_r < (paddle_travel - 'd1)) begin
				paddle_r <= 'd0;
			end else begin
				paddle_r <= paddle_r - paddle_travel;
			end
		end

		if ((buttons_out[2]) && (paddle_l <= (height - paddle_length - 'd2))) begin
			if ((paddle_l + paddle_travel) > (height - paddle_length - 'd1)) begin
				paddle_l <= (height - paddle_length - 'd1);
			end else begin
				paddle_l <= paddle_l + paddle_travel;
			end
		end else if ((buttons_out[3]) && (paddle_l >= 'd1)) begin
			if (paddle_l < (paddle_travel - 'd1)) begin
				paddle_l <= 'd0;
			end else begin
				paddle_l <= paddle_l - paddle_travel;
			end
		end
	end

	// Update ball position
	always @(posedge frm_clk) begin
		// Collision with edges or paddle
		if(collision_paddle) begin
			case (ball_dir)
				up_l: begin
					ball_dir <= up_r;
					ball_x <= ball_x + 'd1;
					ball_y <= ball_y - 'd2;
				end
				
				up_r: begin
					ball_dir <= up_l;
					ball_x <= ball_x - 'd1;
					ball_y <= ball_y - 'd2;
				end
				
				dw_l: begin
					ball_dir <= dw_r;
					ball_x <= ball_x + 'd1;
					ball_y <= ball_y + 'd2;
				end

				dw_r: begin
					ball_dir <= dw_l;
					ball_x <= ball_x - 'd1;
					ball_y <= ball_y + 'd2;
				end
			endcase
		end else if (collision_side) begin
			case (ball_dir)
				up_l: begin
					ball_dir <= dw_l;
					ball_x <= ball_x - 'd1;
					ball_y <= ball_y + 'd2;
				end
				
				up_r: begin
					ball_dir <= dw_r;
					ball_x <= ball_x + 'd1;
					ball_y <= ball_y + 'd2;
				end
				
				dw_l: begin
					ball_dir <= up_l;
					ball_x <= ball_x - 'd1;
					ball_y <= ball_y - 'd2;
				end

				dw_r: begin
					ball_dir <= up_r;
					ball_x <= ball_x + 'd1;
					ball_y <= ball_y - 'd2;
				end
			endcase
		end
		
		// Update position
		else begin 
			case (ball_dir)
				up_l: begin
					 ball_x <= ball_x - 'd1;
					 ball_y <= ball_y - 'd2;
				end

				dw_l: begin
					 ball_x <= ball_x - 'd1;
					 ball_y <= ball_y + 'd2;
				end

				dw_r: begin
					 ball_x <= ball_x + 'd1;
					 ball_y <= ball_y + 'd2;
				end

				up_r: begin
					 ball_x <= ball_x + 'd1;
					 ball_y <= ball_y - 'd2;
				end
			endcase
		end
	  
	   // Going into the void, game is over
		if ((ball_x == 'd0) || (ball_x > (width - ball_size + 'd2))) begin
			ball_x <= width >> 1;
			ball_y <= height >> 1;
			ball_dir <= up_r;
		end
	end
    
   assign collision_paddle =  ((
								// Collsion with left paddle
								(ball_x == paddle_width - 'd1) && 
                        (ball_y <= (paddle_l + paddle_length)) &&
                        (ball_y >= paddle_l - ball_size) &&
								((ball_dir == up_l) || (ball_dir == dw_l))
                        ) || (
								// Collision with right paddle
                        ((ball_x + ball_size) == (width - paddle_width - 'd1)) && 
                        (ball_y <= (paddle_r + paddle_length)) &&
                        (ball_y >= (paddle_r - ball_size)) &&
								((ball_dir == up_r) || (ball_dir == dw_r))));
								
	assign collision_side = ((
								// Collision with borders
                        (ball_y <= 'd1) && ((ball_dir == up_r) || (ball_dir == up_l))
                        ) || (
                        (ball_y >= (height - ball_size - 'd1)) && ((ball_dir == dw_r) || (ball_dir == dw_l))));

   /*
	pixel_clk_gen pxl_clk
	(
		.clk_in(CLK),
		.clk_out(clk)
	);
	*/
	
	frame_clock_gen
	#(
		.count((width+front_porch_h+sync_pulse_h+back_porch_h)*(height+front_porch_v+sync_pulse_h+back_porch_h))
	)
	frame_clk
	(
		.clk_in(clk),
		.clk_out(frm_clk)
	);

	clock_generator clk_deb
	(
		.clk_in(clk),
		.clk_out(clk_debounce)
	);
    
	debouncer d0
	(
		.clk(clk_debounce),
		.switch_input(sw_r_u),
		.button_press(sw_0)
	);

	debouncer d1
	(
		.clk(clk_debounce),
		.switch_input(sw_r_d),
		.button_press(sw_1)
	);

	debouncer d2
	(
		.clk(clk_debounce),
		.switch_input(sw_l_u),
		.button_press(sw_2)
	);

	debouncer d3
	(
		.clk(clk_debounce),
		.switch_input(sw_l_d),
		.button_press(sw_3)
	);
	
	button_sync btn_sync(
		.clk_in(clk_debounce),
		.clk_out(frm_clk),
		.buttons_in({sw_0, sw_1, sw_2, sw_3}),
		.buttons_out(buttons_out)
	);
    
	frame_gen
   #(
		.width(width),
		.height(height), 
		.ball_size(ball_size),
		.paddle_length(paddle_length), 
		.paddle_width(paddle_width),
		.fph(front_porch_h), 
		.sph(sync_pulse_h),
		.bph(back_porch_h),
		.fpv(front_porch_v),
		.spv(sync_pulse_v),
		.bpv(back_porch_v)
	) 
	frm 
	(
		.clk(clk), 
		.ball_x(ball_x), 
		.ball_y(ball_y),
		.paddle_r(paddle_r),
		.paddle_l(paddle_l), 
		.red(Red),
		.green(Green),
		.blue(Blue),
		.HS(HS),
		.VS(VS)
	);
endmodule
