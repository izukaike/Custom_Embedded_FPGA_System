'''
Engineer: Izuka Ikedionwu

Description: Command line script that assembles legv8 instructions. you pass the input file and outputs a file that should be in the path of the verilog project

Created: 11/11/24

Updates: 
     - add more instructions 
'''
import sys

OP = 0
RD = 1
RN = 2
RM = 3 

'''
turns number to bit string
'''
def numtobits(val,s = 5):
     ret_val = ''
     vt = int(val)
     
     for i in range(s):
          if( 0b1 & int(vt) == 0b1):
               ret_val = '1' + ret_val
          else:
               ret_val = '0' + ret_val
          vt = vt >> 1
     return ret_val

'''
list of instructions, opcode, and type
***to be continued**
'''

instructions = {
    'ADD': ('10001011000', 'R'),
    'ADDI': ('1001000100', 'I'),
    'AND': ('10001010000', 'R'),
    'ANDI': ('1001001000', 'I'),
    'B': ('000101', 'B'),
    'BL': ('100101', 'B'),
    'BR': ('11010110000', 'R'),
    'CBNZ': ('10110101', 'CB'),
    'CBZ': ('10110100', 'CB'),
    'EOR': ('11001010000', 'R'),
    'EORI': ('1101001000', 'I'),
    'LDUR': ('11111000010', 'D'),
    'LSL': ('11010011011', 'R'),
    'LSR': ('11010011010', 'R'),
    'ORR': ('10101010000', 'R'),
    'ORRI': ('1011001000', 'I'),
    'STUR': ('11111000000', 'D'),
    'SUB': ('11001011000', 'R'),
    'SUBI': ('1101000100', 'I'),
    'SUBIS': ('1111000100', 'I'),
    'SUBS': ('11101011000', 'R'),
}

#check for proper arguments
if len(sys.argv) != 3:
    print("Invalid Arguements!")
    sys.exit(1)

in_file = sys.argv[1]
out_file = sys.argv[2]
finished_instruction = ''
shamt = '000000'
toks= []
finalized_instruction = ''

with open(in_file,'r') as infile, open(out_file,'w') as outfile:
    for line in infile:
        
        toks= line.split()
        
        opcode, instr_type = instructions[toks[OP]]
       
        #populates reg fields
        if(toks[OP] == 'B'):
             rd = toks[RD]
        else:
             rd = toks[RD][1:-1]

        if (len(toks) > 2):
          if (toks[OP] == 'STUR' or toks[OP] == 'LDUR'):
                    rn = toks[RN][2:-1]
                    if (len(toks) == 4):
                          rm = toks[RM][1:-1]
          elif (toks[OP] == 'CBZ' ):
                    rn = toks[RN]
          else:
                    rn = toks[RN][1:-1]
                    if (len(toks) == 4 ):
                         rm = toks[RM][1:]
    
        #assembles the  bits for machine code as as string
        match instr_type:
            case 'R':#                     11          5           6        5               
                 rmt = numtobits(rm)
                 rnt = numtobits(rn)
                 rdt = numtobits(rd)

                 finalized_instruction = opcode + rmt + "000000" + rnt + rdt

            case 'D':#                     11      
                 rmt = numtobits(rm,9)
                 rnt = numtobits(rn)
                 rdt = numtobits(rd)
                 
                 finalized_instruction = opcode + rmt  + "00" + rnt  + rdt

            case 'I':#                     11                ALU Imm
                 rmt = numtobits(rm,12)
                 rnt = numtobits(rn)
                 rdt = numtobits(rd)

                 finalized_instruction = opcode + rmt + rnt + rdt

            case 'CB':
                 rnt = numtobits(rn,19)
                 rdt = numtobits(rd)

                 #                        these are flipped
                 finalized_instruction = opcode + rnt + rdt

            case 'B':
                 rdt = numtobits(rd,26)
          
                 finalized_instruction = opcode + rdt
        
        #changes to hex no necessary but it follows prev conventions
        instr = hex(int(finalized_instruction,2))
        instr = str(instr[2:]).upper()
        
        #write to files
        outfile.write(instr)
        outfile.write('\n')
        

#close files
outfile.close() 
infile.close()