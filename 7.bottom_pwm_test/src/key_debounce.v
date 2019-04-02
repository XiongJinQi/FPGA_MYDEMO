/*************************************************************************
// brief: key module 
//	history: 1.0
//	BY :
// date: 
/*************************************************************************/
`timescale 1 ns / 100 ps
module key_debounce (
		input clk,
		input rst_n,
		input key_in,
		output reg key_posedge,
		output reg key_negedge,
		output reg key_out

);

parameter N = 32; // define counter width
parameter FREQ = 50;         //model clock :Mhz
parameter MAX_TIME = 20;     //ms
localparam TIMER_MAX_VAL =   MAX_TIME * 1000 * FREQ;
////---------------- internal variables ---------------
reg  [N-1 : 0]  q_reg;      // timing regs
reg  [N-1 : 0]  q_next;
reg DFF1, DFF2;             // input flip-flops
wire q_add;                 // control flags
wire q_reset;
reg button_out_d0;

/////////////////////////////////////////////////////////////////
assign q_reset = (DFF1  ^ DFF2);          // xor input flip flops to look for level chage to reset counter
assign q_add = ~(q_reg == TIMER_MAX_VAL); // add to counter when q_reg msb is equal to 0

// combine 
always @(q_reset, q_add, q_next)
begin
	case( {q_reset , q_add})
        2'b00 :
                q_next <= q_reg;
        2'b01 :
                q_next <= q_reg + 1;
        default :
                q_next <= { N {1'b0} };
    endcase    
		
end

//// Flip flop inputs and q_reg update
always @(posedge clk or posedge rst_n)
begin
	if(rst_n == 1'b1)
	begin
        DFF1 <= 1'b0;
        DFF2 <= 1'b0;
        q_reg <= { N {1'b0} };
    end
    else
    begin
        DFF1 <= key_in;
        DFF2 <= DFF1;
        q_reg <= q_next;
    end

end

// counter conunt
always @(posedge clk or posedge rst_n)
begin
	if(rst_n == 1'b1)
		key_out <= 1'b1;
	else if(q_next == TIMER_MAX_VAL)
				key_out <= DFF2;
	else 
		key_out <= key_out;
end

// key's posedge and negedge
always @(posedge clk or posedge rst_n)
begin
	if(rst_n == 1'b1)
	begin 
		button_out_d0 <= 1'b1;
		key_posedge <= 1'b0;
		key_negedge <= 1'b0;
	end
	
	else 
	begin
		button_out_d0 <= key_out;
		key_posedge	<= ~button_out_d0 & key_out;
		key_negedge <= button_out_d0 & ~key_out;
	end
end


endmodule

