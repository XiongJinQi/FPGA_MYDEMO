//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------
//  2017/6/19     meisq         1.0         Original
//*************************************************************************/
module spi_master(
	input 		sysclk,
	input 		rst,
	output 		nCS,
	output		DCLK,
	output		MOSI,
	input			MISO,
	input			CPOL,
	input			CPHA,
	input			nCS_ctrl,
	input[15:0] 	DCLK_div,
	input			wr_req,
	output 		wr_ack,
	input[7:0] 	data_in,
	output[7:0] data_out
 	);
	
// state define
localparam	IDLE			= 1;
localparam	DCLK_EDGE 	= 2;
localparam	DCLK_IDLE	= 3;
localparam	ACK			= 4;
localparam	ACK_WAIT		= 5;
localparam	LAST_HALF_CYCLE = 6;
reg DCLK_reg;   
// state 
reg[2:0] 	state;
reg[2:0]	next_state;
reg[7:0] MISO_SHIFT;
reg[7:0] MOSI_SHIFT;
reg [15:0]   clk_cnt;
reg[4:0]		clk_edge_cnt;  // spi上升沿基数
assign DCLK = DCLK_reg;
assign data_out = MISO_SHIFT;
assign wr_ack = (state == ACK);
assign nCS = nCS_ctrl;
assign MOSI = MOSI_SHIFT[7];

always@(posedge sysclk or posedge rst)
begin
	if(rst)
		state <= IDLE;
	else
		state <= next_state;
end	
//////////////////////////
always@(*)
begin
	case(state)
		IDLE: 
			if(wr_req == 1'b1)
				next_state <= DCLK_IDLE;
			else
				next_state <= IDLE;
		DCLK_IDLE:
			if(clk_cnt == DCLK_div)
				next_state <= DCLK_EDGE;
			else
				next_state <= DCLK_IDLE;
		DCLK_EDGE:
			if(clk_edge_cnt == 5'd15) //a SPI byte with a total of 16 clock edges
				next_state <= LAST_HALF_CYCLE;
			else
				next_state <= DCLK_IDLE;
		LAST_HALF_CYCLE:
			if( clk_cnt == DCLK_div)
				next_state <= ACK;
			else
				next_state <= LAST_HALF_CYCLE;
		ACK:
			next_state <= ACK_WAIT;
		ACK_WAIT:
			next_state <= IDLE;
		default:
			next_state <= IDLE;
	endcase
end

/////////////////////////////////////          
always @(posedge sysclk or posedge rst ) begin
  if(rst)
	DCLK_reg <= 1'b0;
  else if(state == IDLE)
	DCLK_reg <= CPOL;
	else if(state == DCLK_EDGE)
		DCLK_reg <= ~DCLK_reg;  // SPI clock edge
end
//////////////////////////////////////////
always @(posedge sysclk or posedge rst) begin
  if(rst)
	clk_cnt <= 16'd0;
  else if(state == DCLK_IDLE || state == LAST_HALF_CYCLE)
	clk_cnt <= clk_cnt + 16'd1;
   else
   clk_cnt <= 16'd0;
end

//////////////////////////////////////
//   spi clock edge count  
always @(posedge sysclk or posedge rst) begin
  if (rst)
		clk_edge_cnt <= 5'd0;
	else if(state == DCLK_EDGE)
		clk_edge_cnt <= clk_edge_cnt + 5'd1;
	else if(state == IDLE)
		clk_edge_cnt <= 5'd0; 
end
/////////////////////////////////


//  SPI DATA OUT
always @(posedge sysclk or posedge rst) begin
	if(rst)
		MOSI_SHIFT <= 8'd0;
	else if(state == IDLE && wr_req)
		MOSI_SHIFT <= data_in;
	else if(state == DCLK_EDGE)
		if(CPHA == 1'b0 && clk_edge_cnt[0] == 1'b1)
			MOSI_SHIFT <= {MOSI_SHIFT[6:0],MOSI_SHIFT[7]};
		else if(CPHA == 1'b1 && (clk_edge_cnt != 5'd0 && clk_edge_cnt == 1'b0))
			MOSI_SHIFT <= {MOSI_SHIFT[6:0],MOSI_SHIFT[7]};
end
// spi data in
always @(posedge sysclk or posedge rst) begin
	if(rst)
		MISO_SHIFT <= 8'd0;
	else if(state == IDLE && wr_req)
		MISO_SHIFT <= 8'h00;
	else if(state == DCLK_EDGE)
		if(CPHA == 1'b0 && clk_edge_cnt[0] == 1'b0)
			MISO_SHIFT <= {MISO_SHIFT[6:0],MISO};
		else if(CPHA == 1'b1 && (clk_edge_cnt[0] == 1'b1))
			MISO_SHIFT <= {MISO_SHIFT[6:0],MISO};
end

endmodule



















