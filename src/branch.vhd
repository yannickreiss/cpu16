-- branch.vhd
-- Date:   Thu Feb  1 06:03:29 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Branch is
  port (
    BranchEnable : in  std_logic;
    AluResult    : in  std_logic_vector(15 downto 0);
    PC           : in  std_logic_vector(15 downto 0);
    PMNext       : in  std_logic_vector(15 downto 0);
    JumpSuggest  : out std_logic;
    PCCalc       : out std_logic_vector(15 downto 0)
    );
end Branch;

architecture Implementation of Branch is

begin

  PCCalc      <= std_logic_vector(signed(PC) + signed(PMNext));
  JumpSuggest <= BranchEnable and AluResult(0);

end Implementation;
