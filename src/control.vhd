-- control.vhd
-- Date:   Wed Jan 31 17:41:32 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control is
  port (
    Clk         : in  std_logic;
    Instruction : in  std_logic_vector(15 downto 0);
    JumpSuggest : in  std_logic;
    EnablePC    : out std_logic;
    EnableReg   : out std_logic;
    EnableRam   : out std_logic;
    EnableRegs  : out std_logic;
    EnableJump  : out std_logic;
    StateOut    : out std_logic_vector(2 downto 0)
    );
end Control;

architecture Implementation of Control is
  signal State     : std_logic_vector(2 downto 0) := (others => '0');
  signal CouldJump : std_logic                    := '0';
begin

  StateInterator : process(Clk)
  begin
    if rising_edge(Clk) then
      case State is
        when "000" | "101" => State <= "001";  -- Init / Write Back
        when "001"         => State <= "010";  -- Instruction Fetch
        when "010"         => State <= "011";  -- Decode
        when "011"         => State <= "100";  -- Operand Fetch
        when "100"         => State <= "101";  -- Execute
        when others        => State <= "000";  -- ERROR
      end case;
    end if;
  end process StateInterator;

  SetEnableSignals : process(Instruction(3 downto 0), State)
  begin
    case State is
      when "101" =>

        EnablePC <= '1';

        case Instruction(3 downto 0) is
          when "0000" | "0001" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" | "1001" | "1010" | "1011" =>
            EnableRam  <= '0';
            CouldJump  <= '0';
            EnableRegs <= '1';
          when "1100" =>
            EnableRam  <= '1';
            CouldJump  <= '0';
            EnableRegs <= '0';
          when "1110" =>
            EnableRam  <= '0';
            CouldJump  <= '1';
            EnableRegs <= '0';
          when others =>
            EnableRam  <= '0';
            CouldJump  <= '0';
            EnableRegs <= '0';
        end case;
      when others =>
        EnablePC   <= '0';
        EnableRam  <= '0';
        CouldJump  <= '0';
        EnableRegs <= '0';
    end case;
  end process SetEnableSignals;

  EnableJump <= CouldJump and JumpSuggest;

  StateOut <= State;

end Implementation;
