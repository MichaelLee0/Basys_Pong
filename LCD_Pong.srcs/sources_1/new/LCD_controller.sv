`timescale 1ns / 1ps
`include "LCD_state_machine.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 09:38:11 PM
// Design Name: 
// Module Name: LCD_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module will interface with the lcd state machine and print out the character it is given
// Bascially, it will just change d_in and data_ready. It will also monitor busy flag
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD_controller(
    clock,
    reset,
    rs,
    e,
    d
//    controller_busy,      // temporarily commented this out because it's a floating port
//    character           // testing for different data in 
    );
    
    input clock;
    input reset;
    output rs;                              //tells the LCD screen to expect an instruction or a character
    output e;                               // enables the LCD screen to write (?)
    output [7:0] d;                         // sends data to the LCD screen
//    output controller_busy;                 // signal for other modules to hold up 
//    input [8:0] character;
    
    reg [8:0] character = 9'b001000010;      // dummy default - later set by game logic
    reg data_ready = 1'b1;                   // dummy default - later set by game logic
    reg controller_busy = 1'b0;
    reg [4:0] state = 3'b000;
    reg busy_flag;                         // from statemachine (delete after debug)
    reg e;
    reg [7:0] d;
    reg count = 1'b0;                              // Test variable for simulation
    reg internal_reset;                     // reset signal for the display
    
    parameter STATE0 = 3'b000;
    parameter STATE1 = 3'b001;
    parameter STATE2 = 3'b010;
    parameter CURSOR_R_STATE = 3'b100;
    parameter RESET_STATE = 3'b011;
    
    // initialize the LCD state machine
    LCD_state_machine lcd_sm(
      .clock(clock),
      .internal_reset(internal_reset),
      .rs(rs),
      .e(e),
      .d(d),
      .d_in(character),
      .data_ready(data_ready),
      .busy_flag(busy_flag)
     );
     
    always_ff @(posedge clock) begin
        
        case(state)
            // Initialization state
            STATE0: begin
                if (busy_flag) begin
                    controller_busy <= 1'b1;
                    state <= STATE2;
                end else
                    state <= STATE1;
            end
            
            // Send data state
            STATE1: begin
                // data and data ready coming into this module presumably already gets loaded into data_ready
                if (data_ready) begin
                    state <= CURSOR_R_STATE;    // The LCD screen needs to process the data coming in now\
                    controller_busy <= 1'b1;       // Raise the module's busy flag
//                    data_ready <= 1;        // In this case, data is always ready - this will later be decided by game logic
                    // For simulation (DELETE)
                    
                end
            end
            
            // waiting state
            STATE2: begin
                if (reset == 0)         // If reset, clear screen and start at beginning
                    state <= RESET_STATE;
                if (!busy_flag && data_ready) begin
                    state <= STATE1;
                    controller_busy <= 1'b0;       // lower the module's busy flag
                    if (count == 1)
                        character <= 9'b000001011;
                        
                end
            end
            
            CURSOR_R_STATE: begin
                if(!busy_flag) begin
                    character <= 9'b000000110;      // I/D = High (right) and S = Low. Move cursor to the right
                    state <= STATE2;
                end
            end
            
            RESET_STATE: begin
                count <= count + 1;
                if (count == 0)
                    character <= 9'b000000001;      // Clear the screen
                else if (count == 1) begin
                    character <= 9'b000000010;      // Return to the home
                    count <= 1'b0;                  // Zero out the count
                    state <= STATE2;
                end
                
            end
            default: ;
             
        endcase
    end
    
     
     
endmodule
