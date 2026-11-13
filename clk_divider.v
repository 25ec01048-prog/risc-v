`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2026 15:46:53
// Design Name: 
// Module Name: clk_divider
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


module clk_divider #(parameter countmax = 50000000)(
    input clk,
    output reg clkout
    );
    reg[25:0] count;
    always@(negedge clk) begin 
    count<=count+1;
    if(count==countmax)
    begin clkout<= ~clkout;
    count<=0;
    end
    end
    
endmodule
