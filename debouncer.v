`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2025 04:35:32 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer (
    input clk,
    input switch_input,
    output reg button_press = 1'b0
);

	// Synchronize the switch input to the clock
	reg sync_0, sync_1;

	always @(posedge clk) begin
		sync_0 <= switch_input;
		sync_1 <= sync_0;
	end

	// Debounce the switch
	reg [3:0] count;
	wire finished = &count; 

	always @(posedge clk) begin
		if (sync_1) begin
			count <= count + 'd1;
		end else begin
			count <= 'd0;
			button_press <= 1'b0;
		end

		if (finished) begin
			button_press <= 1'b1;
		end
	end
endmodule
