`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 01:14:54 PM
// Design Name: 
// Module Name: sign_extender
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


module sign_extender(
     input [`INSTR_LEN-1:0]  instruction,
     output reg [`WORD-1:0]  sign_extended_output,
     output reg [`WORD-1:0] val
);

always @ (*) begin
    casex(instruction[31:21]) 
     `LDUR: begin
            sign_extended_output <= instruction[20:12];
      end
     `STUR: begin
            sign_extended_output <= instruction[20:12];
     end
     `CBZ: begin
                sign_extended_output <= {{45{instruction[23]}}, instruction[23:5]};
                val <= {{45{instruction[23]}}, instruction[23:5]};
      end
     `ORR: begin
            sign_extended_output <= 64'b0;
     end
     //i need to get here 
     `B: begin
            sign_extended_output <=  {{39{instruction[25]}}, instruction[25:0]};
            //val <= instruction[25:0];
     end
     default: begin
            sign_extended_output <= 64'b0;
     end
    endcase
end

endmodule
