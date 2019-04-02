library verilog;
use verilog.vl_types.all;
entity ds1302_test is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        ds1302_ce       : out    vl_logic;
        ds1302_sclk     : out    vl_logic;
        ds1302_io       : inout  vl_logic;
        read_second     : out    vl_logic_vector(7 downto 0);
        read_minute     : out    vl_logic_vector(7 downto 0);
        read_hour       : out    vl_logic_vector(7 downto 0);
        read_date       : out    vl_logic_vector(7 downto 0);
        read_month      : out    vl_logic_vector(7 downto 0);
        read_week       : out    vl_logic_vector(7 downto 0);
        read_year       : out    vl_logic_vector(7 downto 0)
    );
end ds1302_test;
