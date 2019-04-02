//   XXXH
// date:2018-11-15

module uart_rx 
#(
	parameter CLK_FRE = 50, //MHz
	parameter BUAD_RATE = 115200 // 波特率
)
(
	input clk,
	input rst_n,
	output reg[7:0] recieve_data,
	output reg rx_data_valid,
	input rx_data_ready,//接受完成标志
	input rx_pin  //接受数据引脚
);

//buad rate caculate
localparam CYCLE = CLK_FRE*1000000/BUAD_RATE;

//state machine code
localparam  STA_IDLE 		= 1;
localparam  STA_START 		= 2;
localparam	STA_REV_DATA 	= 3;
localparam	STA_DATA 		= 4;
localparam	STA_STOP 		= 5;

//define state machine and rx data regerist
reg[2:0] 	state;
reg[2:0] 	next_state;
reg 			rx_pin_d0; // source
reg 			rx_pin_d1; // delay 1 clock
wire 			rx_negedge;
reg[7:0]		rx_bits;
reg[15:0]	cycle_cnt;
reg[2:0]		bit_cnt;

assign rx_negedge = rx_pin_d1 && ~rx_pin_d0; //check the start bit

always@(posedge clk or negedge rst_n)
begin
		if(rst_n == 1'b0)
		begin
			rx_pin_d0 <= 1'b0;
			rx_pin_d1 <= 1'b0;
		end
		else
			begin
			rx_pin_d0 <= rx_pin;
			rx_pin_d1 <= rx_pin_d0;
			end
end

// STA_IDLE
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		state <= STA_IDLE;
	else
		state <= next_state;
end



//STA_REV_DATA, recieve 8bits data
always@(posedge clk or negedge rst_n)
begin 
	if(rst_n == 1'b0)
		bit_cnt <= 3'b0;
	else if(next_state == STA_REV_DATA )
			begin
			if(cycle_cnt == CYCLE -1)
				bit_cnt <= bit_cnt + 3'b1;
			else
				bit_cnt <= bit_cnt;
			end
		else
			bit_cnt <= 3'b0;
			
end
always@(posedge clk or negedge rst_n )
begin 
		if(rst_n == 1'b0)
			cycle_cnt <= 16'b0;
		else if((next_state == STA_REV_DATA && cycle_cnt == CYCLE - 1)||(next_state != state))
			cycle_cnt <= 16'b0;
			else
				cycle_cnt <= cycle_cnt + 16'b1;
end

always@(posedge clk or negedge rst_n)
begin
		if(rst_n == 1'b0)
			rx_bits = 8'b0;
		else if((next_state == STA_REV_DATA) && (cycle_cnt == CYCLE/2 - 1))
					rx_bits[bit_cnt] <= rx_pin;
				else
					rx_bits <= rx_bits;
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rx_data_valid <= 1'b0;
	else if(state == STA_STOP && next_state != state)
		rx_data_valid <= 1'b1;
	else if(state == STA_DATA && rx_data_ready)
		rx_data_valid <= 1'b0;
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		recieve_data <= 8'd0;
	else if(state == STA_STOP && next_state != state)
		recieve_data <= rx_bits;//latch received data
end

//state machine 
always@(*)
begin
	case(state)
		STA_IDLE:
			if(rx_negedge)
				next_state = STA_START;
			else
				next_state = STA_IDLE;	
		STA_START:
			if(cycle_cnt == CYCLE - 1)//one data cycle 
				next_state <= STA_REV_DATA;
			else
				next_state <= STA_START;
		
		STA_REV_DATA:
			if(cycle_cnt == CYCLE -1 && bit_cnt == 3'd7)
				next_state <= STA_STOP;
			else
				next_state <= STA_REV_DATA;
		STA_DATA:
			if(rx_data_ready == 1'b1)    //data receive complete
				next_state <= STA_IDLE;
			else
				next_state <= STA_DATA;
		STA_STOP:
			if(cycle_cnt == CYCLE/2 -1)
				next_state <= STA_DATA;
			else
				next_state <= STA_STOP;
		default:
				next_state <= STA_IDLE;
	endcase
end

endmodule


