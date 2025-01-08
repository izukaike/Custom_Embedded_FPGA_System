`timescale 1ns / 1ps
`define CYCLE 4
`define WORD  64
`define INSTR_LEN 32
`define HEX 0
`define S_DEC 1
`define US_DEC 2
`define BINARY 3  
//`define DMEMFILE  "H:/ELC3338/Spring2018/potter/ARM-Lab/testfiles/ramData.data"
`define DMEMFILE    "C:/Users/izuka/Box/ELC3338/ARM-Lab/testfiles/ramData.data"
//`define IMEMFILE  "C:/Users/izuka_ikedionwu1/Box/ELC3338/ARM-Lab/testfiles/instrData.data"
`define IMEMFILE    "C:/Users/izuka/Box/ELC3338/ARM-Lab/testfiles/instrData.data"
//`define RMEMFILE  "C:/Users/izuka_ikedionwu1/Box/ELC3338/ARM-Lab/testfiles/regData.data"
`define RMEMFILE    "C:/Users/izuka/Box/ELC3338/ARM-Lab/testfiles/regData.data"

`define  ADD  11'b10001011000
`define  SUB  11'b11001011000
`define  AND  11'b10001010000
`define  ORR  11'b10101010000
`define  LDUR 11'b11111000010
`define  STUR 11'b11111000000
`define  CBZ  11'b1011010XXXX // op code is 5A0-5A7
`define  B    11'b000101XXXXX// opcode is 4A0-4B7

`define  ALU_AND  4'b0000
`define  ALU_ORR  4'b0001
`define  ALU_ADD  4'b0010
`define  ALU_SUB  4'b0110
`define  ALU_PASS 4'b0111
`define  ALU_NOR  4'b1100

`define ALUOp_RTYPE  2'b10
`define ALUOp_DTYPE  2'b00
`define ALUOp_B      2'b00
`define ALUOp_CBZ    2'b01
