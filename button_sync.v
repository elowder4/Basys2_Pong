`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:48 02/01/2025 
// Design Name: 
// Module Name:    button_sync 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module button_sync(
    input clk_in,             
    input clk_out,            
    input [3:0] buttons_in,   
    output reg [3:0] buttons_out  
);

    reg [3:0] btn_request = 4'b0000; 
    reg [3:0] sync_ack_1, sync_ack_2; 
    reg [3:0] btn_ack = 4'b0000; 
    reg [3:0] btn_latched = 4'b0000; 

    // Generate request when button is pressed
    always @(posedge clk_in) begin
        if (buttons_in & ~btn_request) begin
            btn_request <= buttons_in; 
        end else if (sync_ack_2) begin
            btn_request <= 4'b0000; // Clear request when acknowledged
        end
    end

    // Synchronize request into clk_out domain
    always @(posedge clk_out) begin
        btn_latched <= btn_request; 
    end

    // Generate acknowledge signal
    always @(posedge clk_out) begin
        buttons_out <= btn_latched & ~btn_ack; 
        btn_ack <= btn_latched; 
    end

    // Synchronize acknowledge back to clk_in
    always @(posedge clk_in) begin
        sync_ack_1 <= btn_ack;
        sync_ack_2 <= sync_ack_1;
    end

endmodule
