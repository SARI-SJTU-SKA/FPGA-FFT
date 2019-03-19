`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:08 12/13/2017 
// Design Name: 
// Module Name:    multiPlural 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

//复数乘法
module multiPlural(
	clk,
	rst,
	data_in1,
	data_in2,
	data_in_valid,
	data_out,
	data_out_valid
    );
	//inputs
	input clk;
	input rst;
	input data_in1;
	input data_in2;
	input data_in_valid;
	
	//outputs
	output data_out;
	output data_out_valid;
	
	//parameters
	parameter float_len = 32;//浮点数的位数

	wire clk;
	wire rst;
	wire data_in_valid;
	wire data_out_valid;
	wire [(float_len*2-1):0] data_in1;
	wire [(float_len*2-1):0] data_in2;
	wire [(float_len*2-1):0] data_out;
	 
	//旋转因子相乘部分
	//y1*tf = yout
	wire [(float_len-1):0] re1;
	wire [(float_len-1):0] re2;
	wire [(float_len-1):0] im1;
	wire [(float_len-1):0] im2;
	//y1_re*tf_re
	wire rdy1;
	MUL mul1(
	.clk(clk),
	.a(data_in1[(float_len*2-1):float_len]),
	.b(data_in2[(float_len*2-1):float_len]),
	.operation_nd(data_in_valid),
	.result(re1),
	.rdy(rdy1)
	);
	//y1_im*tf_im
	wire rdy2;
	MUL mul2(
	.clk(clk),
	.a(data_in1[(float_len-1):0]),
	.b(data_in2[(float_len-1):0]),
	.operation_nd(data_in_valid),
	.result(re2),
	.rdy(rdy2)
	);
	//y1_re*tf_im
	wire rdy3;
	MUL mul3(
	.clk(clk),
	.a(data_in1[(float_len*2-1):float_len]),
	.b(data_in2[(float_len*2-1):0]),
	.operation_nd(data_in_valid),
	.result(im1),
	.rdy(rdy3)
	);
	//y1_im*tf_re
	wire rdy4;
	MUL mul4(
	.clk(clk),
	.a(data_in1[(float_len-1):0]),
	.b(data_in2[(float_len*2-1):float_len]),
	.operation_nd(data_in_valid),
	.result(im2),
	.rdy(rdy4)
	);
	wire rdy_multiplication;
	assign rdy_multiplication = rdy1 & rdy2 & rdy3 & rdy4;
	//re1-re2 = data_out[(float_len*2-1):float_len]
	wire rdy5;
	//wire [(float_len*2-1):0] y2_out;
	SUB sub1(
	.clk(clk),
	.a(re1),
	.b(re2),
	.operation_nd(rdy_multiplication),
	.result(data_out[(float_len*2-1):float_len]),
	.rdy(rdy5)
	);
	//im1+im2 = data_out[(float_len-1):0]
	wire rdy6;
	ADDER add1(
	.clk(clk),
	.a(im1),
	.b(im2),
	.operation_nd(rdy_multiplication),
	.result(data_out[(float_len-1):0]),
	.rdy(rdy6)
	);
	assign data_out_valid = rdy5 & rdy6;

endmodule
