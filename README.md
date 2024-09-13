# CompOrg_ARM_Processor_Project
64-Bit ARM Processor In a HDL

<img align="middle" alt="Java" width="490px" height="350px" " src="https://github.com/user-attachments/assets/865e264c-a4e5-4c0f-a108-eae295db90f5"/>

# Program Counter
<img align="middle" alt="Java" width="490px" height="350px" "src="https://github.com/user-attachments/assets/e84dac18-cf48-40c5-bbc6-beba34a6e512"/>

   
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



