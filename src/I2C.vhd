-- I2C.vhd
-- Date:   Wed Jan 31 13:05:40 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity I2C is
  port (
    Clk     : in  std_logic;
    SDA_In  : in  std_logic;
    SCL_In  : in  std_logic;
    ClientR : in  std_logic_vector(15 downto 0);
    ServerR : in  std_logic_vector(15 downto 0);
    SDA_Out : out std_logic;
    SCL_Out : out std_logic;
    ClientW : out std_logic_vector(15 downto 0)
    );
end I2C;

architecture Implementation of I2C is
  signal Clk100k       : std_logic                     := '0';
  signal Clk100Counter : std_logic_vector(10 downto 0) := (others => '0');
  signal PackageReg    : std_logic_vector(11 downto 0) := (others => '0');
begin

  ClkSplit100k : process(Clk)
  begin
    if rising_edge(Clk) then
      if unsigned(Clk100Counter) >= 500 then
        Clk100Counter <= (others => '0');
        Clk100k       <= not Clk100k;
      else
        Clk100Counter <= std_logic_vector(unsigned(Clk100Counter) + 1);
      end if;
    end if;
  end process ClkSplit100k;

end Implementation;
