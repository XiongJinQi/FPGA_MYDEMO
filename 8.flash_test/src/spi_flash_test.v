// **************************************************
//
//
//
//*************************************************
`include "spi_flash_defines.v"
module	spi_flash_test(
	input 			clk,
	input				rst_n,
	input				key1,
	output			ncs,
	output			dclk, // clock
	output			mosi,
	input				miso,// master input
	output[5:0]		seg_sel,
	output[7:0]		seg_data
);

localparam	S_IDLE			= 0;
localparam	S_READ_ID		= 1;
localparam	S_SE				= 2;
localparam	S_PP				= 3;
localparam	S_READ			= 4;
localparam	S_WAIT			= 5;
reg[3:0] state;













endmodule  


