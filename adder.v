`timescale 1ns / 1ps


module adder(
    input  [64-1:0] a_in,
    input  [64-1:0] b_in,
    output [64-1:0] add_out
    );
    
assign add_out = a_in + b_in;
endmodule


