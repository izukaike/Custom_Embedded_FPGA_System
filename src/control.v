`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 01:38:00 PM
// Design Name: 
// Module Name: control
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


module control(
       input [10:0] opcode,
       output reg reg2_loc,
       output  reg uncondbranch,
       output  reg branch,
       output  reg mem_read,
       output  reg mem_to_reg,
       output  reg [1:0] alu_op,
       output reg mem_write,
       output  reg alu_src,
       output  reg reg_write
    );
    
    
    always @ (*) begin
        casex (opcode)
            `ADD,`SUB,`AND,`ORR : begin
                      reg2_loc <= 1'b0;
                      uncondbranch <= 1'b0;
                      branch <= 1'b0;
                      mem_read <= 1'b0;
                      mem_to_reg <= 1'b0;
                      alu_op <= 2'b10;
                      mem_write <= 1'b0;
                      alu_src <= 1'b0;
                      reg_write <= 1'b1;
             end
             //Done
            `LDUR: begin
                      reg2_loc <= 1'bX;
                      uncondbranch <= 1'b0;
                      branch <= 1'b0;
                      mem_read <= 1'b1;
                      mem_to_reg <= 1'b1;
                      alu_op <= 2'b00;
                      mem_write <= 1'b0;
                      alu_src <= 1'b1;
                      reg_write <= 1'b1;
            end
            `STUR: begin
                      reg2_loc <= 1'b1;
                      uncondbranch <= 1'b0;
                      branch <= 1'b0;
                      mem_read <= 1'b0;
                      mem_to_reg <= 1'bX;
                      alu_op <= 2'b00;
                      mem_write <= 1'b1;
                      alu_src <= 1'b1;
                      reg_write <= 1'b0;
             end
            `CBZ:
             begin
                      reg2_loc <= 1'b1;
                      uncondbranch <= 1'b0;
                      branch <= 1'b1;
                      mem_read <= 1'b0;
                      mem_to_reg <= 1'b0;
                      alu_op <= 2'b01;
                      mem_write <= 1'b0;
                      alu_src <= 1'b0;
                      reg_write <= 1'b0;
            end
            `B:
             begin
                      reg2_loc <= 1'b0;
                      uncondbranch <= 1'b1;
                      branch <= 1'b0;
                      mem_read <= 1'b0;
                      mem_to_reg <= 1'b0;
                      alu_op <= 2'b00;
                      mem_write <= 1'b0;
                      alu_src <= 1'b0;
                      reg_write <= 1'b0;
            end
            default : begin
                      reg2_loc <= 1'b0;
                      uncondbranch <= 1'b0;
                      branch <= 1'b0;
                      mem_read <= 1'b0;
                      mem_to_reg <= 1'b0;
                      alu_op <= 2'b00;
                      mem_write <= 1'b0;
                      alu_src <= 1'b0;
                      reg_write <= 1'b0;
             end
         endcase  
    end
endmodule


