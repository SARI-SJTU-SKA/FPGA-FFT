`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:35:55 12/11/2017
// Design Name:   MUL
// Module Name:   E:/debug/verilog/201712/fft/mul_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MUL
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mul_test;

	// Inputs
	reg operation_nd;
	reg clk;
	reg [19:0] a;
	reg [19:0] b;

	// Outputs
	wire operation_rfd;
	wire rdy;
	wire [19:0] result;

	// Instantiate the Unit Under Test (UUT)
	MUL uut (
		.operation_nd(operation_nd), 
		.clk(clk), 
		.operation_rfd(operation_rfd), 
		.rdy(rdy), 
		.a(a), 
		.b(b), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		operation_nd = 0;
		clk = 0;
		a = 20'b0111_1000_0000_0000_0000;
		b = 20'b0111_1000_0000_0000_0000;	
		// Wait 100 ns for global reset to finish
		#100;
      operation_nd = 1; 
		#100;
		// Add stimulus here
		forever #10 clk = ~clk;
	end
	
	always@(posedge clk)begin
		a = a + 20'b0000_0001_0000_0000_0000;
		b = b + 20'b0000_0001_0000_0000_0000;
		//b = b + 20'b0000_1000_0000_0000_0000;
	end
	//¼ÆÊýÆ÷
	reg [4:0] counter;
	initial begin
		counter = 0;
	end
	always@(posedge clk) begin
		if(operation_nd == 0)
			counter = 0;
		else
			counter = counter + 1;
	end
      
endmodule

