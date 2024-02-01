-- ProgramMemory.vhd
-- Date:   Tue Jan 30 17:01:12 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramMemory is
  port(
    Clk         : in  std_logic;
    InstrAddr   : in  std_logic_vector(15 downto 0);
    Instruction : out std_logic_vector(15 downto 0);
    Immediate   : out std_logic_vector(15 downto 0)
    );
end ProgramMemory;

architecture Implementation of ProgramMemory is
  type MemoryType is array(0 to 65536) of std_logic_vector(15 downto 0);
  signal Memory : MemoryType := (
    b"1111000011110000",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"1111000011110000",
    b"1111000011110000",
    b"1111000011110000",
    b"1111000011110000",
    b"1111000011110000",
    b"1111000011110000",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    b"0000000000000000",
    b"0010010110100101",
    b"1110100011101101",
    b"1101000010011011",
    others => (others => '0'));
begin

  SynchronRead : process(Clk)
  begin

    if rising_edge(Clk) then
      Instruction <= Memory(to_integer(unsigned(InstrAddr)));
      Immediate   <= Memory(to_integer(unsigned(InstrAddr) + 1));
    end if;

  end process SynchronRead;

end Implementation;
