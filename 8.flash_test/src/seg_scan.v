//*************************************************************************/

module seg_scan(
		input 				clk,
		input 				rst_n,
		output reg[5:0] 	seg_sel,
		output reg[7:0] 	seg_data,
		input[7:0] 			seg_data0,
		input[7:0] 			seg_data1,
		input[7:0] 			seg_data2,
		input[7:0] 			seg_data3,
		input[7:0] 			seg_data4,
		input[7:0] 			seg_data5
);
// define clk_fre and scan cycle
parameter SCAN_FRE = 200;
parameter CLK_FRE = 50000000; // 晶振频率

parameter SCAN_CYCLE = CLK_FRE/(SCAN_FRE*6)-1;

reg[31:0] 	scan_timer;
reg[3:0]		scan_sel;

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
		scan_timer <= 32'b0;
		scan_sel <= 4'b0;
		end
	else if(scan_timer >= SCAN_CYCLE)
		begin
		scan_timer  <= 32'B0;
		if(scan_sel > 4'd5)
			scan_sel	<= 4'd0;
		else
			scan_sel <= scan_sel + 4'd1;
		end
	else
		begin 
		scan_timer <= scan_timer + 32'b1;
		end
end

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
		seg_sel <= 6'b11_1111;
		seg_data <= 8'hff;
		end
	else
	begin
		case(scan_sel)
			4'd0:
				//first digital led
				begin
					seg_sel <= 6'b11_1110;
					seg_data <= seg_data0;
				end
				//second digital led
			4'd1:
				begin
					seg_sel <= 6'b11_1101;
					seg_data <= seg_data1;
				end
			4'd2:
				begin
					seg_sel <= 6'b11_1011;
					seg_data <= seg_data2;
				end
			4'd3:
				begin
					seg_sel <= 6'b11_0111;
					seg_data <= seg_data3;
				end
			4'd4:
				begin
					seg_sel <= 6'b10_1111;
					seg_data <= seg_data4;
				end
			4'd5:
				begin
					seg_sel <= 6'b01_1111;
					seg_data <= seg_data5;
				end
			default:
				begin
					seg_sel <= 6'b11_1111;
					seg_data <= 8'hff;
				end
			endcase	
	end
end

endmodule



