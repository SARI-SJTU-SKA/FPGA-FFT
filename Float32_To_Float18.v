`timescale 1ns / 1ps

module Float32_To_Float18(
	clk,
	re,
	im,
	rdy,
	result
	);
	input clk;
	input [17:0] re;
	input [17:0] im;
	output rdy;
	output wire [35:0] result;
	
	wire rdy1;
	Float32_To_Float18 uut_re(
	.clk(clk),
	.a(re),
	.rdy(rdy1),
	.result(result[35:18])
	);
	wire rdy2;
	Float32_To_Float18 uut_im(
	.clk(clk),
	.a(re),
	.rdy(rdy2),
	.result(result[17:0])
	);
	
	assign rdy = rdy1 & rdy2;
	
endmodule

