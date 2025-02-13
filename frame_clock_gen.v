`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2025 07:16:28 PM
// Design Name: 
// Module Name: frame_clock_gen
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


module frame_clock_gen
    #(
        parameter count = 'd68640
    )
    (
        input clk_in,
        output clk_out
    );
    
    reg [21:0] counter = 'd0; // given a minimum of 56Hz and a base clock of 50MHz this should be sufficent
    reg clk_r = 1'b1;
    
    always @(posedge clk_in) begin
        if (counter == ((count >> 1) - 'd1)) begin
            clk_r <= ~clk_r;
            counter <= 'd0;
        end else begin
            counter <= counter + 'd1;
        end
    end
    
    assign clk_out = clk_r;
    
endmodule
