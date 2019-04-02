library verilog;
use verilog.vl_types.all;
entity seg_bcd is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        seg_sel         : out    vl_logic_vector(5 downto 0);
        seg_data        : out    vl_logic_vector(7 downto 0);
        seg_bcd         : in     vl_logic_vector(23 downto 0)
    );
end seg_bcd;
