`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:07 12/16/2017 
// Design Name: 
// Module Name:    FIFO_1 
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
module FIFO_2(
	clk,
	rst,
	din,
	wr_en,
	rd_en,//当rd_en为高时，fifo输出dout有效
	full,
	empty,	
	dout//dout分别充当x1
	);
	//inputs
	input clk;
	input rst;
	input din;
	input wr_en;
	input rd_en;
	
	//outputs
	output full;
	output empty;
	output dout;

	//parameters
	parameter float_len = 32;//浮点数的位数
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 2;//当前radix所处级数，从左向右1,2,3,4,...
	parameter tf_num = 2;//旋转因子twiddle factor的个数
	parameter bram_tf_addr_len = 1;//2 ^ bram_tf_addr_len = tf_num
	
	wire clk;
	wire rst;
	wire wr_en;
	wire rd_en;
	wire full;
	wire empty;
	wire [(float_len*2-1):0] din;
	reg [(float_len*2-1):0] dout;
	
	//用于存储数据的reg寄存器+计数
	reg [(float_len*2-1):0] temp[(tf_num-1):0];
	reg [bram_tf_addr_len:0] counter;
	//状态机：实现fifo
	//刷新计数器counter
	always@(posedge rst or posedge clk)begin
		if(rst == 1)begin
			counter <= 0;
			dout <= dout;
			temp[0] <= 0;
			temp[1] <= 0;
			//...temp[tf_num-1] <= 0;
		end
		else if(clk == 1) begin
			case({wr_en,rd_en})
				2'b10://写入 
					begin
						if(counter < tf_num) begin
							temp[0] <= din;
							temp[1] <= temp[0];
							//...temp[tf_num-1] <= temp[tf_num-2];
							counter <= counter + 1;
						end
					end
				2'b01://读取
					begin
						if(counter > 0)
							dout <= temp[counter-1];
							counter <= counter - 1;
					end
				2'b11://读写
					begin
						if(counter > 0)
							dout <= temp[counter-1];//read
							temp[0] <= din;//write
							temp[1] <= temp[0];
							//temp[1] <= temp[0];
							//...temp[stageNum-1] <= temp[stageNum-2];
					end
				default://2'b00
					counter <= counter;
			endcase
		end
	end
	
	assign empty = (counter == 0)?1:0;
	assign full = (counter == tf_num)?1:0;
	
	/*
	//fifo写入数据:当fifo已full，写入数据失败
	always@(posedge rst or posedge clk)begin
		if(rst == 1) begin
			temp[0] <= 0;
		end
		else if(clk == 1)begin
			if(wr_en == 1 && counter < tf_num) begin
				temp[0] <= din;
				//temp[1] <= temp[0];
				//...temp[stageNum-1] <= temp[stageNum-2];
			end
		end
	end
	//fifo读出数据，当fifo为空，读出数据失败
	always@(posedge rst or posedge clk)begin
		if(rst == 1) begin
			dout <= 0;
		end
		else if(clk == 1) begin
			if(rd_en == 1 && counter > 0) begin
				//temp[0] <= temp[1];
				//temp[1] <= temp[0];
				//...temp[stageNum-1] <= temp[stageNum-2];
				dout <= temp[stageNum-1];//dout <= temp的最后一个值
			end
			else dout <= dout;
		end
	end*/

endmodule
