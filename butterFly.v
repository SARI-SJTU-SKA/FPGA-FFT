`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:57:00 12/13/2017 
// Design Name: 
// Module Name:    butterFly 
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
module butterFly(
	clk,
	rst,
	data_in1,
	data_in2,
	data_in_valid,
	data_out1,
	data_out2,
	data_out_valid
    );

	//inputs
	input clk;
	input rst;
	input data_in1;
	input data_in2;
	input data_in_valid;
	
	//outputs
	output data_out1;
	output data_out2;
	output data_out_valid;
	
	//parameters
	parameter float_len = 32;//浮点数的位数
	//parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	//parameter stageNum = 13;//当前radix所处级数，从左向右1,2,3,4,...
	//parameter tf_num = 4096;//旋转因子twiddle factor的个数
	//parameter bram_tf_addr_len = 12;//2 ^ bram_tf_addr_len = tf_num

	wire clk;
	wire rst;
	wire data_in_valid;
	wire data_out_valid;
	wire [(float_len*2-1):0] data_in1;
	wire [(float_len*2-1):0] data_in2;
	wire [(float_len*2-1):0] data_out1;
	wire [(float_len*2-1):0] data_out2;

	//y1 = x1 + x2
	/*注意这里的使能信号：operation_nd*/
	wire rdy1;
	ADDER add_re_13(//re1 + re2
	.clk(clk),
	.a(data_in1[(float_len*2-1):float_len]),
	.b(data_in2[(float_len*2-1):float_len]),
	.operation_nd(data_in_valid),//Must be set High to indicate that operand A, operand B and OPERATION, the latter when required as described above, are valid.
	.result(data_out1[(float_len*2-1):float_len]),
	.rdy(rdy1)//Set High by core when RESULT is valid
	);
	wire rdy2;
	ADDER add_im_13(//im1 + im2
	.clk(clk),
	.a(data_in1[(float_len-1):0]),
	.b(data_in2[(float_len-1):0]),
	.operation_nd(data_in_valid),
	.result(data_out1[(float_len-1):0]),
	.rdy(rdy2)
	);
	//y2 = x1 - x2
	wire rdy3;
	SUB sub_re_13(//re1 - re2
	.clk(clk),
	.a(data_in1[(float_len*2-1):float_len]),
	.b(data_in2[(float_len*2-1):float_len]),
	.operation_nd(data_in_valid),
	.result(data_out2[(float_len*2-1):float_len]),
	.rdy(rdy3)
	);
	wire rdy4;
	SUB sub_im_13(//im1 - im2
	.clk(clk),
	.a(data_in1[(float_len-1):0]),
	.b(data_in2[(float_len-1):0]),
	.operation_nd(data_in_valid),
	.result(data_out2[(float_len-1):0]),
	.rdy(rdy4)
	);
	assign data_out_valid = rdy1 & rdy2 & rdy3 & rdy4;

endmodule
