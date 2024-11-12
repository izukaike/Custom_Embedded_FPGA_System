# 64-Bit ARM Processor
64-Bit ARM Processor

As a computer engineering student I wanted to follow my curiosity and get more hardware experience and dive into the details of digital design. I am building a compiler, processor, and sensor interface in C++, Python, and SystemVerilog.As I dive deeper and get more interested in hardware design from my Computer Organization and Advanced Digital Logic classs at Baylor University I want to apply my knowledge and enjoy the process. I think that a 64-bit RISC design is important in many hardware engineering applications. Here is my journey!

# High-Level
<p align="center">
  <img align="middle" alt="Java" width="750px" height="160px"src="https://github.com/user-attachments/assets/ca5eb641-1744-4098-b253-c763b970b78f">
</p>

# Features
- 64-Bit ARM Processor
- Assembler
## To Do
  * Finalize Sensor Design
  * Finish Memory Block
  * Start Custom Compiler Based Off Of C++

<p align="center">
  <img src="https://github.com/user-attachments/assets/865e264c-a4e5-4c0f-a108-eae295db90f5" alt="Image Description" width="490" height="350">
</p>

# Adder
<img align="middle" alt="Java" width="490px" height="350px" src="https://github.com/user-attachments/assets/a2224ca3-151d-4e10-a6e9-98754c971059"/>
     
      module adder(
          input  [64-1:0] a_in,
          input  [64-1:0] b_in,
          output [64-1:0] add_out
          );
          
      assign add_out = a_in + b_in;
      endmodule



# Program Counter
<img align="middle" alt="Java" width="490px" height="350px" src="https://github.com/user-attachments/assets/e84dac18-cf48-40c5-bbc6-beba34a6e512"/>

   
    `include "definitions.vh"
    module register(
        input clk,
        input reset,
        input  [`WORD-1:0] D,
        output reg [`WORD-1:0] Q
        );
        always @(posedge(clk),posedge(reset))begin
            if (reset==1'b1)
                Q<=`WORD'b0;
            else
                Q <= D;
        end
    endmodule
# Instruction Memory
<img align="middle" alt="Java" width="490px" height="350px" src="https://github.com/user-attachments/assets/eb80d6c3-5f13-41a6-93d0-dd7cce7b9296"/>
   
   
   
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
   
# Full Fetch Stage 
<img align="middle" alt="Java" width="325px" height="400px" src="https://github.com/user-attachments/assets/933a462f-5f76-4ba2-8644-0317bf8eb2bd"/>
     
     module iFetch#(
         parameter SIZE=16)(
         input wire clk,
         input wire clk_delayed,
         input wire reset,
         input wire pc_src,
         input wire[`WORD-1:0] branch_target,
         output wire[`INSTR_LEN-1:0] instruction,
         input wire[`WORD-1:0] cur_pc,
         output wire[`WORD-1:0] incremented_pc
         );
        
        
        wire [`WORD-1:0] new_pc;
        //wire [`WORD-1:0] incremented_pc = `WORD'b0;
       
        instr_mem#(.SIZE(SIZE)) imem(
                 .clk(clk_delayed),
                 .pc(cur_pc),
                 .instruction(instruction)
         );
        mux#(.SIZE(`WORD)) m1(
                .a_in(incremented_pc),
                .b_in(branch_target),
                .control(pc_src), 
                .mux_out(new_pc)
         );
         register pc(
                   .clk(clk),
                   .reset(reset),
                   .D(new_pc),
                   .Q(cur_pc)
          );
          wire [`WORD-1:0] incr =  4;
          adder a1(
                 .a_in(cur_pc),
                 .b_in(incr),
                 .add_out(incremented_pc)
         );
      
                           
     endmodule


