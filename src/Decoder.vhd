-- Decoder.vhd
-- Date:   Tue Jan 30 17:10:48 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity decode: Decoder currently supporting read operations
entity Decoder is
  port(
    Instruction : in  std_logic_vector(15 downto 0);  -- Instruction from instruction memory
    AluOpcd     : out std_logic_vector(3 downto 0);  -- alu opcode
    RegOp1      : out std_logic_vector(3 downto 0);  -- Rj: first register to read
    RegOp2      : out std_logic_vector(3 downto 0);  -- Rk: second register to read
    RegWrite    : out std_logic_vector(3 downto 0)  -- Ri: the register to write to
    );
end Decoder;

architecture Implementation of Decoder is

begin

  Decode : process(Instruction(11 downto 8), Instruction(15 downto 12),
                   Instruction(3 downto 0), Instruction(7 downto 4))
  begin

    -- assign the alway same positions
    RegOp1   <= Instruction(11 downto 8);
    RegOp2   <= Instruction(7 downto 4);
    RegWrite <= Instruction(15 downto 12);

    -- Alu opcodes
    case Instruction(3 downto 0) is
      when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" | "1010" => AluOpcd <= Instruction(3 downto 0);  -- R-Types
      when "0001" | "1001"                                                                => AluOpcd <= Instruction(7 downto 4);  -- S-Types
      when "1110"                                                                         => AluOpcd <= Instruction(7 downto 4);  -- B-Types (to be debated)
      when others                                                                         => AluOpcd <= "1111";  -- if unsure, do nothing
    end case;
  end process Decode;

end Implementation;
