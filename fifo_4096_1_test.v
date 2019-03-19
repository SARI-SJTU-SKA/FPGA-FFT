`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:38:07 12/13/2017
// Design Name:   fifo_4096_1
// Module Name:   E:/debug/verilog/201712/fft/fifo_4096_1_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fifo_4096_1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_4096_1_test;

	// Inputs
	reg rst;
	reg clk;
	reg [39:0] data_in;
	reg data_in_valid;

	// Outputs
	wire [39:0] data_out1;
	wire [39:0] data_out2;
	wire data_out_valid;

	// Instantiate the Unit Under Test (UUT)
	fifo_4096_1 uut (
		.rst(rst), 
		.clk(clk), 
		.data_in(data_in),
		.data_in_valid(data_in_valid),		
		.data_out1(data_out1), 
		.data_out2(data_out2), 
		.data_out_valid(data_out_valid)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		data_in = 0;
		data_in_valid = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
		rst = 0;
		#100;
      data_in_valid = 1;  
		// Add stimulus here
		forever #5 clk = ~clk;
	end
	
	always@(posedge clk or posedge rst)begin
		if(rst == 1)
			data_in = 0;
		else if(clk == 1)begin 
			if(data_in == 8192)
				data_in = 1;
			else
				data_in <= data_in + 1;
		end
	end
      
endmodule

