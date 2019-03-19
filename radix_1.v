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
module radix_1( //���ҵ����13����fifo_4096+���μӼ�+��ת���Ӵ洢��+�˷���Ԫ
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
	parameter float_len = 32;//��������λ��
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 1;//��ǰradix������������������1,2,3,4,...
	parameter tf_num = 1;//��ת����twiddle factor�ĸ���
	parameter bram_tf_addr_len = 0;//2 ^ bram_tf_addr_len = tf_num
	
	wire clk;
	wire rst;
	wire data_in_valid;
	wire [(float_len*2-1):0] data_in;//39
	wire data_out_valid;
	wire [(float_len*2-1):0] data_out;//39	
	//reg data_out_valid;
	//reg [(float_len*2-1):0] data_out;//39
	
	//temps
	//wire [(float_len*2-1):0] dout;//39
	//fifo������ֻ�ܵ����������������������Ժ�����ݲ��ܱ�д��
	/*reg [(float_len*2-1):0]data_in1;//39
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
	end*/

	wire [(float_len*2-1):0] x1;
	wire [(float_len*2-1):0] x2;
	wire dout_fifo_1_valid;
	fifo_1_1 fifo_1(
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
	/*ע�������ʹ���źţ�operation_nd*/
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
		
	//��ת����Ϊ�㣬����butterfly��Ԫ�����Ժ�ֱ�����

	//��� data_out �������Ч��־ data_out_valid
	/*always@(posedge rst or posedge clk)begin
		if(rst == 0)
			data_out_valid <= 0;
		else if(clk == 1)
			data_out_valid <= dout_butterfly_valid;
	end
	//���������y1���½������y2
	//always@(posedge rst or posedge clk or negedge clk or dout_butterfly_valid )begin
	always@(rst or clk or dout_butterfly_valid)begin
		if(rst == 0)
			data_out <= 0;
		else if(dout_butterfly_valid == 1) begin
			if(clk == 1)
				data_out <= y1;
			else //if(clk == 0)
				data_out <= y2;
		end
		else if(dout_butterfly_valid == 0)
			data_out <= 0;
	end
	*/
	reg [(float_len*2-1):0] y2_temp;
	reg y2_temp_valid;
	always@(posedge clk or posedge rst)begin
		if(rst == 1) begin
			y2_temp <= 0;
			y2_temp_valid <= 0;
		end
		else if(clk == 1) begin
			y2_temp <= y2;
			y2_temp_valid <= dout_butterfly_valid;
		end
	end
	assign data_out_valid = dout_butterfly_valid || y2_temp_valid;
	assign data_out = (dout_butterfly_valid == 1)?y1:((y2_temp_valid == 1)?y2_temp:0);

endmodule
