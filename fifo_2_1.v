`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:43:12 12/12/2017 
// Design Name: 
// Module Name:    fifo_4096_1 
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
module fifo_2_1(
	rst,
	clk,
	data_in,
	data_in_valid,
	data_out1,//x1
	data_out2,//x2
	data_out_valid
    );
	//inputs
	input rst;
	input clk;
	input data_in;
	input data_in_valid;

	//outputs
	output data_out1;
	output data_out2;
	output data_out_valid;
	
	//parameters
	parameter float_len = 32;//浮点数的位数
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 2;//当前radix所处级数，从左向右1,2,3,4,...
	parameter tf_num = 2;//旋转因子twiddle factor的个数
	parameter bram_tf_addr_len = 1;//2 ^ bram_tf_addr_len = tf_num
	
	wire rst;
	wire clk;
	wire data_in_valid;
	reg rd_en;
	reg wr_en;
	wire full;
	wire empty;
	wire [(float_len*2-1):0] data_in;
	wire [(float_len*2-1):0] data_out1;
	wire [(float_len*2-1):0] data_out2;
	reg data_out_valid;
	
	//fifo启动后只能第三个（包含三个）周期以后的数据才能被写入
	reg [(float_len*2-1):0] data_in1;//39
	//reg [(float_len*2-1):0] data_in2;//39
	always@(posedge rst or posedge clk) begin
		if(rst == 1)begin
			data_in1 <= 0;
			//data_in2 <= 0;
		end
		else if(clk == 1)begin
			data_in1 <= data_in;
			//data_in2 <= data_in1;
		end
	end
	
	always@(posedge rst or posedge full or posedge empty or posedge data_in_valid)begin
		if(rst == 1)
			wr_en <= data_in_valid;
		else if(empty == 1)
			wr_en <= data_in_valid;
		else if(full == 1)
			wr_en <= 0;
	end

	always@(posedge rst or posedge full or posedge empty)begin
		if(rst == 1)
			rd_en <= 0;
		else if(empty == 1)
			rd_en <= 0;
		else if(full == 1)
			rd_en <= 1;
	end

	//wire almost_full;
	//wire almost_empty;
	//wire [12:0] data_count;
	FIFO_2 fifo_2_x1(
	.clk(clk),
	.rst(rst),
	//.din(data_in2),
	.din(data_in),
	.wr_en(wr_en),
	.rd_en(rd_en),//当rd_en为高时，fifo输出dout有效
	.full(full),
	.empty(empty),	
	//.almost_full(almost_full),
	//.almost_empty(almost_empty),
	//.data_count(data_count),
	.dout(data_out1)//dout分别充当x1
	);
	//fifo输出使能信号dout_fifo_valid
	always@(posedge rst or posedge clk)begin
		if(rst == 1)begin
			data_out_valid <= 0;
		end
		else if(clk == 1)begin
			data_out_valid <= rd_en;
		end
	end
	/*wire [(float_len*2-1):0] x2;
	assign x2 = data_in1;*/

	/*reg [(float_len*2-1):0] x2;
	//assign x2 = data_in1;
	//由于fifo的full == 1后一个周期，wr_en = 0, rd_en = 1，再下一个周期fifo开始输出，所以将输入data_in延迟一个周期，插入一个寄存器data_in1
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			x2 <= 0;
		else
			x2 <= data_in2;
	end*/
	//assign data_out2 = x2;
	assign data_out2 = data_in1;

endmodule
