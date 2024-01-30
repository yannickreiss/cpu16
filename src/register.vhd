-- register.vhd
-- Date:   Tue Jan 30 14:47:16 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Registerset is
  port(
    Clk         : in  std_logic;
    WriteEnable : in  std_logic;
    Register1   : in  std_logic_vector(3 downto 0);
    Register2   : in  std_logic_vector(3 downto 0);
    RegisterW   : in  std_logic_vector(3 downto 0);
    DataIn      : in  std_logic_vector(15 downto 0);
    DataOut1    : out std_logic_vector(15 downto 0);
    DataOut2    : out std_logic_vector(15 downto 0)
    );
end Registerset;

architecture Implementation of Registerset is
  type RegisterBlock is array(0 to 15) of std_logic_vector(15 downto 0);
  signal Registers : RegisterBlock := (others => (others => '0'));

begin

  WriteRegister : process(Clk)
  begin

    if rising_edge(Clk) then
      if WriteEnable = '1' and unsigned(RegisterW) > 0 then
        Registers (to_integer(unsigned(RegisterW))) <= DataIn;
      end if;
    end if;
  end process WriteRegister;

  DataOut1 <= Registers(to_integer(unsigned(Register1)));
  DataOut2 <= Registers(to_integer(unsigned(Register2)));

end Implementation;
