`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:01:24 12/09/2017
// Design Name:   fft_8192_top
// Module Name:   E:/debug/verilog/201712/fft/fft_8192_top_test.v
// Project Name:  fft
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fft_8192_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fft_8192_top_test;

	// Inputs
	reg clk;
	reg rst;
	reg en;

	// Outputs
	wire dout_valid;
	wire [63:0] dout;
	wire dout_finish;

	//temps
	parameter dataNum = 8192;//输入数据的个数
	integer j;
	integer fp_w;

	// Instantiate the Unit Under Test (UUT)
	fft_8192_top uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.dout_valid(dout_valid), 
		.dout(dout), 
		.dout_finish(dout_finish)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		en = 0;
		j = 0;
		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#100;
		en = 1;
      #100;
		rst = 0;
		#100;
		// Add stimulus here
		forever #5 clk = ~clk;
	end
		
	initial begin 
		fp_w <= $fopen("radix1_float32_8192.txt","a");
	end
	parameter p = 0;
	always@(posedge clk or posedge rst) begin
	//always@(posedge clk or negedge clk or posedge rst) begin
		if(rst == 1)
			j = 0;
		else if((j < p*dataNum)&& dout_valid == 1)begin
			j = j + 1;
		end
		else if((j < (p+1)*dataNum)&& dout_valid == 1)begin
			$fwrite(fp_w,"%b\n",dout);
			j = j + 1;
		end
		else if(j == (p+1)*dataNum)begin 
			$fclose(fp_w);  
 			$stop;
		end
		else ;
	end

/*
	always@(posedge clk) begin
		if((j < dataNum)&& dout_valid == 1)begin
			$fwrite(fp_w,"%b\n",dout);
			j = j + 1;
		end
		else if(j == dataNum)begin 
			$fclose(fp_w);  
			$stop;
		end
		else ;
	end
*/

      
endmodule

