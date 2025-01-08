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
    input clk,
 
    input [`WORD-1:0] cur_pc_in,//
    output logic [`WORD-1:0] cur_pc,//
    
    input logic  [4:0] write_register_in,
    output logic [4:0] write_register,  //missing from test bench
    
    input [`WORD-1:0] sign_extended_output_in, //
    
    input [1:0] alu_op_in,
    
    input uncondbranch_in,
    input branch_in,
    input mem_read_in,
    input mem_to_reg_in,
    //input [1:0] alu_op_in,
    input mem_write_in,
    input alu_src_in,
    input  reg_write_in, //is this an input or an output??
    input  reg2_loc_in,
    
    output logic uncondbranch,
    output logic branch,
    output logic mem_read,
    output logic mem_to_reg,
    //output [1:0] alu_op,
    output logic mem_write,
    //output alu_src,
    output logic reg_write, //is this an input or an output??
    //output reg2_loc,
    
    input [10:0] opcode_in, 
    output logic [10:0] opcode, 
    
    input [`WORD-1:0] read_data1_in, 
    
    input  [`WORD-1:0] read_data2_in, 
    output logic [`WORD-1:0] read_data2, 
        
    output logic [`WORD-1:0] branch_target, //
    output logic [`WORD-1:0] alu_result,
    output logic zero,
    output logic [`WORD-1:0] val
 );
 
 //buffer -> only buffer inputs
 logic [`WORD-1:0] sign_extended_output;
 logic alu_src;
 logic [1:0] alu_op;
 logic [`WORD-1:0] read_data1;
 always@(posedge(clk)) begin
    cur_pc <= cur_pc_in;
    uncondbranch <= uncondbranch_in;
    branch <= branch_in;
    mem_read <= mem_read_in;
    mem_to_reg <= mem_to_reg_in;
    mem_write <= mem_write_in;
    read_data2 <= read_data2_in;
    read_data1 <= read_data1_in;
    opcode     <= opcode_in;
    reg_write  <= reg_write_in;
    write_register <= write_register_in;
    sign_extended_output <= sign_extended_output_in;
    alu_src <= alu_src_in;
    alu_op <= alu_op_in;
 end
 
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