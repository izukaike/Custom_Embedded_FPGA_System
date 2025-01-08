`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////


module uart_tut_board(
    input logic CLK100MHZ,
    output logic [15:0] LED,
    output logic LED16_R,
    input logic  UART_TXD_IN,
    output logic UART_RXD_OUT,
    input  logic BTNC,
    output logic [7:0] rx_temp_data,
    output logic  start_instr_read,
    output logic end_instr_read,
    output logic rx_done_tick
    //output logic trigger_upload
);
    //logic [7:0] rx_temp_data;
    logic [7:0] rx_mod_data;
    //logic [7:0] rx_temp_data;
    // Instruction memory indexing
    logic [13:0] i;  // Row index (0 to 9999)
    logic [2:0] j;   // Column index (0 to 7)
    
    // FIFO signals
    
    logic full = 0;
    logic empty = 0;
    
    // Reset signal
    logic  reset;
    assign reset = BTNC; // Active-Low Reset
    
    logic d1 = 0;
    logic d0 = 0;
    //assign LED[0] = d0;
    //assign LED[1] = d1;
    //logic start_instr_read;
    //logic  end_instr_read;
    always_ff@(posedge(CLK100MHZ)) begin
        if(rx_temp_data == 8'hAA) begin
            start_instr_read <= 1;
            d0 <= 1;
        end else start_instr_read <= 0; d0 = 0;
        
        if(rx_temp_data == 8'hBB) begin // this stays at 0xBB after file
            end_instr_read <= 1;
            d1 <= 1;
        end else end_instr_read <= 0; d1 = 0;
     end 
    
    // rx/ getting instruction 
    //this isnt right but oh well
    //logic rx_done_tick = 0;
    fifo #(4096) rx_fifo (
        .reset(reset),
        .write(rx_done_tick),
        .read(rx_done_tick), // only read if not empty will this cause issues?
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
             .rx_done(rx_done_tick)   
   );   
   
   assign LED[7:0] = rx_temp_data[7:0];
   assign LED[15]  = start_instr_read;
   assign LED[14]  = end_instr_read;
endmodule
