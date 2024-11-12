`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 08:58:04 AM
// Design Name: 
// Module Name: iExecute
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


module iExecute(
    input [`WORD-1:0] cur_pc,
    input [`WORD-1:0] sign_extended_output,
    input [1:0] alu_op,
    input alu_src,
    input [10:0] opcode, 
    input [`WORD-1:0] read_data1, 
    input [`WORD-1:0] read_data2,     
    output [`WORD-1:0] branch_target,
    output [`WORD-1:0] alu_result,
    output zero,
    output [`WORD-1:0] val
 );
 
 // alu control
 wire [3:0] alu_control;
 alu_control ctrl(
        .alu_op(alu_op),
        .opcode(opcode),
        .alu_control(alu_control)
);
        
 
 //mux
 wire [`WORD-1:0] mux_out_alu_in;
 mux #(`WORD) m(   
    .a_in(read_data2),
    .b_in(sign_extended_output),
    .control(alu_src),
    .mux_out(mux_out_alu_in)
);
 
 //ALU
 assign val = mux_out_alu_in;
 alu math(
        .a_in(read_data1),
        .b_in(mux_out_alu_in),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
);
        
 //adder
logic [`WORD-1:0] shift;
assign shift =  sign_extended_output << 2;
 adder add(
       .a_in(cur_pc),
       .b_in(shift),
       .add_out(branch_target)
);
 
 
endmodule