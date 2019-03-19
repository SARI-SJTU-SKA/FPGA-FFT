`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:02:39 12/08/2017
// Design Name:   Float32_To_Float18
// Module Name:   E:/debug/verilog/201712/fft/Float32_To_Float18.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Float32_To_Float18
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Float32_To_Float18_test;

	// Inputs
	reg clk;
	reg [31:0] xn_re;
	reg [31:0] xn_im;

	// Outputs
	wire rdy;
	wire [35:0] result;

	parameter dataNum = 8192;//输入数据的个数
	
	reg [31:0] data_im[(dataNum-1):0];
	reg [31:0] data_re[(dataNum-1):0];

	// Instantiate the Unit Under Test (UUT)
	floatToFloat uut_re (
		.clk(clk), 
		.rdy(rdy), 
		.re(xn_re),
		.im(xn_im),
		.result(result)
	);

	integer i;
	integer j;
	integer fp_w;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		i = 0;
		j = 0;
		xn_re = 32'b11000111011100001000001011010111;
		xn_im = 32'b11000111011100001000001011010111;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		forever #5 clk = ~clk;
	end
	/*
	initial begin
		// Initialize Inputs
		clk = 0;
		i = 0;
		j = 0;
		xn_re = data_re[0];
		xn_im = data_im[0];
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		forever #5 clk = ~clk;
	end

	initial $readmemb("im_binary_8192.txt",data_im);
	initial $readmemb("re_binary_8192.txt",data_re);

	always @(posedge clk) begin
		if(i < dataNum) begin
			xn_re <= data_re[i];
			xn_im <= data_im[i];
			i <= i + 1;
		end
		else i <= 0;
	end
	
	initial begin 
		fp_w <= $fopen("din_18bit_8192.txt","a");
	end
	
	always@(posedge clk) begin
		if((j < dataNum)&& rdy == 1)begin
				$fwrite(fp_w,"%b\n",result);
				j = j + 1;
		end
		else if(j == dataNum)begin 
			$fclose(fp_w);  
			$stop;
		end
		else  ;
	end
	*/
endmodule

