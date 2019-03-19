`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:44 12/06/2017 
// Design Name: 
// Module Name:    fft_top 
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
/*module fft_top(
input clk, 
input rst, 
input in_valid, //������Ч���ߵ�ƽ��Ч
input in, //36λ���룬��18λ��ʾʵ������18λ��ʾ�鲿
output out_valid, //�����ʼ��Ч
output out_flag, //FFT�ļ������Ѿ�ȫ��������ߵ�ƽ��Ч
output out //36λ�������18λ��ʾʵ������18λ��ʾ�鲿
    );
wire clk;
wire rst;
wire in_valid;
wire [35:0]	in;
reg out_valid;
reg out_flag;
reg [35:0] out;
*/
module fft_top(
		clk, 
		rst, 
		rd_en, //fifo��ʹ���ź�
		wr_en, //fifoдʹ���ź�
		dout, //36λ�������18λ��ʾʵ������18λ��ʾ�鲿
		full,
		empty,
		dcount
	);

	input clk; 
	input rst; 
	input wr_en; //��ram��������ݣ�������fifo����д����
	input rd_en; //fifo��ʹ���ź�

	output dout; //36λ�������18λ��ʾʵ������18λ��ʾ�鲿
	output full;
	output empty;
	output dcount;
	//inputs
	wire clk;
	wire rst;
	wire wr_en;
	wire rd_en;
	//outputs
	wire [35:0] dout;
	wire full;
	wire empty;
	wire [9:0] dcount;
	//temps
	wire [35:0]	din;
	reg [8:0] addr;

	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			addr <= 0;
		else if(wr_en == 1 && full == 0)//��ֹfifo���������������ݣ�Ҫ�ӳ�����������fifoд����
			addr <= addr + 1;
		else if(wr_en == 0)
			addr <=0;
	end

	//read data from bram
	BRAM_512 bram_512(
	.addra(addr),
	.ena(wr_en),
	.clka(clk),
	.douta(din)
	);
	//write data into fifo or read data from fifo
	FIFO_512 fifo_512(
	.clk(clk),
	.rst(rst),
	.din(din),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.full(full),
	.empty(empty),
	.data_count(dcount),
	.dout(dout)
	); 

endmodule
