`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 10:49:09 AM
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input  reg  [1:0] alu_op,
    input  reg  [10:0] opcode,
    output reg  [3:0] alu_control
    );
    
    always@(*) begin 
        
            casex(alu_op)
                `ALUOp_DTYPE,`ALUOp_B: begin
                        alu_control = `ALU_ADD;
                 end
                `ALUOp_CBZ: begin
                        alu_control = `ALU_PASS;
                 end
                 `ALUOp_RTYPE: begin
                        alu_control[3] = 0;
                        alu_control[2] = opcode[9];
                        alu_control[1] = opcode[3];
                        alu_control[0] = opcode[8];
                  end    
                  default: begin
                        alu_control = `ALU_AND;
                  end
             endcase  
     end
endmodule
