`include "definitions.vh"

module mux#(
    parameter SIZE=8)(
    input [SIZE-1:0] a_in,
    input [SIZE-1:0] b_in,
    input control,
    output reg [SIZE-1:0] mux_out,
    output reg [`WORD-1:0] val
    );
	// TODO: Add body of mux here
	always@(control, a_in, b_in) begin
	   if(control == 1'd1) begin
	       mux_out <= b_in;
	       val     <= b_in;
	   end
	   else begin
	       mux_out <= a_in;
	       val     <= a_in;
	   end
	 end
endmodule
