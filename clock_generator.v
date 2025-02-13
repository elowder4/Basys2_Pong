`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2025 05:48:52 PM
// Design Name: 
// Module Name: clock_generator
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


module clock_generator(
    input clk_in, 
    output reg clk_out
    );
    
    reg [14:0] counter = 'd0; // 50000 counts 
    
    always @(posedge clk_in) begin
        if (counter == 'd12499) begin
            clk_out <= ~clk_out;
            counter <= 'd0;
        end else begin
            counter <= counter + 'd1;
        end
    end
endmodule
