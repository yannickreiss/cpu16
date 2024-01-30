-- alu.vhd
-- Date:   Tue Jan 30 10:02:24 2024
-- Author:    Yannick Reiß
-- E-Mail:    yannick.reiss@protonmail.ch
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Alu is
  port (
    alu_op : in  std_logic_vector(3 downto 0);
    input1 : in  std_logic_vector(15 downto 0);
    input2 : in  std_logic_vector(15 downto 0);
    result : out std_logic_vector(15 downto 0)
    );
end Alu;

architecture Implementation of Alu is

begin
  Alu_logic : process(alu_op, input1, input2)
  begin
    case alu_op is
      when "0000" => result <= std_logic_vector(unsigned(input1) + unsigned(input2));
-- ADD
      when "0010" => result <= std_logic_vector(signed(input1) - signed(input2));
-- SUB
      when "0011" => result <= std_logic_vector(unsigned(input1) sll to_integer(unsigned(input2)));
-- SLL
      when "0100" =>
        if (signed(input1) < signed(input2)) then
          result <= std_logic_vector(to_unsigned(1, 16));
        else
          result <= std_logic_vector(to_unsigned(0, 16));
        end if;  -- SLT
      when "0101" =>
        if (unsigned(input1) < unsigned(input2)) then
          result <= std_logic_vector(to_unsigned(1, 16));
        else
          result <= std_logic_vector(to_unsigned(0, 16));
        end if;  -- SLTU
      when "0110" => result <= input1 xor input2;  -- XOR
      when "0111" => result <= std_logic_vector(unsigned(input1) srl to_integer(unsigned(input2)));
-- SRL
      when "1000" => result <= std_logic_vector(signed(input1) sra to_integer(unsigned(input2)));
-- SRA
      when "1010" => result <= input1 or input2;   -- OR
      when "1011" => result <= input1 and input2;  -- AND
      when others => result <= std_logic_vector(to_unsigned(0, 16));
    end case;
  end process Alu_logic;

end Implementation;
