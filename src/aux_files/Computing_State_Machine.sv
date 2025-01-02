`timescale 1ns / 1ps

module Computing_State_Machine(
    // clock
    input logic CLK100MHZ,
    // led outputs 
    output logic [15:0] LED,
    // led to read and write from memory // different colors?
    output logic LED16_R,
    // data in
    input logic UART_TXD_IN,
    //data out -> interface is not made yet
    output logic UART_RXD_OUT,
    //reset button
    input  logic BTNC
);
    
    logic clk;
    logic rst_n;
    
    logic trigger_led;       // Trigger for LED to DataMem
    logic trigger_accel;     // Trigger for Accelerometer to DataMem
    logic trigger_temp;      // Trigger for Temp Sensor to DataMem
    logic trigger_alu;       // Trigger for ALU to Mem
    logic trigger_upload;    // Trigger for Upload Instr. Mem
    logic trigger_data;      // Trigger for Data Memory to RegFile
    
    logic led_to_datamem;
    logic accel_to_datamem;
    logic temp_to_datamem;
    logic alu_to_mem;
    logic upload_instr_mem;
    logic data_to_regfile;
    
    // 10_000 * 32 = 32kb for Instruction Memory
    localparam [20:0] dm_index = 1000; 
    localparam [15:0] im_index = 0;  //10_000 ,  0
    logic [31:0] instr_memory [dm_index-1:im_index];
    
    uart_board dut (
        //clk
        .CLK100MHZ(CLK100MHZ),
        //reset 
        .BTNC(BTNC),
        // led array 
        .LED(LED),
        //this needs to be deleted
        .LED16_R(LED16_R),
        //input to instruction memory
        .UART_TXD_IN(UART_TXD_IN),
        // output from process
        .UART_RXD_OUT(UART_RXD_OUT),
        // output -> trigger_IM
        .trigger_upload(trigger_upload),
        //output data memory
        .instruction_memory(instr_memory)
    );
    
    

    // Define states using enum
    typedef enum logic [2:0] {
        IDLE,
        LED_TO_DATAMEM,
        ACCEL_TO_DATAMEM,
        TEMP_TO_DATAMEM,
        ALU_TO_MEM,
        UPLOAD_INSTR_MEM,
        DATA_TO_REGFILE
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transitions
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE; // Reset to IDLE state
        else
            current_state <= next_state;
    end

    // Combinational logic for next state and outputs
    always_comb begin
        // Default values
        next_state = current_state;
        led_to_datamem = 0;
        accel_to_datamem = 0;
        temp_to_datamem = 0;
        alu_to_mem = 0;
        upload_instr_mem = 0;
        data_to_regfile = 0;

        // for each state set read and write addresses and values
        case (current_state)
            IDLE: begin
                if (trigger_led)
                    next_state = LED_TO_DATAMEM;
                else if (trigger_accel)
                    next_state = ACCEL_TO_DATAMEM;
                else if (trigger_temp)
                    next_state = TEMP_TO_DATAMEM;
                else if (trigger_alu)
                    next_state = ALU_TO_MEM;
                else if (trigger_upload)
                    next_state = UPLOAD_INSTR_MEM;
                else if (trigger_data)
                    next_state = DATA_TO_REGFILE;
                else
                    next_state = IDLE;
            end

            LED_TO_DATAMEM: begin
                led_to_datamem = 1;  // Assert output
                next_state = IDLE;   // Return to IDLE
            end

            ACCEL_TO_DATAMEM: begin
                accel_to_datamem = 1; // Assert output
                next_state = IDLE;    // Return to IDLE
            end

            TEMP_TO_DATAMEM: begin
                temp_to_datamem = 1; // Assert output
                next_state = IDLE;   // Return to IDLE
            end

            ALU_TO_MEM: begin
                alu_to_mem = 1; // Assert output
                next_state = IDLE; // Return to IDLE
            end

            UPLOAD_INSTR_MEM: begin
                upload_instr_mem = 1; // Assert output
                
                next_state = IDLE;    // Return to IDLE
            end

            DATA_TO_REGFILE: begin
                data_to_regfile = 1; // Assert output
                next_state = IDLE;   // Return to IDLE
            end

            default: next_state = IDLE; // Safety fallback
        endcase
    end

endmodule


