`include "definitions.vh"



module instr_mem#(
    parameter SIZE=1024)(
    input wire clk,
    input wire[`WORD-1:0] pc,
    output reg[`INSTR_LEN-1:0] instruction
    );
	// TODO: create imem array here
	reg[`INSTR_LEN-1:0] imem [SIZE-1:0];
    
	// TODO: insert code here to fetch the correct
    //initialize memory from file
    initial
        $readmemh(`IMEMFILE, imem);
    
    always @(posedge(clk)) begin
           instruction <= imem[pc/4];
    end

endmodule
