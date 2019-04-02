/*************************************************************************
// brief: pwm module 
//	history: 1.0
//	BY :
// date: 
/*************************************************************************/

`timescale 1ns / 10ps

module pwm
#(
		parameter N = 16 //pwm bit width 
)
(
	input clk,
	input rst_n,
	input[N-1:0] period,
	input[N-1:0] duty,
	output pwm_out

);
// param define 
reg[N-1:0] period_r;
reg[N-1:0] duty_r;
reg[N-1:0] period_cnt;
reg pwm_out_r;

assign pwm_out = pwm_out_r;

// 
always @(posedge clk or posedge rst_n)
begin
	if(rst_n == 1'b1) // reset is down
	begin
		period_r <= 16'd0;
		duty_r   <= 16'd0;
		
	end
	else
	begin
		period_r <= period;
		duty_r   <= duty;
	end
end

// pwm opration 
always @(posedge clk or posedge rst_n)
begin
	if(rst_n == 1'b1)
		period_cnt <= {N{1'b0}};
	else
		period_cnt <= period_cnt + period_r;
end

//
always @(posedge clk or posedge rst_n)
begin 
	if(rst_n == 1'b1)
		pwm_out_r <= 1'b0;
	else
	begin
		if(period_cnt >= duty)
			pwm_out_r <= 1'b1;
		else
			pwm_out_r <= 1'b0;
	end
end

endmodule

