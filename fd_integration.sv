`include "verification_functions.sv"

module fd_integration;

import verification::*;

int tc = 1;
int ts = 1;

string pc_string = "|cur_pc|";
string instr_string = "|instruction|";

string sign_extended_output_string = "|sign_extended_output|";
string reg2_loc_string = "|reg2_loc|";
string uncondbranch_string = "|uncondbranch|";
string branch_string = "|branch|";
string mem_read_string = "|mem_read|";
string mem_to_reg_string = "|mem_to_reg|";
string alu_op_string = "|alu_op|";
string mem_write_string = "|mem_write|";
string alu_src_string = "|alu_src|";
string reg_write_string = "|reg_write|";
string read_data1_string = "|read_data1|";
string read_data2_string = "|read_data2|";
string opcode_string = "|opcode|";


//general
wire clk;
wire [`INSTR_LEN-1:0] instruction;

//fetch
reg reset;
reg pc_src;
reg [`WORD-1:0] branch_target;
wire [`WORD-1:0] cur_pc;

reg [`INSTR_LEN-1:0] er_instruction;
reg [`WORD-1:0] er_cur_pc;

//decode
wire read_clk;
wire write_clk;
reg [`WORD-1:0] write_data = 0;
wire [`WORD-1:0] sign_extended_output;
//control
wire reg2_loc;
wire uncondbranch;
wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_write;
wire alu_src;
wire reg_write;
//Reg File
logic [`WORD-1:0]read_data1;
logic [`WORD-1:0]read_data2;
wire [10:0] opcode;

reg er_uncondbranch;
reg er_reg2_loc;
reg er_branch;
reg er_mem_read;
reg er_mem_to_reg;
reg [1:0] er_alu_op;
reg er_mem_write;
reg er_alu_src;
reg er_reg_write;
reg [`WORD-1:0] er_sign_extended_output;
reg [`WORD -1:0] er_read_data1;
reg [`WORD -1:0] er_read_data2;
reg [10:0] er_opcode; 
reg [`WORD-1:0] val;


oscillator clk_gen(clk);

delay clk_delay_1(
    .a(clk),
    .a_delayed(clk_plus_1)
    ); 
delay #(2) clk_delay_read(
    .a(clk),
    .a_delayed(read_clk)
    ); 
 //7  
delay #(7) clk_delay_write(
    .a(clk),
    .a_delayed(write_clk)
    );   


iFetch#(.SIZE(16))  iF(
    .clk(clk),
    .clk_delayed(clk_plus_1),
    .reset(reset),
    .pc_src(pc_src),
    .branch_target(branch_target),
    .instruction(instruction),
    .cur_pc(cur_pc),
    .incremented_pc(incremented_pc)
);

iDecode iD(
        .clk(clk),
        .read_clk(read_clk),
        .write_clk(write_clk),
        .instruction(instruction),
        .write_data(write_data), 
        .opcode(opcode),
        .sign_extended_output(sign_extended_output),
        .reg2_loc(reg2_loc),        
        .uncondbranch(uncondbranch),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .val(val)
);    
    
function void verify_control_signals();
    verify(ts++, reg2_loc_string, er_reg2_loc, $bits(er_reg2_loc), reg2_loc, $bits(reg2_loc), `BINARY);
    verify(ts++, uncondbranch_string, er_uncondbranch, $bits(er_uncondbranch), uncondbranch, $bits(uncondbranch), `BINARY);
    verify(ts++, branch_string, er_branch, $bits(er_branch), branch, $bits(branch), `BINARY);
    verify(ts++, mem_read_string, er_mem_read, $bits(er_mem_read), mem_read, $bits(mem_read), `BINARY);
    verify(ts++, mem_to_reg_string, er_mem_to_reg, $bits(er_mem_to_reg), mem_to_reg, $bits(mem_to_reg), `BINARY);
    verify(ts++, alu_op_string, er_alu_op, $bits(er_alu_op), alu_op, $bits(alu_op), `BINARY);
    verify(ts++, mem_write_string, er_mem_write, $bits(er_mem_write), mem_write, $bits(mem_write), `BINARY);
    verify(ts++, alu_src_string, er_alu_src, $bits(er_alu_src), alu_src, $bits(alu_src), `BINARY);   
    verify(ts++, reg_write_string, er_reg_write, $bits(er_reg_write), reg_write, $bits(reg_write), `BINARY);     
endfunction    
    

initial 
begin

	begin_test();
	// we will keep pc_src set to 0 for the entire test...we are not ready to branch yet
	pc_src = 0;
	
	// set reset to 1 to make sure that the PC doesn't increment on the first positive clock edge, 
	// then set it back to 0 after that first positive clock edge
	reset = 1;
	#`CYCLE;
	reset = 0;
	
    // LDUR X9, [X22, #64]
    $display("Test Case %0d: | LDUR X9, [X22, #64]", tc++);
	ts = 1;
	// set er values for the fetch and decode stages
	// fetch er
	er_cur_pc=`WORD'd0; 
	er_instruction = `INSTR_LEN'hF84402C9;
	//decode er
	er_opcode = 11'b11111000010;    
    er_sign_extended_output = 64;
    er_reg2_loc = 0;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 1;
    er_mem_to_reg = 1;
    er_alu_op = 00;
    er_mem_write = 0;
    er_alu_src = 1;
    er_reg_write = 1;
    er_read_data1 = 16;
    #2;
    // verify that the signals match the er values  
    
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    
    
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    
    
    write_data = 20;
    #3;
    
    
    // ADD X10, X19, X9 
    $display("Test Case %0d: | ADD X10, X19, X9", tc++);    
	ts = 1;
	// set er values for the fetch and decode stages 
	#5;
	 er_cur_pc=`WORD'd4; 
	er_instruction = 32'h8B09026A;
    er_opcode   = 11'b10001011000;    
    // er_sign_extended_output = 0;
    er_reg2_loc = 0;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 10;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 1;
    er_read_data1 = 10;
    er_read_data2 = 20;
    // verify that the signals match the er values 
   
    #2;
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    //verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    write_data = 30;
    #3;
    
    // SUB X11, X20, X10
    $display("Test Case %0d: | SUB X11, X20, X10", tc++);        
	ts = 1;
    #5;
	// set er values for the fetch and decode stages 
    er_cur_pc=`WORD'd8; 
	er_instruction = 32'hCB0A028B;
    er_opcode   = 11'b11001011000;    
    // er_sign_extended_output = 0;
    er_reg2_loc = 0;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 10;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 1;
    er_read_data1 = 30;
    er_read_data2 = 30;
    // verify that the signals match the er values 
    #2;
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    //verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    
    write_data = 0;
    #3;
    
    // STUR X11, [X22, #96]
    $display("Test Case %0d: | STUR X11, [X22, #96]", tc++);        
	ts = 1;
	ts = 1;
	#5;
    er_cur_pc=`WORD'd12; 
	er_instruction = `INSTR_LEN'hF80602CB;
	//decode er
	er_opcode = 11'b11111000000;    
    er_sign_extended_output = 96;
    er_reg2_loc = 1;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 00;
    er_mem_write = 1;
    er_alu_src = 1;
    er_reg_write = 0;
    er_read_data1 = 16;
	// set er values for the fetch and decode stages 
    // verify that the signals match the er values 
    #2
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    
    write_data = 0;
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    #3;
    
    // CBZ X11, -5
    $display("Test Case %0d: | CBZ X11, -5", tc++);        
	ts = 1;
	#5;
    er_cur_pc=`WORD'd16; 
	er_instruction = `INSTR_LEN'hB5FFFF6B;
	//decode er
	er_opcode = 11'b10110101111;   
	// set er values for the fetch and decode stages 
    
    er_sign_extended_output = -5;
    er_reg2_loc = 1;        
    er_uncondbranch = 0;
    er_branch = 1;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 01;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 0;
    er_read_data2 = 0;
    
    // verify that the signals match the er values 
    #2
    
    
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
   
    write_data = 0;
    #3;
    
    // CBZ X9, 8
    $display("Test Case %0d: | CBZ X11, 8", tc++);        
	ts = 1;

	er_cur_pc=`WORD'd20; 
	er_instruction = `INSTR_LEN'hB4000109;
	//decode er
	er_opcode = 11'b10110100000;   
	// set er values for the fetch and decode stages 
    #5;
    er_sign_extended_output = 8;
    er_reg2_loc = 1;        
    er_uncondbranch = 0;
    er_branch = 1;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 01;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 0;
    er_read_data2 = 20;
    
    // verify that the signals match the er values 
    #2
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    #3;
    write_data = 0;
    
    // B 64
    $display("Test Case %0d: | B 64", tc++);        
	ts = 1;
    er_cur_pc=`WORD'd24; 
	er_instruction = `INSTR_LEN'h14000040;
	//decode er
	er_opcode = 11'b00010100000;   
	// set er values for the fetch and decode stages 
    er_sign_extended_output = 64;
    er_reg2_loc = 0;        
    er_uncondbranch = 1;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 00;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 0;
    //er_read_data2 = 20;
    #5;
    // verify that the signals match the er values 
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    //verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    #2;
    write_data = 0;
    #3;
    
    // B -55
    $display("Test Case %0d: | B -55", tc++);        
	ts = 1;
    er_cur_pc=`WORD'd28; 
	er_instruction = `INSTR_LEN'h17FFFFC9;
	//decode er
	er_opcode = 11'b00010111111;   
	// set er values for the fetch and decode stages 
    er_sign_extended_output = -55;
    er_reg2_loc = 0;        
    er_uncondbranch = 1;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 00;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 0;
    //er_read_data2 = 20;
    #5;
    // verify that the signals match the er values 
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    //verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	#2;
     // since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    write_data = 0;
	#3;
    // ORR X9, X10, X21
    $display("Test Case %0d: | ORR X9, X10, X21", tc++);        
	ts = 1;
	er_cur_pc=`WORD'd32; 
	er_instruction = `INSTR_LEN'hAA150149;
	
	//decode er
	er_opcode = 11'b10101010000;   
	er_reg2_loc = 0;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 10;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 1;
    er_read_data1 = 30;
    er_read_data2 = 0;
    // verify that the signals match the er values 
    #5;
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    //verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    #2;
    write_data = 30;
    #3;

    // AND X9, X22, X10
    $display("Test Case %0d: | AND X9, X22, X10", tc++);        
	ts = 1;
    er_cur_pc=`WORD'd36; 
	er_instruction = `INSTR_LEN'h8A0A02C9;
	
	//decode er
	er_opcode = 11'b10001010000;   
	er_reg2_loc = 0;        
    er_uncondbranch = 0;
    er_branch = 0;
    er_mem_read = 0;
    er_mem_to_reg = 0;
    er_alu_op = 10;
    er_mem_write = 0;
    er_alu_src = 0;
    er_reg_write = 1;
    er_read_data1 = 16;
    er_read_data2 = 30;
    // verify that the signals match the er values 
    #5;
    verify(ts++, pc_string, er_cur_pc, $bits(er_cur_pc), cur_pc, $bits(cur_pc), `S_DEC);
    verify(ts++, instr_string, er_instruction, $bits(er_instruction), instruction, $bits(instruction), `HEX);

    verify(ts++, opcode_string, er_opcode, $bits(er_opcode), opcode, $bits(opcode), `BINARY);    
    //verify(ts++, sign_extended_output_string, er_sign_extended_output, $bits(er_sign_extended_output), sign_extended_output, $bits(sign_extended_output), `HEX);
    verify_control_signals();
    verify(ts++, read_data1_string, er_read_data1, $bits(er_read_data1), read_data1, $bits(read_data1), `S_DEC);
    verify(ts++, read_data2_string, er_read_data2, $bits(er_read_data2), read_data2, $bits(read_data2), `S_DEC);
 	// since we don't have an ALU or data memory yet, provide the write_data value (if applicable)
    #2;
    write_data = 16;
    #3;
    //*/
    final_result();

$finish;

end
endmodule