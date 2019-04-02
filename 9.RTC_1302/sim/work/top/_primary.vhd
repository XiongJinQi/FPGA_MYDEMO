library verilog;
use verilog.vl_types.all;
entity top is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        seg_sel         : out    vl_logic_vector(5 downto 0);
        seg_data        : out    vl_logic_vector(7 downto 0);
        rtc_data        : inout  vl_logic;
        rtc_ce          : out    vl_logic;
        rtc_clk         : out    vl_logic
    );
end top;
