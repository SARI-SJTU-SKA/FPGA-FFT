`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:43:51 12/07/2017
// Design Name:   fft_top
// Module Name:   E:/debug/verilog/201712/fft/fft_top_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fft_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fft_top_test;

	// Inputs
	reg clk;
	reg rst;
	reg rd_en;
	reg wr_en;

	// Outputs
	wire [35:0] dout;
	wire full;
	wire empty;
	wire [9:0] dcount;

	// Instantiate the Unit Under Test (UUT)
	fft_top uut (
		.clk(clk), 
		.rst(rst), 
		.rd_en(rd_en), 
		.wr_en(wr_en), 
		.dout(dout), 
		.full(full), 
		.empty(empty), 
		.dcount(dcount)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		rd_en = 0;
		wr_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		wr_en = 1;
		rd_en = 0;
		#100;
		rst = 0;
        
		// Add stimulus here
		forever #5 clk = ~clk;
	end
	
	always@(posedge clk) begin
		if(dcount == 511) begin
			wr_en <= 0;
			rd_en <= 1;
		end
		else if(dcount == 0) begin
			wr_en <= 1;
			rd_en <= 0;
		end
	end	
	
   
endmodule

