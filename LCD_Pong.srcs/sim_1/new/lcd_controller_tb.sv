`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 10:35:05 PM
// Design Name: 
// Module Name: lcd_controller_tb
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


module lcd_controller_tb(

    );
    reg clock = 1'b0;
    reg internal_reset = 1'b0;
    reg rs;
    reg e;
    reg [7:0] d;
    reg controller_busy;
//    reg [8:0] character;     // for debug - might remove after
    
    LCD_controller lcd_controller0(
    clock,
    internal_reset,
    rs,
    e,
    d,
    controller_busy,
//    character
    );
    
    always #10 clock <= ~clock; 
    
    initial begin
//        character <= 9'b000001111;
//        if (d == 9'b000001111)
//            character <= 9'b00001001;
//        if (d == 9'b000001001)
//            character <= 9'b100001001;
        #32460100 $display("T=%0t End of Simulation", $realtime);
    end
 
endmodule
