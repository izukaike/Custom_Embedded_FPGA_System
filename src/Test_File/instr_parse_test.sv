`include "verification_functions.sv"

module instr_parse_test;
import verification::*;

// create signals to be be passed into/out of the instruction_parse module
reg [4:0] rm_num;
reg [4:0] rn_num;
reg [4:0] rd_num;
reg [8:0] address;
reg [10:0] opcode;
reg [`INSTR_LEN:0] instruction;
// create er signals that have the same names of the signals above except that they
// have er_ appended to the beginning of the name....for example, er_rm_num
reg [4:0] er_rm_num;
reg [4:0] er_rn_num;
reg [4:0] er_rd_num;
reg [8:0] er_address;
reg [10:0] er_opcode;
reg [`INSTR_LEN:0] instruction;

int ts = 1;
int tc = 1;
string rn_str = "|rn_num|";
string rd_str = "|rd_num|";
string addy_str = "|address|";
string opcode_str = "|opcode|";
string rm_str = "|rm_num|";

// use this instruction_parse instance for this test
instr_parse parser(
.instruction(instruction),
.rm_num(rm_num),
.rn_num(rn_num),
.rd_num(rd_num),
.address(address),
.opcode(opcode)
    );
 
initial
begin

begin_test();

// populate instructions below with the binary form of the assembly instructions
// listed in the comments.  Note that these are almost very similar to the instructions
// shown in the lecture on Machine Code


///////////////////////////////////////////////////////////////////////////////////////////////
// LDUR X9, [X22, #240]

///// TEST CASE 1 /////
$display("Test Case %0d", tc++);
$display("LDUR X9, [X22, #240]");
ts = 1;

// set instruction to the binary equivalent of the instruction listed above
//instruction = `INSTR_LEN'b11111000010 011110000 00 10110 01001
instruction = `INSTR_LEN'b11111000010011110000001011001001;
// wait for 2 ns
#(`CYCLE/5);

// DO NOT verify rm_num is correct because it is not relevant for a D Type instruction
// verify rn_num is correct
er_rn_num  = 'd22;
// verify rd_num is correct
er_rd_num  = 'd9;
// verify address is correct
er_address = 'd240;


// verify opcode is correct
er_opcode = 'h7c2;

verify(ts++, rn_str, er_rn_num, $bits(er_rn_num), rn_num , $bits(rn_num), `S_DEC);
verify(ts++, rd_str , er_rd_num, $bits(er_rd_num), rd_num, $bits(rd_num), `S_DEC);
verify(ts++, addy_str, er_address, $bits( er_address),  er_address, $bits( er_address), `S_DEC);
verify(ts++, opcode_str, er_opcode, $bits(er_opcode), opcode, $bits(opcode),`HEX);


// wait for 8 ns
#((`CYCLE*8)/10);

///////////////////////////////////////////////////////////////////////////////////////////////
// ADD X10, X21, X9

///// TEST CASE 2 /////
$display("\nTest Case %0d", tc++);
$display("ADD X10, X21, X9");

// set instruction to the binary equivalent of the instruction listed above
instruction = `INSTR_LEN'b10001011000010010000001010101010; 

// wait for 2 ns
#(`CYCLE/5);
// verify rn_num is correct
er_rn_num  = 'd21;
// verify rd_num is correct
er_rd_num  = 'd10;
// verify address is correct
er_rm_num = 'd9;


// verify opcode is correct
er_opcode = 'h458;


// verify opcode is correct
verify(ts++, rn_str, er_rn_num, $bits(er_rn_num), rn_num , $bits(rn_num), `S_DEC);
verify(ts++, rd_str , er_rd_num, $bits(er_rd_num), rd_num, $bits(rd_num), `S_DEC);
verify(ts++, rm_str, er_rm_num , $bits( er_rm_num ),  rm_num, $bits( rm_num), `S_DEC);
verify(ts++, opcode_str, er_opcode, $bits(er_opcode), opcode, $bits(opcode),`HEX);
// wait for 8 ns
#((`CYCLE*8)/10);

///////////////////////////////////////////////////////////////////////////////////////////////
// STUR X10, [X23, #64]

///// TEST CASE 3 /////
$display("\nTest Case %0d", tc++);
$display("STUR X10, [X23, #64]");

// set instruction to the binary equivalent of the instruction listed above
instruction = `INSTR_LEN'b11111000000001000000001011101010;

// wait for 2 ns
#(`CYCLE/5);
// DO NOT verify rm_num is correct because it is not relevant for a D Type instruction
// verify rn_num is correct
er_rn_num  = 'd23;
// verify rd_num is correct
er_rd_num  = 'd10;
// verify address is correct
er_address = 'd64;


// verify opcode is correct
er_opcode = 'h7c0;


// verify opcode is correct
verify(ts++, rn_str, er_rn_num, $bits(er_rn_num), rn_num , $bits(rn_num), `S_DEC);
verify(ts++, rd_str , er_rd_num, $bits(er_rd_num), rd_num, $bits(rd_num), `S_DEC);
verify(ts++, addy_str, er_address , $bits( er_address ),  address, $bits( address), `S_DEC);
verify(ts++, opcode_str, er_opcode, $bits(er_opcode), opcode, $bits(opcode),`HEX);
// wait for 8 ns
#((`CYCLE*8)/10);

///////////////////////////////////////////////////////////////////////////////////////////////

final_result();
$finish;
end
endmodule
