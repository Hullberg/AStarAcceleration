library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mapped_register_readable is
  generic (
    BYTE_WIDTH : integer := 1;
    SWITCHABLE : boolean := true;
    BIG_ENDIAN : boolean := true
  ); 
  port (
    register_clk : in std_logic;
    register_in : in std_logic_vector(7 downto 0);
    register_out : out std_logic_vector(7 downto 0);
    register_rotate : in std_logic;
    register_stop : in std_logic;
    register_switch : in std_logic;
    reg_in : in std_logic_vector(BYTE_WIDTH*8-1 downto 0)
  );
end mapped_register_readable;

architecture rtl of mapped_register_readable is
  signal reg_in_int : std_logic_vector(BYTE_WIDTH*8-1 downto 0);
  signal mapped_registers : std_logic_vector(BYTE_WIDTH*8-1 downto 0) := (others => '0');
begin

  -- Switchable register option
  USE_SWITCH: if SWITCHABLE = true generate
    signal mapped_registers_static : std_logic_vector(BYTE_WIDTH*8-1 downto 0) := (others => '0');
  begin
    process(register_clk)
    begin
      if rising_edge(register_clk) then
        if register_stop = '0' and register_switch = '1' then
          mapped_registers_static <= reg_in;
        end if;
      end if;
    end process;
    reg_in_int <= mapped_registers_static;
  end generate;

  NO_SWITCH: if SWITCHABLE = false generate
    reg_in_int <= reg_in;
  end generate;

  -- Endianness option
  USE_BIG_ENDIAN: if BIG_ENDIAN = true generate
    register_out <= mapped_registers(BYTE_WIDTH*8-1 downto (BYTE_WIDTH-1)*8);

    process(register_clk)
    begin
      if rising_edge(register_clk) then
        if register_rotate = '1' then
          mapped_registers(7 downto 0) <= register_in;
          for i in 1 to BYTE_WIDTH-1 loop
            mapped_registers(((i+1)*8)-1 downto (i*8)) <=
              mapped_registers((i*8)-1 downto (i-1)*8);
          end loop;
        elsif register_stop = '0' then
          mapped_registers <= reg_in_int;
        end if;
      end if;
    end process;
  end generate;

  USE_LITTLE_ENDIAN: if BIG_ENDIAN = false generate
    register_out <= mapped_registers(7 downto 0);

    process(register_clk)
    begin
      if rising_edge(register_clk) then
        if register_rotate = '1' then
          mapped_registers(BYTE_WIDTH*8-1 downto (BYTE_WIDTH-1)*8) <= register_in;
          for i in 1 to BYTE_WIDTH-1 loop
            mapped_registers((i*8)-1 downto (i-1)*8) <= mapped_registers(((i+1)*8)-1 downto (i*8));
          end loop;
        elsif register_stop = '0' then 
          mapped_registers <= reg_in_int;
        end if;
      end if;
    end process;
  end generate;

end rtl;
