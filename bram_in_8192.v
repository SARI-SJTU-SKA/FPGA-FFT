`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:01:00 12/12/2017 
// Design Name: 
// Module Name:    bram_in_8192 
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
module bram_in_8192(
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
	 parameter float_len = 32;
	 
	 reg data_out_valid;
	 wire [(float_len*2-1):0]data_out;
	//temps
	reg [12:0]addr;//bram�ĵ�ַ������
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			addr <= 0;
		else if(en == 1) begin
			addr <= addr + 1;//����8191���������
		end
		else 
			addr <= addr;
	end
	
	always@(posedge clk or posedge rst) begin
		if(rst == 1)
			data_out_valid <= 0;
		else
			data_out_valid <= en;//bram������ʹ���ź�ena֮��һ�����ڣ��������Ա�֤bram_out_validΪ��ʱ��Ӧbram�����Ϊ��Чֵ
	end
	
	BRAM_DATA_IN bram_data_in(
	.clka(clk),
	.addra(addr),
	.ena(en),
	.douta(data_out)
	);

endmodule
