`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:18:51 12/07/2017
// Design Name:   BRAM_512
// Module Name:   E:/debug/verilog/201712/fft/bram_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BRAM_512
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bram_test;

	// Inputs
	reg clka;
	reg ena;
	reg [12:0] addra;

	// Outputs
	wire [39:0] douta;

	// Instantiate the Unit Under Test (UUT)
	BRAM_DATA_IN uut (
		.clka(clka), 
		.ena(ena), 
		.addra(addra), 
		.douta(douta)
	);

	initial begin
		// Initialize Inputs
		clka = 0;
		ena = 1;
		addra = 0;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		
		forever #5 clka = ~clka;
	end
	
	initial begin
		#125;
		ena = 1;
	end
	
	always@(posedge clka or negedge ena) begin
		if(ena == 0)
			addra = 0;
		else
			addra = addra+ 1;
	end
      
endmodule

