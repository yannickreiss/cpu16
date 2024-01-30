-- Immediate.vhd
-- Date:   Tue Jan 30 20:04:49 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;

entity Immediate is
  port (
    ImmIn  : in  std_logic_vector(15 downto 0);
    ImmOut : out std_logic_vector(15 downto 0)
    );
end Immediate;

architecture Implementation of Immediate is

begin
  ImmOut <= ImmIn;
end Implementation;
