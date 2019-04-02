
/**************************************************/
//by XXH
//进位模块
/**************************************************/

module count_d10(
		input clk,
		input rst_n,
		input en,
		input clr,// count synchronous flag
		output reg[3:0] data,
		output reg cy
);

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		begin
			data <= 4'd0;
			cy <= 1'b0;
		end
	else if(clr == 1'b1) // enable clr
		begin
			data <= 4'd0;
			cy <= 1'b0;
		end
	else if(en == 1'b1)  // enable en
		begin
			if(data == 4'd9)
				begin
				cy <= 1'b1;
				data <= 4'd0;
				end
			else
			begin
				data <= data +4'd1;
				cy <= 1'b0;
			end
		end
	else
		cy <= 1'b0;
end		

endmodule



