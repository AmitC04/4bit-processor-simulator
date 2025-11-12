library verilog;
use verilog.vl_types.all;
entity processor_4bit is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        instruction     : in     vl_logic_vector(10 downto 0);
        result          : out    vl_logic_vector(3 downto 0);
        mem_out         : out    vl_logic_vector(3 downto 0);
        current_state   : out    vl_logic_vector(1 downto 0)
    );
end processor_4bit;
