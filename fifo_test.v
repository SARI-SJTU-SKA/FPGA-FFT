`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:01:15 12/07/2017
// Design Name:   FIFO_512
// Module Name:   E:/debug/verilog/201712/fft/fifo_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIFO_512
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_test;

	// Inputs
	reg clk;
	reg rst;
	reg [39:0] din;
	reg wr_en;
	reg rd_en;

	// Outputs
	wire [39:0] dout;
	wire full;
	wire empty;
	//wire [8:0] data_count;

	// Instantiate the Unit Under Test (UUT)
	FIFO_512 uut (
		.clk(clk), 
		.rst(rst), 
		.din(din), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.dout(dout), 
		.full(full), 
		.empty(empty)
		//.data_count(data_count)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		din = 1;
		wr_en = 0;
		rd_en = 0;

		// Wait 100 ns for global reset to finish
		#50;
      rst = 1;
		#50;
		rst = 0;
		#50;
		wr_en = 1;
		#50;
		// Add stimulus here
		forever #5 clk = ~clk;
	end
	
	always@(posedge full or posedge empty) begin
		if(full != 1) begin
			wr_en <= 1;
			rd_en <= 0;
		end
		else if(empty != 1)begin
			wr_en <= 0;
			rd_en <= 1;
		end
	end
	
	always@(posedge clk or posedge full) begin
		if(rd_en == 1)
			din = 1;
		else if(wr_en == 1)
			din = din + 1;
	end
      
endmodule

