library verilog;
use verilog.vl_types.all;
entity alu_4bit is
    port(
        sel             : in     vl_logic_vector(2 downto 0);
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        cin             : in     vl_logic;
        f               : out    vl_logic_vector(3 downto 0);
        cout            : out    vl_logic
    );
end alu_4bit;
