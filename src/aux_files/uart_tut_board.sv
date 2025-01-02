`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////


module uart_tut_board(
    input logic CLK100MHZ,
    output logic [15:0] LED,
    output logic LED16_R,
    input logic UART_TXD_IN,
    output logic UART_RXD_OUT,
    input  logic BTNC,
    output logic [31:0] instruction_memory [0:999],
    output logic trigger_upload
    );
    logic [7:0] rx_mod_data;
    logic rx_done;
    
    // Instruction memory indexing
    logic [13:0] i;  // Row index (0 to 9999)
    logic [2:0] j;   // Column index (0 to 7)
    
    // FIFO signals
    logic [7:0] rx_temp_data;
    logic f_read, empty;
    
    // Reset signal
    logic reset;
    assign reset = ~BTNC; // Active-high reset
    
    // rx/ getting instruction 
    //this isnt right but oh well
    fifo #(32_000) rx_fifo (
        .reset(reset),
        .write(rx_done),
        .read(f_read), // only read if not empty will this cause issues?
        .data_in(rx_mod_data),
        .data_out(rx_temp_data),
        .clk(CLK100MHZ),
        .full(full),
        .empty(empty)
    );
    uart_rx_tut rx_mod(
             .clk(CLK100MHZ),
             .reset(reset),
             .rx(UART_TXD_IN),
             .rx_data(rx_mod_data),
             .rx_done(rx_done)   
   );
   
   always @ (posedge(CLK100MHZ), posedge(reset)) begin
           if(reset) begin
                // does this clear all the instruction memory?
                 for (integer k = 0; k < 1_000; k = k + 1) begin
                        instruction_memory[k] <= 32'b0; // Clear all instructions
                 end
                 i <= 0;
                 j <= 0;
           end
           // 7 nibbles have been all ones signifying the the end of instruction
           else begin
             f_read <= !empty;
             if(rx_done == 1'b1 && f_read) begin          
                instruction_memory[i][j * 4 +: 4] <= rx_temp_data[3:0]; // Fill nibble (4 bits)
                j <= j + 1;

                if (j == 7) begin
                    j <= 0;
                    if (i < 1_000) begin
                        i <= i + 1; // Move to next instruction
                    end else
                        i <= 0;
                end
            end
            
            // Trigger upload when memory is full
            if (instruction_memory[i] == 32'hffffffff) begin
                trigger_upload <= 1;
            end else begin
                trigger_upload <= 0;
            end
        end   
     end 
               
endmodule
