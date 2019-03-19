`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:39:58 12/14/2017 
// Design Name: 
// Module Name:    tfProvider12 
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
module tfProvider8(
	clk,
	rst,
	en,
	data_out,
	data_out_valid
    );
	//inputs
	input clk;
	input rst;
	input en;
	
	//outputs
	output data_out;
	output data_out_valid;

	//parameters
	parameter float_len = 32;//��������λ��
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 8;//��ǰradix������������������1,2,3,4,...
	parameter tf_num = 128;//��ת����twiddle factor�ĸ���
	parameter bram_tf_addr_len = 7;//2 ^ bram_tf_addr_len = tf_num
	
	wire rst;
	wire clk;
	wire en;
	reg data_out_valid;
	wire [(float_len*2-1):0] data_out;//��ת����
	 
	always@(posedge rst or posedge clk)begin
		if(rst == 1)
			data_out_valid <= 0;
		else if(clk == 1)
			data_out_valid <= en;
	end
	//��ram��ȡ��ת����
	//��y1������������Ϳ���ȡ��
	//y1 = x1 + x2ʱ���þ����˷�ֱ�������y1 = y2�����Ҫ�����˷�
	reg [(bram_tf_addr_len-1):0] addr;//0~4095
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			addr <= 0;
		else if(clk == 1 && en == 1)
			addr <= addr + 1;
		else
			addr <= addr;
	end
	BRAM_128_48 bram_tf_128(
	.clka(clk),
	.addra(addr),
	.ena(en),
	.douta(data_out)
	);

endmodule

