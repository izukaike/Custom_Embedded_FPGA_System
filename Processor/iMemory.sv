`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2024 07:45:45 AM
// Design Name: 
// Module Name: iMemory
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


module iMemory(
    input clk,
    input zero_in,//
    input uncondbranch_in,//
    input branch_in,//
    input mem_read_in,  //
    input mem_to_reg_in,//       
    input mem_write_in,   //      
    input [`WORD-1:0] mem_address_in,         
    input logic [`WORD-1:0] mem_write_data_in, // this is read_data2 
    input [`WORD-1:0] branch_target_in,//
    input [`WORD-1:0] cur_pc_in,//
    
    //input [`WORD-1:0] alu_result_in,//
    input reg_write_in,//
    input [10:0] opcode_in,//
    //input [`WORD-1:0] read_data2_in,//
    
    //input reg_write_in,
    //output logic reg_write,
            
    output logic pc_src,
    output logic [`WORD-1:0] mem_read_data,
    output logic [`WORD-1:0] cur_pc,
    
    output logic mem_to_reg,
    output logic [10:0] opcode,
    output logic reg_write,
    output logic [`WORD-1:0] mem_address,
    
    input logic  [4:0] write_register_in,
    output logic [4:0] write_register  //missing from test bench
    
);
    logic uncondbranch;
    logic branch;
    logic mem_read; 
    logic mem_write;
    logic zero;
    logic [`WORD-1:0] mem_write_data; 
    logic branch_target;
    //assign mem_address  = mem_address_in;
    assign mem_write    = mem_write_in;
    always@(posedge(clk)) begin
        cur_pc         <= cur_pc_in;
        write_register <= write_register_in;
        uncondbranch   <= uncondbranch_in;
        branch         <= branch_in;
        mem_read       <= mem_read_in;
        mem_to_reg     <= mem_to_reg_in;
        //mem_write      <= mem_write_in;
        mem_write_data <= mem_write_data_in; 
        opcode         <= opcode_in;
        reg_write      <= reg_write_in;
        mem_address    <= mem_address_in;
        zero           <= zero_in;
        branch_target  <= branch_target_in;
    end
        

 assign pc_src =  (branch & zero) | uncondbranch; 

	reg[`WORD-1:0] memfile [32-1:0];
	
    initial
        $readmemb(`DMEMFILE, memfile);

logic [`WORD-1:0] index;
assign index = mem_address_in >> 3;
//should retrieve data from the registers on the rising edge of read clk
always @(posedge(clk)) begin
        if(mem_read_in == 1'b1) 
            mem_read_data <= memfile[index];
end

always @(posedge(clk)) begin 
        if(mem_write == 1'b1)
            memfile[index] <= mem_write_data;
end
endmodule
