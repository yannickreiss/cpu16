-- ProgramCounter.vhd
-- Date:   Tue Jan 30 20:54:56 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter is
  port(
    Clk      : in  std_logic;
    PcEnable : in  std_logic;
    AddrCalc : in  std_logic_vector(15 downto 0);
    Jump     : in  std_logic;
    Addr     : out std_logic_vector(15 downto 0)
    );
end ProgramCounter;

architecture Implementation of ProgramCounter is
  signal Address     : std_logic_vector(15 downto 0) := (others => '0');
  signal AddressPlus : std_logic_vector(15 downto 0) := (others => '0');
begin

  UpdatePc : process(Clk)
  begin
    if rising_edge(Clk) then
      if PcEnable = '1' then
        if Jump = '1' then
          Address <= AddrCalc;
        else
          Address <= AddressPlus;
        end if;
      end if;
    end if;
  end process UpdatePc;

  AddressPlus <= (std_logic_vector(to_unsigned(to_integer(unsigned(Address)) + 2, 16)));
  Addr        <= Address;

end Implementation;
