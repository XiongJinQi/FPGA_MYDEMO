//*****************************************
//描述：按键出发LED
//时间：
//作者：

`timescale 1ns / 10ps
module key_test(
	input        clk,
	input[3:0]   key,
	output[3:0]  led
);

reg[3:0] led_1;  // first stage latched data
reg[3:0] led_r;// second stage latched

always @(posedge clk)
	begin
	led_1 <= ~key;
	end

always @(posedge clk)
	begin
		led_r <= led_1;
	end
	
assign led = led_r;
endmodule
	
	