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
    SDL_In  : in  std_logic;
    ClientR : in  std_logic_vector(15 downto 0);
    ServerR : in  std_logic_vector(15 downto 0);
    SDA_Out : out std_logic;
    SDL_Out : out std_logic;
    ClientW : out std_logic_vector(15 downto 0)
    );
end I2C;

architecture Implementation of I2C is

begin

end Implementation;
