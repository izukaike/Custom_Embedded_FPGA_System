`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 01:33:14 AM
// Design Name: 
// Module Name: iDecode
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


module iDecode(
    input clk,
    input read_clk,
    input write_clk,
    input [`INSTR_LEN-1:0] instruction,
    input [`WORD-1:0] write_data,
    output [10:0] opcode,
    output [`WORD-1:0] sign_extended_output,
    output reg2_loc,        
    output uncondbranch,
    output branch,
    output mem_read,
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_write,
    output alu_src,
    output reg_write,
    output wire[`WORD-1:0] read_data1,
    output wire [`WORD-1:0] read_data2,
    output wire  [`WORD-1:0] val
    );
    
    //instruction parser
    wire [4:0] rm_num;
    wire [4:0] rn_num;
    wire [4:0] rd_num;
    wire [8:0] address;
    wire [10:0] op;
    wire [4:0]  mux_out;
    wire [`WORD-1:0] df [32-1:0];
    
    assign opcode = op;
    
   
    instr_parse ip(
        .instruction(instruction),
        .rm_num(rm_num),
        .rn_num(rn_num),
        .rd_num(rd_num),
        .address(address),
        .opcode(op)
        //.val(val)
    );
    
    //control unit
    control ctrl(
       .opcode(op),
       .reg2_loc(reg2_loc),
       .uncondbranch(uncondbranch),
       .branch(branch),
       .mem_read(mem_read),
       .mem_to_reg(mem_to_reg),
       .alu_op(alu_op),
       .mem_write(mem_write),
       .alu_src(alu_src),
       .reg_write(reg_write)
    );
   
    //reg file
    regfile r(
            .read_clk(read_clk),
            .write_clk(write_clk),
            .read_register1(rn_num),
            .read_register2(mux_out),
            .write_register(rd_num), // X9
            .reg_write(reg_write),
            .write_data(write_data), // this just isnt working
            .read_data1(read_data1),
            .read_data2(read_data2),
            .val(val)
    );

    
    //sign extender
    sign_extender sign_X(
            .instruction(instruction),
            .sign_extended_output(sign_extended_output)
            //.val(val)
    );
    
    //mux
    mux#(.SIZE(5)) m(
           .a_in(rm_num),
           .b_in(rd_num),
           .control(reg2_loc), 
           .mux_out(mux_out)
           //.val(val)
     );
endmodule
