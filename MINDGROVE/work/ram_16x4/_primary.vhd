library verilog;
use verilog.vl_types.all;
entity ram_16x4 is
    port(
        addr            : in     vl_logic_vector(3 downto 0);
        datain          : in     vl_logic_vector(3 downto 0);
        csn             : in     vl_logic;
        rwn             : in     vl_logic;
        dataout         : out    vl_logic_vector(3 downto 0)
    );
end ram_16x4;
