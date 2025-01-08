`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 02:57:10 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input read_clk,
    input write_clk,
    
    input [4:0] read_register1,
    input [4:0] read_register2,
    input [4:0] write_register,
    input       reg_write,
    input  logic [`WORD-1:0]  write_data,
    output reg [`WORD -1:0] read_data1,
    output reg [`WORD -1:0] read_data2,
    output reg [`WORD-1:0] df [32-1:0],
    output wire [`WORD-1:0] val
);

//datafile array
    assign df = datafile;
	reg[`WORD-1:0] datafile [32-1:0];
    
    initial
        $readmemb(`RMEMFILE, datafile);

//should retrieve data from the registers on the rising edge of read clk
always @(posedge(read_clk),posedge(write_clk)) begin
        read_data1 <= datafile[read_register1];
        read_data2 <= datafile[read_register2];
        //val <= datafile[read_register2];
 end

always @(posedge(write_clk)) begin 
        if(reg_write == 1'b1)
            datafile[write_register] <= write_data;
                   //val <= write_data;    
end
       
endmodule