-- ram.vhd
-- Date:   Tue Jan 30 12:26:41 2024
-- Author:    Yannick Reiß
-- E-Mail:    yannick.reiss@protonmail.ch
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ram is
  port(
    Clk          : in  std_logic;
    AddrA        : in  std_logic_vector(15 downto 0);
    AddrB        : in  std_logic_vector(15 downto 0);
    WriteEnable  : in  std_logic;
    DataIn       : in  std_logic_vector(15 downto 0);
    ReadA        : out std_logic_vector(15 downto 0);
    ReadB        : out std_logic_vector(15 downto 0);
    DirectIn     : in  std_logic_vector(15 downto 0);
    DirectOut    : out std_logic_vector(15 downto 0);
    I2CClientIn  : in  std_logic_vector(15 downto 0);
    I2CClientOut : out std_logic_vector(15 downto 0);
    I2CServerOut : out std_logic_vector(15 downto 0)
    );
end Ram;

architecture Behavioral of Ram is

  signal we1 : std_logic := '0';
  signal we2 : std_logic := '0';

  signal SReadA1 : std_logic_vector(15 downto 0) := (others => '0');
  signal SReadB1 : std_logic_vector(15 downto 0) := (others => '0');

  signal SReadA2 : std_logic_vector(15 downto 0) := (others => '0');
  signal SReadB2 : std_logic_vector(15 downto 0) := (others => '0');

  signal Mode1    : std_logic                     := '1';
  signal Mode2    : std_logic                     := '0';
  signal ZeroWord : std_logic_vector(15 downto 0) := (others => '0');

  signal BoardInput  : std_logic_vector(15 downto 0) := (others => '0');
  signal BoardOutput : std_logic_vector(15 downto 0) := (others => '0');

  signal I2CClient : std_logic_vector(15 downto 0) := (others => '0');
  signal I2CServer : std_logic_vector(15 downto 0) := (others => '0');
begin

  block1 : entity work.Ram_Block(Memory)
    port map(
      Clk         => Clk,
      WriteEnable => we1,
      AddrA       => AddrA(14 downto 0),
      AddrB       => AddrB(14 downto 0),
      Input       => DataIn,
      ReadA       => SReadA1,
      ReadB       => SReadB1
      );

  block2 : entity work.Ram_Block(Memory)
    port map(
      Clk         => Clk,
      WriteEnable => we2,
      AddrA       => AddrA(14 downto 0),
      AddrB       => AddrB(14 downto 0),
      Input       => DataIn,
      ReadA       => SReadA2,
      ReadB       => SReadB2
      );

  -- Set write enable
  we1 <= WriteEnable and not AddrA(15);
  we2 <= WriteEnable and AddrA(15);

  DirectIO : process(clk)
  begin

    if rising_edge(clk) then
      -- must be treated as register 
      BoardInput <= DirectIn;
      I2CClient  <= I2CClientIn;

      -- handle Directin
      if unsigned(AddrA) = 1 then
        ReadA <= BoardInput;
      else
        case AddrA(15) is
          when '1' =>
            ReadA <= SReadA2;
          when others => ReadA <= SReadA1;
        end case;
      end if;

      if unsigned(AddrB) = 1 then
        ReadB <= BoardInput;
      else
        case AddrB(15) is
          when '1' =>
            ReadB <= SReadB2;

          when others => ReadB <= SReadB1;
        end case;
      end if;

      -- handle Directout
      if unsigned(AddrB) = 2 and WriteEnable = '1' then
        BoardOutput <= DataIn;
      end if;

      -- handle I2CClient
      if unsigned(AddrA) = 3 then
        ReadA <= I2CClient;
      else
        case AddrA(15) is
          when '1' =>
            ReadA <= SReadA2;
          when others => ReadA <= SReadA1;
        end case;
      end if;

      if unsigned(AddrB) = 3 then
        ReadB <= I2CClient;
      else
        case AddrB(15) is
          when '1' =>
            ReadB <= SReadB2;

          when others => ReadB <= SReadB1;
        end case;
      end if;

      -- handle I2CClient
      if unsigned(AddrB) = 3 and WriteEnable = '1' then
        I2CClient <= DataIn;
      end if;

      -- handle I2CServer
      if unsigned(AddrA) = 4 then
        ReadA <= I2CServer;
      else
        case AddrA(15) is
          when '1' =>
            ReadA <= SReadA2;
          when others => ReadA <= SReadA1;
        end case;
      end if;

      if unsigned(AddrB) = 4 then
        ReadB <= I2CServer;
      else
        case AddrB(15) is
          when '1' =>
            ReadB <= SReadB2;

          when others => ReadB <= SReadB1;
        end case;
      end if;

    end if;
  end process DirectIO;

  DirectOut    <= BoardOutput;
  I2CClientOut <= I2CClient;
  I2CServerOut <= I2CServer;

end Behavioral;
