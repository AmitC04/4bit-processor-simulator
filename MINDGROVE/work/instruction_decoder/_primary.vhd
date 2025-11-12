library verilog;
use verilog.vl_types.all;
entity instruction_decoder is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        instruction     : in     vl_logic_vector(10 downto 0);
        alu_sel         : out    vl_logic_vector(2 downto 0);
        addr            : out    vl_logic_vector(3 downto 0);
        operand         : out    vl_logic_vector(3 downto 0);
        csn             : out    vl_logic;
        rwn             : out    vl_logic;
        alu_enable      : out    vl_logic;
        state           : out    vl_logic_vector(1 downto 0)
    );
end instruction_decoder;
