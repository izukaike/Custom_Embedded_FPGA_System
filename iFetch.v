`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:06:05 PM
// Design Name: 
// Module Name: iFetch
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


module iFetch#(
    parameter SIZE=16)(
    input wire clk,
    input wire clk_delayed,
    input wire reset,
    input wire pc_src,
    input wire[`WORD-1:0] branch_target,
    output wire[`INSTR_LEN-1:0] instruction,
    input wire[`WORD-1:0] cur_pc,
    output wire[`WORD-1:0] incremented_pc
    );
   
   
   wire [`WORD-1:0] new_pc;
   //wire [`WORD-1:0] incremented_pc = `WORD'b0;
  
   instr_mem#(.SIZE(SIZE)) imem(
            .clk(clk_delayed),
            .pc(cur_pc),
            .instruction(instruction)
    );
   mux#(.SIZE(`WORD)) m1(
           .a_in(incremented_pc),
           .b_in(branch_target),
           .control(pc_src), 
           .mux_out(new_pc)
    );
    register pc(
              .clk(clk),
              .reset(reset),
              .D(new_pc),
              .Q(cur_pc)
     );
     wire [`WORD-1:0] incr =  4;
     adder a1(
            .a_in(cur_pc),
            .b_in(incr),
            .add_out(incremented_pc)
    );
 
                      
endmodule
