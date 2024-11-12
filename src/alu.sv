`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 10:02:06 AM
// Design Name: 
// Module Name: alu
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


module alu(
        input  wire  [`WORD-1:0] a_in,
        input  wire  [`WORD-1:0] b_in,
        input  wire  [3:0] alu_control,
        output reg   [`WORD-1:0] alu_result,
        output reg   zero
    );  
   assign zero = alu_result == 0;
   always@(edge(a_in),edge(b_in),edge(alu_control)) begin
        case(alu_control)
            `ALU_AND: begin
                alu_result = a_in & b_in;
             end
             `ALU_ORR: begin
                alu_result = a_in | b_in;
             end
             `ALU_ADD: begin
                alu_result = a_in + b_in;
             end
             `ALU_SUB: begin
                alu_result = a_in - b_in;
             end
             `ALU_PASS: begin
                alu_result = b_in;
             end
             `ALU_NOR: begin
                alu_result = ~(a_in | b_in);
             end
             default: begin
                alu_result = a_in & b_in;
             end
        endcase
       end 
endmodule
