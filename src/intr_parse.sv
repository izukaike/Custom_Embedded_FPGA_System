`include "definitions.vh"
module instr_parse(
    input [`INSTR_LEN-1:0] instruction,
    output [4:0] rm_num,
    output [4:0] rn_num,
    output [4:0] rd_num,
    output [8:0] address,
    output [10:0] opcode,
    output [`WORD-1:0] val
   );
   assign val = rm_num;
   assign opcode  = instruction[31:21];
   assign rm_num  = instruction[20:16];
   assign rn_num  = instruction[9:5];
   assign rd_num  = instruction[4:0];
   assign address = instruction[20:12];
   
endmodule