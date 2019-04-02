//---------------------------------------------------
//  i2c_eeprom testbench
// -----------------------------------------

`timescal 1ns/1ns

module i2c_eeprom_tb;

reg clk;
input rst;
input key1;
wire i2c_scl;
wire i2c_sda;

output[7:0] seg_data;
output[5:0] seg_sel;

reg[7:0]    key_counter;

initial 
begin
    clk = 0;
    forever #50 clk = ~clk;
end

initial
begin
    key1 = 1'b0;
    rst  = 1'b1;
    #100 rst = 1'b0;
    #100 rst = 1'b1;
    for ( key_counter=0 ; key_counter<100 ; key_counter++ ) begin
      key1 = 1'b1;
      #100 key1 = 1'b0;
    end
end
pullup p1(i2c_scl);
pullup p2(i2c_sda);

i2c_eeprom_test i2c_eeprom_tb_m0(
    .clk           (clk),
    .rst_n         (rst),
    .key1          (key1),
    .i2c_sda       (i2c_sda),
    .i2c_scl       (i2c_scl),
    .seg_sel       (),
    .seg_data      ()
);

M24AA02 memory
(
    .A0     (1'b0),
    .A1     (1'b0), 
    .A2     (1'b0), 
    .WP     (1'b0), 
    .SDA    (i2c_sda), 
    .SCL    (i2c_scl), 
    .RESET  (rst)
);

endmodule // i2c_eeprom_tb




