`timescale 1ns / 1ps

module fifo #(parameter SIZE = 1024)(
    input logic reset,
    input logic write,
    input logic read,
    input logic  [7:0] data_in,
    output logic [7:0] data_out,
    input logic clk,
    output logic full,
    output logic empty

);


logic [$clog2(SIZE)-1:0] rd_ptr;
logic [$clog2(SIZE)-1:0] wr_ptr;

assign empty = (wr_ptr == rd_ptr);
assign full = ((wr_ptr + 1) % SIZE == rd_ptr);

logic [7:0] buff [SIZE-1:0];


// write logic
always_ff @ ( posedge(clk) or posedge(reset)) 
begin
    if (reset) 
        begin
            wr_ptr <= 0;
        end 
    else if (write && !full) 
        begin
            buff[wr_ptr] <= data_in;
            wr_ptr <= (wr_ptr + 1) % SIZE;
        end  
end 

// read logic
always_ff @(posedge(clk) or posedge(reset)) 
begin
       if (reset) 
            begin
                rd_ptr <= 0;
            end 
        else if (read && !empty) 
            begin
                data_out <= buff[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % SIZE;
            end
end
endmodule
