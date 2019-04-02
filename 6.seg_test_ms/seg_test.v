/**************************************************/
//by XXH
//组合逻辑
/**************************************************/

module seg_test(
	input clk,
	input rst_n,
	output[5:0] seg_sel,
	output[7:0] seg_data
);
//define 1s counter
localparam COUNT_10MS = 32'd499_999;

// timer 
reg[31:0] timer_cnt;
reg en_10ms;                          

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
		timer_cnt <= 32'd0;
		en_10ms 	 <= 1'b0;
		end
	else if(timer_cnt >= COUNT_10MS)
		begin 
			timer_cnt <= 32'd0;
			en_10ms	 <= 1'b1;
		end
	else 
		begin
		en_10ms 	 <= 1'b0;
		timer_cnt <= timer_cnt + 32'd1;
		end
end

// 实例化
wire[3:0] count0;
wire cy0;
count_d10 count_d0(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(en_10ms),
		.clr		(1'b0),    // count synchronous flag
		.data		(count0),
		.cy		(cy0)
);

wire[3:0] count1;
wire cy1;
count_d10 count_d1(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(cy0),
		.clr		(1'b0),    // count synchronous flag
		.data		(count1),
		.cy		(cy1)
);

wire[3:0] count2;
wire cy2;
count_d10 count_d2(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(cy1),
		.clr		(1'b0),    // count synchronous flag
		.data		(count2),
		.cy		(cy2)
);

wire[3:0] count3;
wire cy3;
count_d10 count_d3(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(cy2),
		.clr		(1'b0),    // count synchronous flag
		.data		(count3),
		.cy		(cy3)
);

wire[3:0] count4;
wire cy4;
count_d10 count_d4(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(cy3),
		.clr		(1'b0),    // count synchronous flag
		.data		(count4),
		.cy		(cy4)
);

wire[3:0] count5;
wire cy5;
count_d10 count_d5(
		.clk		(clk),
		.rst_n	(rst_n),
		.en		(cy4),
		.clr		(1'b0),    // count synchronous flag
		.data		(count5),
		.cy		(cy5)
);
 
wire[6:0] seg_data_0;
seg_decoder seg_decoder_m0(
    .bin_data  (count5),
    .seg_data  (seg_data_0)
);
wire[6:0] seg_data_1;
seg_decoder seg_decoder_m1(
    .bin_data  (count4),
    .seg_data  (seg_data_1)
);
wire[6:0] seg_data_2;
seg_decoder seg_decoder_m2(
    .bin_data  (count3),
    .seg_data  (seg_data_2)
);
wire[6:0] seg_data_3;
seg_decoder seg_decoder_m3(
    .bin_data  (count2),
    .seg_data  (seg_data_3)
);
wire[6:0] seg_data_4;
seg_decoder seg_decoder_m4(
    .bin_data  (count1),
    .seg_data  (seg_data_4)
);

wire[6:0] seg_data_5;
seg_decoder seg_decoder_m5(
    .bin_data  (count0),
    .seg_data  (seg_data_5)
);

seg_scan	seg_scan_m0(
		.clk			(clk),
		.rst_n		(rst_n),
		.seg_sel		(seg_sel),
		.seg_data	(seg_data),
		.seg_data0	({1'b1,seg_data_0}),
		.seg_data1	({1'b1,seg_data_1}),
		.seg_data2	({1'b1,seg_data_2}),
		.seg_data3	({1'b0,seg_data_3}),
		.seg_data4	({1'b1,seg_data_4}),
		.seg_data5	({1'b1,seg_data_5})
);

endmodule


