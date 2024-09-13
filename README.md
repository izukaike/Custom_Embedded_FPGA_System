# CompOrg_ARM_Processor_Project
64-Bit ARM Processor In a HDL

<img align="middle" alt="Java" width="490px" height="350px" src="https://github.com/user-attachments/assets/865e264c-a4e5-4c0f-a108-eae295db90f5"/>

#Adder
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
   



