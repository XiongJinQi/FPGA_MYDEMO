///////////////////////////
module seg_scan(
    input           clk,
    input           rst,
    output reg[5:0]     seg_sel,
    output reg[7:0]     seg_data,
    input[7:0]      seg_data_0,
    input[7:0]      seg_data_1,
    input[7:0]      seg_data_2,
    input[7:0]      seg_data_3,
    input[7:0]      seg_data_4,
    input[7:0]      seg_data_5
);
parameter SCAN_FREQ = 200;
parameter SYSCLK = 50000000; //  Mhz
parameter SCAN_COUNT = SYSCLK/(SCAN_FREQ*6) - 1;

reg[31:0]   scan_time;
reg[3:0]    scan_sel;

always @(posedge clk or negedge rst) begin
    if(rst == 1'b0)
    begin
        scan_time <= 32'd0;
        scan_sel <= 4'd0;
    end
    else if(scan_time >= SCAN_COUNT)
    begin
        scan_time <= 32'd0;
        if(scan_sel == 4'd5)
            scan_sel <= 4'd0;
        else
            scan_sel <= scan_sel + 4'd1;
    end
    else
    begin 
        scan_time <= scan_time + 32'd1;
    end
end

always @(posedge clk or negedge rst) begin
    if(rst == 1'b0)
    begin
        seg_sel <= 6'b11_1111;
        seg_data <= 8'hff; 
    end
    else
    begin
        case ( scan_sel )
        4'd0:
		  begin
            seg_sel <= 6'b11_1110;
            seg_data <= seg_data_0;
			end
        4'd1:
		  begin
            seg_sel <= 6'b11_1101;
            seg_data <= seg_data_1;
			end
        4'd2:
		  begin
            seg_sel <= 6'b11_1011;
            seg_data <= seg_data_2;  
			end
        4'd3:
		  begin
            seg_sel <= 6'b11_0111;
            seg_data <= seg_data_3;
				end
        4'd4:
				begin
            seg_sel <= 6'b10_1111;
            seg_data <= seg_data_4;
				end
        4'd5:
		  begin
            seg_sel <= 6'b01_1111;
            seg_data <= seg_data_5;
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