-- cpu16.vhd
-- Date:   Tue Jan 30 15:19:09 2024
-- Author:    Yannick Reiß
-- E-Mail:    schnick@nickr.eu
library IEEE;
use IEEE.std_logic_1164.all;

-- TODO: Check I Type; Implement Load instructions
-- TODO: Connect Register Data in
-- TODO: Connect I2C
-- TODO: Add peripheral Memory block

entity Cpu16 is
  port (
    Clk      : in    std_logic;
    Switches : in    std_logic_vector(15 downto 0);
    SDA      : inout std_logic;
    SCL      : inout std_logic;
    LED      : out   std_logic_vector(15 downto 0);
    RGB      : out   std_logic_vector(5 downto 0);
    seg      : out   std_logic_vector(6 downto 0)
    );
end Cpu16;

architecture Implementation of Cpu16 is

  signal RamAddrA            : std_logic_vector(15 downto 0) := (others => '0');
  signal RamAddrB            : std_logic_vector(15 downto 0) := (others => '0');
  signal RamWriteEnable      : std_logic                     := '0';
  signal RamDataWrite        : std_logic_vector(15 downto 0) := (others => '0');
  signal RamReadA            : std_logic_vector(15 downto 0) := (others => '0');
  signal RamReadB            : std_logic_vector(15 downto 0) := (others => '0');
  signal AluOpcode           : std_logic_vector(3 downto 0)  := "1111";  -- Some nop operation
  signal AluIn1              : std_logic_vector(15 downto 0) := (others => '0');
  signal AluIn2              : std_logic_vector(15 downto 0) := (others => '0');
  signal AluResult           : std_logic_vector(15 downto 0) := (others => '0');
  signal RegisterWriteEnable : std_logic                     := '0';
  signal RegisterRegister1   : std_logic_vector(3 downto 0)  := (others => '0');
  signal RegisterRegister2   : std_logic_vector(3 downto 0)  := (others => '0');
  signal RegisterRegisterW   : std_logic_vector(3 downto 0)  := (others => '0');
  signal RegisterDataIn      : std_logic_vector(15 downto 0) := (others => '0');
  signal RegisterDataOut1    : std_logic_vector(15 downto 0) := (others => '0');
  signal RegisterDataOut2    : std_logic_vector(15 downto 0) := (others => '0');
  signal InstructionCounter  : std_logic_vector(15 downto 0) := (others => '0');
  signal RawInstruction      : std_logic_vector(15 downto 0) := (others => '0');
  signal DecoderRegOp1       : std_logic_vector(3 downto 0)  := (others => '0');
  signal DecoderRegOp2       : std_logic_vector(3 downto 0)  := (others => '0');
  signal DecoderRegWrite     : std_logic_vector(3 downto 0)  := (others => '0');
  signal NextInstruction     : std_logic_vector(15 downto 0) := (others => '0');
  signal ImmediateValue      : std_logic_vector(15 downto 0) := (others => '0');
  signal PcEnable            : std_logic                     := '0';
  signal Jump                : std_logic                     := '0';
  signal I2CClient           : std_logic_vector(15 downto 0) := (others => '0');
  signal I2CClientOut        : std_logic_vector(15 downto 0) := (others => '0');
  signal I2CServer           : std_logic_vector(15 downto 0) := (others => '0');
  signal PcAddrCalc          : std_logic_vector(15 downto 0) := (others => '0');
  signal BranchEnable        : std_logic                     := '0';
  signal JumpEnable          : std_logic                     := '0';
  signal State               : std_logic_vector(2 downto 0)  := (others => '0');
  signal UnconditionalJumpOp : std_logic                     := '0';
begin

  -- Include Entities
  Ramblock : entity work.Ram(Behavioral)
    port map(
      Clk          => Clk,
      AddrA        => AluResult,
      AddrB        => AluResult,
      WriteEnable  => RamWriteEnable,
      DataIn       => RegisterDataOut2,
      ReadA        => RamReadA,
      ReadB        => RamReadB,
      DirectIn     => Switches,
      DirectOut    => LED,
      I2CClientIn  => I2CClientOut,
      I2CClientOut => I2CClient,
      I2CServerOut => I2CServer
      );

  Alu : entity work.Alu(Implementation)
    port map(
      alu_op => AluOpcode,
      input1 => AluIn1,
      input2 => AluIn2,
      result => AluResult
      );

  Regs : entity work.Registerset(Implementation)
    port map(
      Clk         => Clk,
      WriteEnable => RegisterWriteEnable,
      Register1   => RegisterRegister1,
      Register2   => RegisterRegister2,
      RegisterW   => RegisterRegisterW,
      DataIn      => RegisterDataIn,
      DataOut1    => RegisterDataOut1,
      DataOut2    => RegisterDataOut2
      );

  Instructions : entity work.ProgramMemory(Implementation)
    port map(
      Clk         => Clk,
      InstrAddr   => InstructionCounter,
      Instruction => RawInstruction,
      Immediate   => NextInstruction
      );

  Decoder : entity work.Decoder(Implementation)
    port map(
      Instruction  => RawInstruction,
      AluOpcd      => AluOpcode,
      RegOp1       => RegisterRegister1,
      RegOp2       => RegisterRegister2,
      RegWrite     => RegisterRegisterW,
      BranchEnable => BranchEnable,
      UncondJump   => UnconditionalJumpOp
      );

  ImmUseless : entity work.Immediate(Implementation)
    port map(
      ImmIn  => NextInstruction,
      ImmOut => ImmediateValue
      );

  PC : entity work.ProgramCounter(Implementation)
    port map(
      Clk      => Clk,
      PcEnable => PcEnable,
      AddrCalc => PcAddrCalc,
      Jump     => JumpEnable,
      Addr     => InstructionCounter
      );

  I2C_Adapter : entity work.I2C(Implementation)
    port map(
      Clk     => Clk,
      SDA_In  => SDA,
      SCL_In  => SCL,
      ClientR => I2CClient,
      ServerR => I2CServer,
      SDA_Out => SDA,
      SCL_Out => SCL,
      ClientW => I2CClientOut
      );

  BranchEnabler : entity work.Branch(Implementation)
    port map(
      BranchEnable => BranchEnable,
      AluResult    => AluResult,
      PC           => InstructionCounter,
      PMNext       => NextInstruction,
      UncondJump   => UnconditionalJumpOp,
      JumpSuggest  => Jump,
      PCCalc       => PcAddrCalc
      );

  ControlHandler : entity work.Control(Implementation)
    port map(
      Clk         => Clk,
      Instruction => RawInstruction,
      JumpSuggest => Jump,
      EnablePC    => PcEnable,
      EnableRam   => RamWriteEnable,
      EnableRegs  => RegisterWriteEnable,
      EnableJump  => JumpEnable,
      StateOut    => State
      );

  AluSetInput : process(ImmediateValue, InstructionCounter,
                        RawInstruction(3 downto 0), RegisterDataOut1,
                        RegisterDataOut2)
  begin

    case RawInstruction(3 downto 0) is
      when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" | "1010" | "1110" => AluIn1 <= RegisterDataOut1;
                                                                                                      AluIn2 <= RegisterDataOut2;
      when "0001" | "1001" => AluIn1 <= RegisterDataOut1;
                              AluIn2 <= ImmediateValue;
      when others => AluIn1 <= InstructionCounter;
                     AluIn2 <= RegisterDataOut2;
    end case;
  end process AluSetInput;

  RegisterSetInput : process(AluResult, RamReadB, RawInstruction(3 downto 0),
                             RawInstruction(7 downto 5))
  begin
    case RawInstruction(3 downto 0) is
      when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" | "1010" | "1011" => RegisterDataIn <= AluResult;
      when "0001" | "1001" =>
        if RawInstruction(7 downto 5) = "001" then
          -- Those are Load instructions
          RegisterDataIn <= RamReadB;
        else
          RegisterDataIn <= AluResult;
        end if;
      when others => RegisterDataIn <= (others => '0');
    end case;
  end process RegisterSetInput;


  RGB <= State & State;
  Seg <= AluResult(12 downto 6);

end Implementation;
