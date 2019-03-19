`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:09:34 12/07/2017 
// Design Name: 
// Module Name:    fft_8192_top 
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
module fft_8192_top(
	clk,
	rst,
	//din_valid,
	//din,
	en,
	dout_valid,
	dout,
	dout_finish
    );
	//inputs
	input clk;
	input rst;
	input en;
	//input din_valid;//Ϊ�ߵ�ƽʱ��������Ч
	//input din;//36λ���룬��18λ��ʾʵ������18λ��ʾ�鲿
	
	//parameters
	parameter float_len = 32;
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter dataNum = 8192;//2^13 == dataNum(8192)
	
	wire clk;
	wire rst;
	wire en;
	wire [(float_len*2-1):0] din;
	
	//outputs
	output dout_valid;//Ϊ�ߵ�ƽʱ�������Ч
	output dout;//float_len*2λ�������float_lenλ��ʾʵ������float_lenλ��ʾ�鲿
	output dout_finish;
	wire dout_finish;
	wire dout_valid;
	wire [(float_len*2-1):0] dout;
	
	/**
	*��bram�ж�ȡFFT������
	input: ena,clka,addra
	output: bram_dout_valid�����din
	*/
	//wire [(bram_addr_len-1):0] addr;//[12:0]0~8191
	wire bram_dout_valid;//����bram�������Ч
	bram_in_8192 bram_in(
	.clk(clk),
	.rst(rst),
	.en(en),
	.data_out(din),
	.data_out_valid(bram_dout_valid)
	);
	
	wire dout_valid_13;
	wire [(float_len*2-1):0] dout_13;
	
	radix_13 radix13( //���ҵ����13����fifo_4096+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(din),
	.data_in_valid(bram_dout_valid),
	.data_out(dout_13),
	.data_out_valid(dout_valid_13)
    );

	wire dout_valid_12;
	wire [(float_len*2-1):0] dout_12;
	
	radix_12 radix12( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_13),
	.data_in_valid(dout_valid_13),
	.data_out(dout_12),
	.data_out_valid(dout_valid_12)
    );

	wire dout_valid_11;
	wire [(float_len*2-1):0] dout_11;
	
	radix_11 radix11( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_12),
	.data_in_valid(dout_valid_12),
	.data_out(dout_11),
	.data_out_valid(dout_valid_11)
    );
	 
	wire dout_valid_10;
	wire [(float_len*2-1):0] dout_10;
	
	radix_10 radix10( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_11),
	.data_in_valid(dout_valid_11),
	.data_out(dout_10),
	.data_out_valid(dout_valid_10)
    );	 

	wire dout_valid_9;
	wire [(float_len*2-1):0] dout_9;
	
	radix_9 radix9( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_10),
	.data_in_valid(dout_valid_10),
	.data_out(dout_9),
	.data_out_valid(dout_valid_9)
    );	 

	wire dout_valid_8;
	wire [(float_len*2-1):0] dout_8;
	
	radix_8 radix8( //���ҵ����8����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_9),
	.data_in_valid(dout_valid_9),
	.data_out(dout_8),
	.data_out_valid(dout_valid_8)
    );	

	wire dout_valid_7;
	wire [(float_len*2-1):0] dout_7;
	
	radix_7 radix7( //���ҵ����7����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_8),
	.data_in_valid(dout_valid_8),
	.data_out(dout_7),
	.data_out_valid(dout_valid_7)
    );

	wire dout_valid_6;
	wire [(float_len*2-1):0] dout_6;
	
	radix_6 radix6( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_7),
	.data_in_valid(dout_valid_7),
	.data_out(dout_6),
	.data_out_valid(dout_valid_6)
    );

	wire dout_valid_5;
	wire [(float_len*2-1):0] dout_5;
	
	radix_5 radix5( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_6),
	.data_in_valid(dout_valid_6),
	.data_out(dout_5),
	.data_out_valid(dout_valid_5)
    );
	 
	wire dout_valid_4;
	wire [(float_len*2-1):0] dout_4;
	
	radix_4 radix4( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_5),
	.data_in_valid(dout_valid_5),
	.data_out(dout_4),
	.data_out_valid(dout_valid_4)
    );

	wire dout_valid_3;
	wire [(float_len*2-1):0] dout_3;
	
	radix_3 radix3( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_4),
	.data_in_valid(dout_valid_4),
	.data_out(dout_3),
	.data_out_valid(dout_valid_3)
    );

	wire dout_valid_2;
	wire [(float_len*2-1):0] dout_2;
	
	radix_2 radix2( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_3),
	.data_in_valid(dout_valid_3),
	.data_out(dout_2),
	.data_out_valid(dout_valid_2)
    );

	wire dout_valid_1;
	wire [(float_len*2-1):0] dout_1;
	
	radix_1 radix1( //���ҵ����12����fifo_2048+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
	.clk(clk),
	.rst(rst),
	.data_in(dout_2),
	.data_in_valid(dout_valid_2),
	//.data_in(din),
	//.data_in_valid(bram_dout_valid),
	.data_out(dout_1),
	.data_out_valid(dout_valid_1)
    );

	//assign dout_valid = dout_valid_13;
	//assign dout = dout_13;
	assign dout_valid = dout_valid_1;
	assign dout = dout_1;

	reg [bram_addr_len:0] dout_count;//��¼��Ч������ݵĸ���
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			dout_count <= 0;
		else if(dout_valid == 1)begin
			if(dout_count == dataNum)
				dout_count <= 1;
			else
				dout_count <= dout_count + 1;
		end			
	end
	assign dout_finish = (dout_count == dataNum)?1:0;//��߱�ʾ����Ѿ�����������һ�����ڵĸߵ�ƽ
	 
endmodule
