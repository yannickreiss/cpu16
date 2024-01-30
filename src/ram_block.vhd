-- ram_block.vhd
-- Date:   Tue Jan 30 11:18:02 2024
-- Author:    Yannick Reiß
-- E-Mail:    yannick.reiss@protonmail.ch
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ram_Block is
  port (
    Clk         : in  std_logic;
    WriteEnable : in  std_logic;
    AddrA       : in  std_logic_vector(14 downto 0);
    AddrB       : in  std_logic_vector(14 downto 0);
    Input       : in  std_logic_vector(15 downto 0);
    ReadA       : out std_logic_vector(15 downto 0);
    ReadB       : out std_logic_vector(15 downto 0)
    );
end Ram_Block;

architecture Memory of Ram_Block is

  type MemBlock is array(0 to 32768) of std_logic_vector(15 downto 0);

  signal Store        : MemBlock                      := (others => (others => '0'));
  signal RegA         : std_logic_vector(15 downto 0) := (others => '0');
  signal RegB         : std_logic_vector(15 downto 0) := (others => '0');
begin

  ReadWrite : process(Clk)
  begin

    if rising_edge(Clk) then

      if WriteEnable = '1' then
        Store(to_integer(unsigned(AddrB))) <= Input;
      end if;

      RegA <= Store(to_integer(unsigned(AddrA)));
      RegB <= Store(to_integer(unsigned(AddrB)));

    end if;
  end process ReadWrite;

  ReadA     <= RegA;
  ReadB     <= RegB;

end Memory;
