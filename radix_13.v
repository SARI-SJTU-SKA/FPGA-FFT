`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:57:16 12/08/2019 
// Design Name: 
// Module Name:    radix_13 
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
module radix_13( //从右到左第13级：fifo_4096+蝶形加减+旋转因子存储区+乘法单元
	clk,
	rst,
	data_in,
	data_in_valid,
	data_out,
	data_out_valid
    );
	//inputs
	input clk;
	input rst;
	input data_in;
	input data_in_valid;
	
	//outputs
	output data_out;
	output data_out_valid;
	
	//parameters
	parameter float_len = 32;//浮点数的位数
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 13;//当前radix所处级数，从左向右1,2,3,4,...
	parameter tf_num = 4096;//旋转因子twiddle factor的个数
	parameter bram_tf_addr_len = 12;//2 ^ bram_tf_addr_len = tf_num
	
	wire clk;
	wire rst;
	wire data_in_valid;
	wire [(float_len*2-1):0] data_in;//39
	//wire data_out_valid;
	//wire [(float_len*2-1):0] data_out;//39
	reg data_out_valid;
	reg [(float_len*2-1):0] data_out;//39
	
	//temps
	//wire [(float_len*2-1):0] dout;//39
	//fifo启动后只能第三个（包含三个）周期以后的数据才能被写入
	reg [(float_len*2-1):0]data_in1;//39
	reg [(float_len*2-1):0]data_in2;//39
	always@(posedge rst or posedge clk) begin
		if(rst == 1)begin
			data_in1 <= 0;
			data_in2 <= 0;
		end
		else if(clk == 1)begin
			data_in1 <= data_in;
			data_in2 <= data_in1;
		end
	end

	wire [(float_len*2-1):0] x1;
	wire [(float_len*2-1):0] x2;
	wire dout_fifo_1_valid;
	fifo_4096_1 fifo_1(
	.rst(rst),
	.clk(clk),
	.data_in(data_in),
	.data_in_valid(data_in_valid),
	.data_out1(x1),//x1
	.data_out2(x2),//x2
	.data_out_valid(dout_fifo_1_valid)
	);
	wire [(float_len*2-1):0] y1;
	wire [(float_len*2-1):0] y2;
	wire dout_butterfly_valid;
	//y1 = x1 + x2
	/*注意这里的使能信号：operation_nd*/
	butterFly butterfly(
	.clk(clk),
	.rst(rst),
	.data_in1(x1),
	.data_in2(x2),
	.data_in_valid(dout_fifo_1_valid),
	.data_out1(y1),
	.data_out2(y2),
	.data_out_valid(dout_butterfly_valid)
	);
		
	//y1直接输出，y2先写入fifo，然后读出与旋转因子tf相乘再输出
	//fifo	
	reg rd_en_y2;
	wire full_y2;
	wire empty_y2;
	wire [(float_len*2-1):0] dout_y2;
	/*
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			rd_en_y2 <= 0;
		else if(full_y2 == 1 && empty_y2 == 0) begin
			rd_en_y2 <= 1;
		end
		else if(empty_y2 == 1) begin
			rd_en_y2 <= 0;
		end
	end*/
	
	//wire [(bram_tf_addr_len-1):0] data_count;
	/*reg en_flag;//表示fifo_4096_y2里面的数据个数超过tf_num - 18 = 4096 - 18 = 4078
	//assign en_flag = (data_count > 4078)?1:0;
	always@(posedge rst or posedge clk) begin
		if(rst == 1)
			en_flag <= 0;
		else if(data_count >= (tf_num-18))
			en_flag <= 1;
		else if(empty_y2 == 1)
			en_flag <= 0;
	end
	always@(posedge rst or posedge en_flag or posedge empty_y2)begin
		if(rst == 1)
			rd_en_y2 <= 0;
		else if(en_flag == 1 && empty_y2 == 0)
			rd_en_y2 <= 1;
		else if(empty_y2 == 1)
			rd_en_y2 <= 0;
	end*/
	
	//以下是增加部分
	always@(posedge rst or posedge full_y2 or posedge empty_y2)begin
		if(rst == 1)
			rd_en_y2 <= 0;
		else if(empty_y2 == 1)
			rd_en_y2 <= 0;
		else if(full_y2 == 1)
			rd_en_y2 <= 1;
	end
	parameter delay = 17+3;
	reg [(float_len*2-1):0] y1_temp[(delay-1):0];
	reg dout_butterfly_valid_temp[(delay-1):0];
	always@(posedge rst or posedge clk)begin
		if(rst == 1)begin
			dout_butterfly_valid_temp[0] <= 0;
			dout_butterfly_valid_temp[1] <= 0;
			dout_butterfly_valid_temp[2] <= 0;
			dout_butterfly_valid_temp[3] <= 0;
			dout_butterfly_valid_temp[4] <= 0;
			dout_butterfly_valid_temp[5] <= 0;
			dout_butterfly_valid_temp[6] <= 0;
			dout_butterfly_valid_temp[7] <= 0;
			dout_butterfly_valid_temp[8] <= 0;
			dout_butterfly_valid_temp[9] <= 0;
			dout_butterfly_valid_temp[10] <= 0;
			dout_butterfly_valid_temp[11] <= 0;
			dout_butterfly_valid_temp[12] <= 0;
			dout_butterfly_valid_temp[13] <= 0;
			dout_butterfly_valid_temp[14] <= 0;
			dout_butterfly_valid_temp[15] <= 0;
			dout_butterfly_valid_temp[16] <= 0;
			dout_butterfly_valid_temp[17] <= 0;
			dout_butterfly_valid_temp[18] <= 0;
			dout_butterfly_valid_temp[19] <= 0;
		end
		else if(clk == 1)begin
			dout_butterfly_valid_temp[0] <= dout_butterfly_valid;
			dout_butterfly_valid_temp[1] <= dout_butterfly_valid_temp[0];
			dout_butterfly_valid_temp[2] <= dout_butterfly_valid_temp[1];
			dout_butterfly_valid_temp[3] <= dout_butterfly_valid_temp[2];
			dout_butterfly_valid_temp[4] <= dout_butterfly_valid_temp[3];
			dout_butterfly_valid_temp[5] <= dout_butterfly_valid_temp[4];
			dout_butterfly_valid_temp[6] <= dout_butterfly_valid_temp[5];
			dout_butterfly_valid_temp[7] <= dout_butterfly_valid_temp[6];
			dout_butterfly_valid_temp[8] <= dout_butterfly_valid_temp[7];
			dout_butterfly_valid_temp[9] <= dout_butterfly_valid_temp[8];
			dout_butterfly_valid_temp[10] <= dout_butterfly_valid_temp[9];
			dout_butterfly_valid_temp[11] <= dout_butterfly_valid_temp[10];
			dout_butterfly_valid_temp[12] <= dout_butterfly_valid_temp[11];
			dout_butterfly_valid_temp[13] <= dout_butterfly_valid_temp[12];
			dout_butterfly_valid_temp[14] <= dout_butterfly_valid_temp[13];
			dout_butterfly_valid_temp[15] <= dout_butterfly_valid_temp[14];
			dout_butterfly_valid_temp[16] <= dout_butterfly_valid_temp[15];
			dout_butterfly_valid_temp[17] <= dout_butterfly_valid_temp[16];
			dout_butterfly_valid_temp[18] <= dout_butterfly_valid_temp[17];
			dout_butterfly_valid_temp[19] <= dout_butterfly_valid_temp[18];
		end
	end
	
	always@(posedge rst or posedge clk)begin
		if(rst == 1)begin
			y1_temp[0] <= 0;
			y1_temp[1] <= 0;
			y1_temp[2] <= 0;
			y1_temp[3] <= 0;
			y1_temp[4] <= 0;
			y1_temp[5] <= 0;
			y1_temp[6] <= 0;
			y1_temp[7] <= 0;
			y1_temp[8] <= 0;
			y1_temp[9] <= 0;
			y1_temp[10] <= 0;
			y1_temp[11] <= 0;
			y1_temp[12] <= 0;
			y1_temp[13] <= 0;
			y1_temp[14] <= 0;
			y1_temp[15] <= 0;
			y1_temp[16] <= 0;
			y1_temp[17] <= 0;
			y1_temp[18] <= 0;
			y1_temp[19] <= 0;
		end
		else if(clk == 1)begin
			y1_temp[0] <= y1;
			y1_temp[1] <= y1_temp[0];
			y1_temp[2] <= y1_temp[1];
			y1_temp[3] <= y1_temp[2];
			y1_temp[4] <= y1_temp[3];
			y1_temp[5] <= y1_temp[4];
			y1_temp[6] <= y1_temp[5];
			y1_temp[7] <= y1_temp[6];
			y1_temp[8] <= y1_temp[7];
			y1_temp[9] <= y1_temp[8];
			y1_temp[10] <= y1_temp[9];
			y1_temp[11] <= y1_temp[10];
			y1_temp[12] <= y1_temp[11];
			y1_temp[13] <= y1_temp[12];
			y1_temp[14] <= y1_temp[13];
			y1_temp[15] <= y1_temp[14];
			y1_temp[16] <= y1_temp[15];
			y1_temp[17] <= y1_temp[16];
			y1_temp[18] <= y1_temp[17];
			y1_temp[19] <= y1_temp[18];
		end
	end
	//以上是增加部分
	
	//FIFO_4096_DATA_COUNT fifo_4096_y2(
	FIFO_4096 fifo_4096_y2(
	.clk(clk),
	.rst(rst),
	.din(y2),
	.wr_en(dout_butterfly_valid),//wr_en变高以后会延迟三个周期，第四个周期的数据才被写入fifo
	.rd_en(rd_en_y2),//当rd_en为高时，fifo输出dout有效
	.full(full_y2),
	.empty(empty_y2),
	//.data_count(data_count),
	.dout(dout_y2)
	);
	
	wire [(float_len*2-1):0] tf;//旋转因子
	wire dout_fifo_2_valid;
	tfProvider tfprovider(
	.clk(clk),
	.rst(rst),
	.en(rd_en_y2),
	.data_out(tf),
	.data_out_valid(dout_fifo_2_valid)
    );

	wire [(float_len*2-1):0] dout_multi;	
	multiPlural multiplural(
	.clk(clk),
	.rst(rst),
	.data_in1(dout_y2),
	.data_in2(tf),
	.data_in_valid(dout_fifo_2_valid),
	.data_out(dout_multi),
	.data_out_valid(dout_multi_valid)
    );

	//输出和输出有效标志
	//assign data_out = (dout_butterfly_valid == 1)?y1:((dout_multi_valid == 1)?dout_multi:0);
	//assign data_out = (dout_multi_valid == 1)?dout_multi:((dout_butterfly_valid_temp[delay-1] == 1)?y1_temp[delay-1]:0);
	//assign data_out_valid = dout_multi_valid || dout_butterfly_valid_temp[delay-1];//乘法输出有效标志
	always@(posedge rst or posedge clk)begin
		if(rst == 1)
			data_out <= 0;
		else if(dout_multi_valid == 1)
			data_out <= dout_multi;
		else if(dout_butterfly_valid_temp[delay-1] == 1)
			data_out <= y1_temp[delay-1];
		else 
			data_out <= 0;
	end
	
	always@(posedge rst or posedge clk)begin
		if(rst == 1)
			data_out_valid <= 0;
		else if((dout_multi_valid == 1) ||(dout_butterfly_valid_temp[delay-1] == 1))
			data_out_valid <= 1;
		else 
			data_out_valid <= 0;
	end
	
endmodule
