/*************************************************************************
// brief: top module 
//	history: 1.0
//	BY :
// date: 
/*************************************************************************/

module bottom_pwm_test
	(
	input clk,
	input rst_n,
	input key_in,
	output buzzer
	);

parameter IDLE    = 0;
parameter BUZZER  = 1;

wire button_negedge;
wire pwm_out;
reg[31:0] period;
reg[31:0] duty;

reg[3:0] state;
reg[31:0] timer;
assign buzzer = ~(pwm_out & (state == BUZZER));//buzzer  low active
	
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		period <= 32'd0;
		timer <= 32'd0;
		duty <= 32'd429496729;
		state <= IDLE;
	end
	else
		case(state)
			IDLE:
			begin
				if(button_negedge)
				begin
					period <= 32'd8590;   //The pwm step value
					state <= BUZZER;
					duty <= duty + 32'd429496729;
					
				end
			end
			BUZZER:
			begin
				if(timer >= 32'd12_499_999)      //buzzer effictive time 250ms
				begin
					state <= IDLE;
					timer <= 32'd0;
				end
				else
				begin
					timer <= timer + 32'd1;
				end
			end
			default:
			begin
				state <= IDLE;		
			end			
		endcase
end

key_debounce  key_debounce_m0(
		.clk				(clk),
		.rst_n			(~rst_n),
		.key_in			(key1),
		.key_posedge	(),
		.key_negedge	(button_negedge),
		.key_out			()

);


pwm#
(
    .N(32)
) 
pwm_m0(
    .clk      (clk),
    .rst_n    (~rst_n),
    .period   (period),
    .duty     (duty),
    .pwm_out  (pwm_out)
    );
	
endmodule
	
	