`timescale 1ns / 1ps


module Computing_System(
    input CLK100MHZ,
    input CPU_RESETN,
    input logic UART_TXD_IN,
    output logic UART_RXD_OUT,
    //output logic LED16_R,
    
    
    output[15:0] LED,

    input  BTNR, BTNL,BTND,
    input  logic BTNC,BTNU,

    //RAM Interface
    inout[15:0] ddr2_dq,
    inout[1:0] ddr2_dqs_n,
    inout[1:0] ddr2_dqs_p,
    output[12:0] ddr2_addr,
    output[2:0] ddr2_ba,
    output ddr2_ras_n,
    output ddr2_cas_n,
    output ddr2_we_n,
    output ddr2_ck_p,
    output ddr2_ck_n,
    output ddr2_cke,
    output ddr2_cs_n,
    output[1:0] ddr2_dm,
    output ddr2_odt
    
    //data in
    //data out
    //read_addr
    ///write_addr
    //transaction complete
    //some indication of read or write to replac BTNC and  BTNU
);
/// pass //
logic [27:0] mem_addr = 0;
logic [63:0] mem_d_to_ram = 0;
logic [63:0] mem_d_from_ram;
logic        read;
logic        write;
logic [7:0]  temp;
logic        mem_transaction_complete;
mig_example_top memory(
        .CLK100MHZ(CLK100MHZ),
        .CPU_RESETN(CPU_RESETN),
        
        //.LED(LED),
        //read
        .BTNR(BTNR),
        .read(read),
        //write
        .BTNL(BTNL),
        .write(write),
        //addy
        .addy(mem_addr),
         //data in
        .data_to_ram(mem_d_to_ram),
         //data out
        .data_from_ram(mem_d_from_ram),
         //transaction complete
        .mem_transaction_complete(mem_transaction_complete),
        
         // RAM ports
        .ddr2_addr(ddr2_addr),
        .ddr2_ba(ddr2_ba),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_cke(ddr2_cke),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_n(ddr2_dqs_n),
        .ddr2_dqs_p(ddr2_dqs_p),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_odt(ddr2_odt)
);
//pass // 
logic [7:0] rx_temp_data;
logic       IM_upload_start;
logic       IM_upload_end;
//logic       read_from_mem = 0;

logic rx_done_tick;
uart_tut_board uart(
    .CLK100MHZ(CLK100MHZ),
    //.LED(LED),
    //.LED16_R(),
    .UART_TXD_IN(UART_TXD_IN),
    .UART_RXD_OUT(UART_RXD_OUT),
    .BTNC(BTNC),
    .rx_temp_data(rx_temp_data),
    .start_instr_read(IM_upload_start),
    .end_instr_read(IM_upload_end),
    .rx_done_tick(rx_done_tick)
);
    
    
//assign LED[0] = IM_upload_start;
//assign LED[1] = IM_upload_end;


//assign LED[15:8] = rx_temp_data;
//assign LED[4:1]  = mem_d_from_ram;

//State Machine
localparam [20:0] DEADZONE  = 1_001;
localparam [20:0] DM_INDEX  = 1_002;
localparam [20:0] IM_INDEX  =     0;
//Step 1: enumeration
typedef enum logic [3:0] {
    IDLE,
    LOAD_INSTR,
    MEM_READ
    //add states here
}state_t;
state_t [3:0]  cur_state;
state_t [3:0]  next_state;
logic   [20:0] mem_index;

//edge detection logic
logic rx_done_tick_d;  // Delayed version of rx_done_tick
logic rx_done_tick_edge; // Rising edge detection signal
logic upload_d, upload_edge;
logic  btnu_d,btnu_edge;

// Edge detection
always @(posedge CLK100MHZ or posedge BTNC) begin
    if (BTNC) begin
        rx_done_tick_d <= 1'b0;
        rx_done_tick_edge <= 1'b0;
        
        upload_d    <= 1'b0;
        upload_edge <= 1'b0;
        
        btnu_d <= 1'b0;
        btnu_edge <= 1'b0;
        
    end else begin
        rx_done_tick_d <= rx_done_tick;  // Register the delayed version
        rx_done_tick_edge <= rx_done_tick && ~rx_done_tick_d;  // Rising edge detection
        
        upload_d    <= IM_upload_start;
        upload_edge <= IM_upload_start && ~upload_d;
        
        btnu_d      <= BTNU;
        btnu_edge   <= BTNU && ~btnu_d;
    end
end

logic [15:0] count = 0;
logic [2:0]   index = 0; // Tracks nibble position within 32 bits (0 to 7)
logic [31:0] temp_word; // Temporary storage for 32-bit word assembly

// Sequential Logic
always @(posedge CLK100MHZ or posedge BTNC) begin
    if (BTNC) begin
        cur_state <= IDLE;
        mem_addr <= 28'd0;
        mem_d_to_ram <= 0;
        temp_word <= 32'd0;
        write <= 0;
        read <= 0;
        index <= 0;
    end else begin
        cur_state <= next_state;

        // Handle receiving data and assembling 32-bit word
        if (rx_done_tick_edge) begin
            // Shift in the new nibble
            temp_word <= {rx_temp_data[3:0], temp_word[31:4]};
            index <= index + 1;

            if (index == 7) begin
                // Full 32-bit word assembled
                mem_d_to_ram <= temp_word;
                mem_addr <= mem_addr + 2; // Increment memory address for next word
                write <= 1; // Trigger memory write
                index <= 0; // Reset nibble index
            end else begin
                write <= 0; // Wait for more nibbles
            end
        end else begin
            write <= 0; // Default state for write signal
        end
        
        if(btnu_edge) begin
            read <= 1;
            mem_addr <= 28'd6;
        end else read <= 0;
        
        if(BTND) begin
            read <= 1;
            mem_addr <= 28'd4;
        end else read <=  0;
        
    end 
end

//Step 3: Combo Logic/Case Statement
logic i = 0,j = 0, k =0;
always_comb begin
    //on start up
    case (cur_state)
        //default state : waiting for operation
        IDLE:         
                     begin
                        i = 1;
                        j = 0;
                        k = 0;
                        
                        if     (IM_upload_start)    begin
                            next_state  = LOAD_INSTR;
                        end 
                        else begin
                              next_state <= IDLE;
                              
                         end
                        
                       
                      end
        //load instructions from UART to memory 
        LOAD_INSTR: 
                     begin
                        i = 0;
                        j = 1;
                        k = 0;
                        //read  = 0;
                         
                        //this may need to be edge triggered
                        if(IM_upload_end == 1'b1) begin
                            next_state = IDLE;
                         end
                         else begin
                         //increment instruction memory
                         if(rx_done_tick_edge) begin
                           //this may need to be edge triggered
                                next_state = LOAD_INSTR;
                          end
                          end   
                     end  
    endcase
end

//assign LED[6] = rx_done_tick;

assign LED[15:0] = mem_d_from_ram[15:0]; // Show read data (lower nibble)
//assign LED[11:8]  = mem_d_to_ram[3:0];   // Show written data (lower nibble)
//assign LED[4:0]   = mem_addr[7:0];        // Show current memory address
//assign LED[7]     =  i; // idle 
//assign LED[6]     =  j; // load
//assign LED[5]     =  k; // read

assign LED16_R    = write; // then to write
assign LED17_R    = read;   // tthen to read

//assign LED[7:0]   = rx_temp_data;
//assign LED[0] = mem_transaction_complete; // Show transaction complete
//assign LED[15:8] = temp;
//assign LED[15:8]  = temp;
//assign LED[7:0]   = temp2;
//assign LED[15]  = rx_done_tick_edge;
//assign LED[7:0]   = count;
//assign LED[15] = write;
//assign LED[14] = read;
//assign LED[5]  = IM_upload_start; // idle
//assign LED[4]  = w; // load

endmodule
