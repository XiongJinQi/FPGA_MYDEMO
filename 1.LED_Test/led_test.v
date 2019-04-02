//led test
`timescale 1ns / 1ps
module led_test
(
	input clk,
	input rst_led,
	output reg[3:0] led
	
);

// 定义一个计数器
reg [31:0] timecounter;

always@(posedge clk or negedge rst_led)
		begin
			if(!rst_led)
				timecounter = 32'd0;
			else if(timecounter == 32'd199_999_999) // 50M*4-1
				timecounter = 32'd0;
			else
				timecounter = timecounter+32'd1;
		end
always@(posedge clk or negedge rst_led)
	begin
		if(!rst_led)
			led = 4'b0000;
		else if(timecounter == 32'd49_999_999)//第一秒
			led = 4'b0001;
		else if(timecounter == 32'd99_999_999)// 第二秒
			led = 4'b0010;
		else if(timecounter == 32'd149_999_999) // third seconds
			led = 4'b0100;
		else if(timecounter == 32'd199_999_999)// forth seconds
			led = 4'b1000;
	end
endmodule

		
				