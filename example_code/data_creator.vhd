library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity data_creator is
  port (
    CLK_I            : in std_logic;
    RST_N_I          : in std_logic;
    EN_DDR_O         : out std_logic;
    DDR_RDY_I        : in std_logic;
    CALIB_COMPLETE_I : in std_logic;
    DDR_ADDR_O       : out std_logic_vector(28 downto 0);
    DDR_CMD_O        : out std_logic_vector(2 downto 0);
    -- write
    DDR_WREN_O    : out std_logic;
    DDR_WREND_O   : out std_logic;
    DDR_WR_RDY_I  : in std_logic;
    DDR_WR_DATA_O : out std_logic_vector(511 downto 0);
    --read
    DDR_RD_DATA_VALID_I : in std_logic;
    DDR_RDEND_I         : in std_logic;
    DDR_RD_DATA_I       : in std_logic_vector(511 downto 0)
  );
end data_creator;

architecture Behavioral of data_creator is

  --type fsm is (IDLE, WRITE, WRITE_DONE, READ, READ_DONE);
  type fsm is (
    SM_IDLE,
    SM_WRITE,
    SM_WRITE_END,
    SM_READ,
    SM_READ_END
  );
  signal re_state : fsm;

  

  component ila_0

    port (
      clk : in std_logic;

      probe0 : in std_logic_vector(15 downto 0);
      probe1 : in std_logic_vector(28 downto 0);
      probe2 : in std_logic_vector(2 downto 0);
      probe3 : in std_logic;
      probe4 : in std_logic_vector(15 downto 0);
      probe5 : in std_logic_vector(28 downto 0)
    );
  end component;
  
  constant C_READ_COMMAND     : std_logic_vector(DDR_CMD_O'range) := (0 => '1', others => '0');
  constant C_WRITE_COMMAND    : std_logic_vector(DDR_CMD_O'range) := (others => '0');

  constant C_CYCLES : integer := 1000;
  signal r_cont     : integer range 0 to C_CYCLES;
    

  signal s_DDR_WR_DATA_O : std_logic_vector(DDR_WR_DATA_O'range);
  signal s_DDR_ADDR_O : std_logic_vector(DDR_ADDR_O'range);
  signal s_DDR_CMD_O : std_logic_vector(DDR_CMD_O'range);

begin

  your_instance_name : ila_0
  port map
  (
    clk => CLK_I,

    probe0 => s_DDR_WR_DATA_O(15 downto 0),
    probe1 => s_DDR_ADDR_O,
    probe2 => s_DDR_CMD_O,
    probe3 => DDR_RDY_I,
    probe4 => DDR_RD_DATA_I(15 downto 0),
    probe5 => std_logic_vector(to_unsigned(r_cont, 29))
  );

  
  FSM_PROCESS : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '1' then
        re_state <= SM_IDLE;
      else
        case re_state is
          when SM_IDLE =>
            re_state <= SM_IDLE;
            if CALIB_COMPLETE_I = '1' then
              re_state <= SM_WRITE;
            end if;

          when SM_WRITE =>
            re_state <= SM_WRITE;
            if r_cont >= C_CYCLES - 1 then
              re_state <= SM_WRITE_END;
            end if;

          when SM_WRITE_END =>
            re_state <= SM_READ;

          when SM_READ =>
            re_state <= SM_READ;
            if r_cont >= C_CYCLES - 1 then
              re_state <= SM_READ_END;
            end if;

          when SM_READ_END =>
            re_state <= SM_IDLE;

          when others =>
            re_state <= SM_IDLE;
        end case;
      end if;
    end if;
  end process;

  COMMAND_PROCESS : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        s_DDR_CMD_O <= C_WRITE_COMMAND;
      else
        if re_state = SM_IDLE then
          s_DDR_CMD_O <= C_WRITE_COMMAND;

        elsif re_state = SM_WRITE or re_state = SM_WRITE_END then
          s_DDR_CMD_O <= C_WRITE_COMMAND;

        elsif re_state = SM_READ or re_state = SM_READ_END then
          s_DDR_CMD_O <= C_READ_COMMAND;

        end if;
      end if;
    end if;
  end process;

  ADDRESS_PROCESS : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        s_DDR_ADDR_O <= (others => '0');
      else
        s_DDR_ADDR_O <= (others => '0');

        if re_state = SM_WRITE then
          if DDR_WR_RDY_I = '1' then
            if DDR_RDY_I = '1' then
              s_DDR_ADDR_O <= std_logic_vector(to_unsigned(r_cont, s_DDR_ADDR_O'length ));
            end if;
          end if;

        elsif re_state = SM_READ then
          if DDR_RD_DATA_VALID_I = '1' then
            s_DDR_ADDR_O <= std_logic_vector(to_unsigned(r_cont, s_DDR_ADDR_O'length));
          end if;
        end if;

      end if;
    end if;
  end process;

  ENABLE_DDR : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        EN_DDR_O <= '0';
      else
        EN_DDR_O <= '0';
        if re_state = SM_READ or re_state = SM_WRITE then
          EN_DDR_O <= '1';
        end if;
      end if;
    end if;
  end process;

  WRITE_ENABLE_DDR : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        DDR_WREN_O <= '0';
      else
        DDR_WREN_O <= '0';
        if re_state = SM_WRITE then
          DDR_WREN_O <= '1';
        end if;
      end if;
    end if;
  end process;
  process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        DDR_WREND_O <= '0';
      else
        DDR_WREND_O <= '0';
        if re_state = SM_WRITE then
          if DDR_WR_RDY_I = '1' then
            DDR_WREND_O <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

WRITE_DATA_PROCESS : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '0' then
        s_DDR_WR_DATA_O <= (others => '0');
      else
        s_DDR_WR_DATA_O <= (others => '0');
        if re_state = SM_WRITE then
          if DDR_WR_RDY_I = '1' then
            s_DDR_WR_DATA_O <= std_logic_vector(to_unsigned(r_cont, s_DDR_WR_DATA_O'length));
          end if;
        end if;
      end if;
    end if;
  end process;

COUNTER_PROCESS : process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if RST_N_I = '1' then
        r_cont <= 0;
        
      else
        if re_state = SM_WRITE then
          if DDR_WR_RDY_I = '1'then
            r_cont <= r_cont + 8;
          end if;

        elsif re_state = SM_READ then
          if DDR_RD_DATA_VALID_I = '1'then
            r_cont <= r_cont + 8;
          end if;
        else
          r_cont <= 0;
        end if;
      end if;
    end if;
  end process;

end Behavioral;
