`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:19 12/13/2017 
// Design Name: 
// Module Name:    fifo_4096_2 
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
module fifo_4096_2(
	clk,
	rst,
	data_in,
	data_in_valid,
	data_out,
	data_out_valid,
	data_count
    );
	
	//inputs
	input clk;
	input rst;
	input data_in;
	input data_in_valid;
	//outputs
	output data_out;
	output data_out_valid;
	output data_count;
	
	//parameters
	parameter float_len = 20;//浮点数的位数
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 13;//当前radix所处级数，从左向右1,2,3,4,...
	parameter tf_num = 4096;//旋转因子twiddle factor的个数
	parameter bram_tf_addr_len = 12;//2 ^ bram_tf_addr_len = tf_num
	
	wire clk;
	wire rst;
	wire [(float_len*2-1):0] data_in;
	wire data_in_valid;
	wire [(float_len*2-1):0] data_out;
	wire [(bram_tf_addr_len-1):0] data_count;//4096
	
	reg data_out_valid;
	always@(posedge clk or posedge rst)begin
		if(rst == 1)
			data_out_valid <= 0;
		else if(clk == 1)
			data_out_valid <= rd_en;
	end
	
	//y1直接输出，y2先写入fifo，然后读出与旋转因子tf相乘再输出
	//fifo	
	reg rd_en;
	wire full;
	wire empty;

	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			rd_en <= 0;
		else if(full == 1 && empty == 0) begin
			rd_en <= 1;
		end
		else if(empty == 1) begin
			rd_en <= 0;
		end
	end
	
	FIFO_4096 fifo_4096_y2(
	.clk(clk),
	.rst(rst),
	.din(y2),
	.wr_en(data_in_valid),//wr_en变高以后会延迟三个周期，第四个周期的数据才被写入fifo
	.rd_en(rd_en),//当rd_en为高时，fifo输出dout有效
	.full(full),
	.empty(empty),
	.dout(data_out)
	);

endmodule
