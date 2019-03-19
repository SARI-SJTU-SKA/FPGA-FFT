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
	rd_en,//��rd_enΪ��ʱ��fifo���dout��Ч
	full,
	empty,	
	dout//dout�ֱ�䵱x1
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
	parameter float_len = 32;//��������λ��
	parameter bram_addr_len = 13;//2^13 == dataNum(8192)
	parameter stageNum = 2;//��ǰradix������������������1,2,3,4,...
	parameter tf_num = 2;//��ת����twiddle factor�ĸ���
	parameter bram_tf_addr_len = 1;//2 ^ bram_tf_addr_len = tf_num
	
	wire clk;
	wire rst;
	wire wr_en;
	wire rd_en;
	wire full;
	wire empty;
	wire [(float_len*2-1):0] din;
	reg [(float_len*2-1):0] dout;
	
	//���ڴ洢���ݵ�reg�Ĵ���+����
	reg [(float_len*2-1):0] temp[(tf_num-1):0];
	reg [bram_tf_addr_len:0] counter;
	//״̬����ʵ��fifo
	//ˢ�¼�����counter
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
				2'b10://д�� 
					begin
						if(counter < tf_num) begin
							temp[0] <= din;
							temp[1] <= temp[0];
							//...temp[tf_num-1] <= temp[tf_num-2];
							counter <= counter + 1;
						end
					end
				2'b01://��ȡ
					begin
						if(counter > 0)
							dout <= temp[counter-1];
							counter <= counter - 1;
					end
				2'b11://��д
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
	//fifoд������:��fifo��full��д������ʧ��
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
	//fifo�������ݣ���fifoΪ�գ���������ʧ��
	always@(posedge rst or posedge clk)begin
		if(rst == 1) begin
			dout <= 0;
		end
		else if(clk == 1) begin
			if(rd_en == 1 && counter > 0) begin
				//temp[0] <= temp[1];
				//temp[1] <= temp[0];
				//...temp[stageNum-1] <= temp[stageNum-2];
				dout <= temp[stageNum-1];//dout <= temp�����һ��ֵ
			end
			else dout <= dout;
		end
	end*/

endmodule
