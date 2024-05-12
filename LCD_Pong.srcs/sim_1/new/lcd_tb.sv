`timescale 1ns / 1ns
//`include "LCD_state_machine.sv"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 12:54:24 AM
// Design Name: 
// Module Name: lcd_tb
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
// SIMPLE TESTBENCH TO VERIFY BEHAVIOR OF LCD DRIVER
//////////////////////////////////////////////////////////////////////////////////


module lcd_tb(

    );
    reg clock = 1'b0;
    reg internal_reset = 1'b0;
    reg [7:0] d_in;
    reg data_ready;
    reg rs;
    reg e;
    reg [7:0] d;
    reg busy_flag;
       
    LCD_state_machine lcd_sm(
    .clock(clock),
    .internal_reset(internal_reset),
    .d_in(d_in),
    .data_ready(data_ready),
    .rs(rs),
    .e(e),
    .d(d),
    .busy_flag(busy_flag)
        );
    
    // Create a 100Mhz clock
    always #10 clock <= ~clock; 
    
    initial begin
        #10 d_in <= 8'b00001111;
        #0 data_ready <= 1'b1;
        #32460100 $display("T=%0t End of Simulation", $realtime);
    end
endmodule
