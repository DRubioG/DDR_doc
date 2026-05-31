library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_test is
  generic (
    G_MEM_DATA_BITS : integer := 32; --external memory user interface data width
    G_ADDR_BITS     : integer := 23; --external memory user interface address width
    G_BUSRT_BITS    : integer := 10; --external memory user interface burst width
    G_BURST_SIZE    : integer := 128 --burst size
  );
  port (
    RST_I                 : in std_logic;
    MEM_CLK_I             : in std_logic; -- external memory controller user interface clock
    RD_BURST_REQ_O        : out std_logic; -- to external memory controller,send out a burst read request
    WR_BURST_REQ_O        : out std_logic; -- to external memory controller,send out a burst write request
    RD_BURST_LEN_O        : out std_logic_vector(G_BUSRT_BITS - 1 downto 0); -- to external memory controller,data length of the burst read request, not bytes
    WR_BURST_LEN_O        : out std_logic_vector(G_BUSRT_BITS - 1 downto 0); -- to external memory controller,data length of the burst write request, not bytes
    RD_BURST_ADDR_O       : out std_logic_vector(G_ADDR_BITS - 1 downto 0); -- to external memory controller,base address of the burst read request 
    WR_BURST_ADDR_O       : out std_logic_vector(G_ADDR_BITS - 1 downto 0); -- to external memory controller,base address of the burst write request 
    RD_BURST_DATA_VALID_I : in std_logic; -- from external memory controller,read data valid 
    WR_BURST_DATA_REQ_I   : in std_logic; -- from external memory controller,write data request ,before data 1 clock
    RD_BURST_DATA_I       : in std_logic_vector(G_MEM_DATA_BITS - 1 downto 0); -- from external memory controller,read request data
    WR_BURST_DATA_O       : out std_logic_vector(G_MEM_DATA_BITS - 1 downto 0); -- to external memory controller,write data
    RD_BURST_FINISH_I     : in std_logic; -- from external memory controller,burst read finish
    WR_BURST_FINISH_I     : in std_logic; -- from external memory controller,burst write finish
    ERROR_O               : out std_logic; -- test data error
    --output reg  [63:0]               error_cnt : in std_logic;                             -- test data error
    HEARTBEAT_O : out std_logic
  );
end entity;

architecture arch_mem_test of mem_test is
  component ila_0

    port (
      clk : in std_logic;

      probe0  : in std_logic;
      probe1  : in std_logic;
      probe2  : in std_logic_vector(9 downto 0);
      probe3  : in std_logic_vector(9 downto 0);
      probe4  : in std_logic_vector(23 downto 0);
      probe5  : in std_logic_vector(23 downto 0);
      probe6  : in std_logic;
      probe7  : in std_logic;
      probe8  : in std_logic_vector(63 downto 0);
      probe9  : in std_logic_vector(63 downto 0);
      probe10 : in std_logic;
      probe11 : in std_logic;
      probe12 : in std_logic
    );
  end component;
  type fsm is (
    SM_IDLE,
    SM_MEM_READ,
    SM_MEM_WRITE
  );
  signal re_state : fsm;

  constant C_ONE  : unsigned(511 downto 0) := (0 => '1', others => '0'); --512'd1; --512 bit '1' , ONE[n-1:0] for n bit '1'
  constant C_ZERO : unsigned(511 downto 0) := (others => '0'); --512 bit '0'

  signal r_wr_cnt             : unsigned(G_BUSRT_BITS - 1 downto 0); --write data counter for once burst 
  signal r_rd_cnt             : unsigned(G_BUSRT_BITS - 1 downto 0); --read data counter for once burst
  signal r_heartbeat_cnt      : unsigned(31 downto 0); --heartbeat counter
  signal r_test_cnt           : unsigned(15 downto 0);
  -- signal test_cnt_512b      : unsigned(511 downto 0);
  signal r_wr_burst_addr_512b : unsigned(511 downto 0);
  signal r_rd_burst_addr_512b : unsigned(511 downto 0);
  signal r_next_wr_burst_addr : unsigned(G_ADDR_BITS - 1 downto 0); --next burst write address
  signal r_next_rd_burst_addr : unsigned(G_ADDR_BITS - 1 downto 0); --next burst read address
  signal r_wr_data_pre_add    : unsigned(15 downto 0);
  signal r_rd_data_pre_add    : unsigned(15 downto 0);
  signal r_next_wr_burst_data : unsigned(511 downto 0);
  signal r_expect_read_data   : unsigned(511 downto 0);

begin
  your_instance_name : ila_0
  port map
  (
    clk     => MEM_CLK_I, -- input wire clk
    probe0  => RD_BURST_REQ_O, -- input wire [0:0]  probe0  
    probe1  => WR_BURST_REQ_O, -- input wire [0:0]  probe1 
    probe2  => RD_BURST_LEN_O, -- input wire [9:0]  probe2 
    probe3  => WR_BURST_LEN_O, -- input wire [9:0]  probe3 
    probe4  => RD_BURST_ADDR_O, -- input wire [23:0]  probe4 
    probe5  => WR_BURST_ADDR_O, -- input wire [23:0]  probe5 
    probe6  => RD_BURST_DATA_VALID_I, -- input wire [0:0]  probe6 
    probe7  => WR_BURST_DATA_REQ_I, -- input wire [0:0]  probe7 
    probe8  => RD_BURST_DATA_I, -- input wire [63:0]  probe8 
    probe9  => WR_BURST_DATA_O, -- input wire [63:0]  probe9 
    probe10 => RD_BURST_FINISH_I, -- input wire [0:0]  probe10 
    probe11 => WR_BURST_FINISH_I, -- input wire [0:0]  probe11 
    probe12 => ERROR_O -- input wire [0:0]  probe12
  );
  r_next_wr_burst_data <= r_wr_data_pre_add;
  r_expect_read_data   <= r_wr_data_pre_add;

  -- test_cnt_512b <= ZERO(495 downto 0) & test_cnt; --{496'd0,test_cnt};
  r_wr_burst_addr_512b <= C_ZERO((511 - G_ADDR_BITS) downto 0) & unsigned(WR_BURST_ADDR_O);
  r_rd_burst_addr_512b <= C_ZERO((511 - G_ADDR_BITS) downto 0) & unsigned(RD_BURST_ADDR_O);

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      ERROR_O <= '0';
    elsif rising_edge(MEM_CLK_I) then
      if re_state = SM_MEM_READ and RD_BURST_DATA_VALID_I = '1' and RD_BURST_DATA_I /= std_logic_vector(r_expect_read_data(G_MEM_DATA_BITS - 1 downto 0)) then
        ERROR_O <= '1';
      end if;
    end if;
  end process;

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      r_heartbeat_cnt <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      if RD_BURST_DATA_VALID_I = '1' or WR_BURST_DATA_REQ_I = '1' then
        r_heartbeat_cnt <= (others => '0') when r_heartbeat_cnt > (r_heartbeat_cnt'range => '1') else
          r_heartbeat_cnt + 1;
      end if;
    end if;
  end process;

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      HEARTBEAT_O <= '0';
    elsif rising_edge(MEM_CLK_I) then
      HEARTBEAT_O <= not HEARTBEAT_O;
    end if;
  end process;

  r_wr_data_pre_add <= r_wr_burst_addr_512b(15 downto 0) + r_test_cnt + (x"00" & r_wr_cnt(7 downto 0));
  r_rd_data_pre_add <= r_rd_burst_addr_512b(15 downto 0) + r_test_cnt + (x"00" & r_rd_cnt(7 downto 0));
  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      WR_BURST_DATA_O <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      if WR_BURST_DATA_REQ_I = '1' then
        WR_BURST_DATA_O <= std_logic_vector(r_next_wr_burst_data(G_MEM_DATA_BITS - 1 downto 0));
      end if;
    end if;
  end process;

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      r_next_wr_burst_addr <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      r_next_wr_burst_addr <= unsigned(WR_BURST_ADDR_O) + to_unsigned(G_BURST_SIZE, r_next_wr_burst_addr'length);
    end if;
  end process;

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      r_next_rd_burst_addr <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      r_next_rd_burst_addr <= unsigned(RD_BURST_ADDR_O) + to_unsigned(G_BURST_SIZE, r_next_rd_burst_addr'length);
    end if;
  end process;

  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      r_wr_cnt <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      if re_state = SM_MEM_WRITE then
        if WR_BURST_DATA_REQ_I = '1' then
          r_wr_cnt <= r_wr_cnt + C_ONE; --wr_cnt <= wr_cnt + 1;
        elsif WR_BURST_FINISH_I = '1' then
          r_wr_cnt <= (others => '0'); -- wr_cnt <= 0;
        end if;
      end if;
    end if;
  end process;
  process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      r_rd_cnt <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      if re_state = SM_MEM_READ then
        if RD_BURST_DATA_VALID_I = '1' then
          r_rd_cnt <= r_rd_cnt + C_ONE;
        elsif RD_BURST_FINISH_I = '1' then
          r_rd_cnt <= (others => '0');
        end if;
      else
        r_rd_cnt <= (others => '0');
      end if;
    end if;
  end process;
  FSM_PROCESS : process (MEM_CLK_I, RST_I)
  begin
    if RST_I = '1' then
      re_state         <= SM_IDLE;
      WR_BURST_REQ_O  <= '0';
      RD_BURST_REQ_O  <= '0';
      RD_BURST_LEN_O  <= std_logic_vector(to_unsigned(G_BURST_SIZE, RD_BURST_LEN_O'length));
      WR_BURST_LEN_O  <= std_logic_vector(to_unsigned(G_BURST_SIZE, WR_BURST_LEN_O'length));
      RD_BURST_ADDR_O <= (others => '0'); -- rd_burst_addr <= 0;
      WR_BURST_ADDR_O <= (others => '0'); -- wr_burst_addr <= 0
      r_test_cnt      <= (others => '0');
    elsif rising_edge(MEM_CLK_I) then
      case re_state is
        when SM_IDLE =>
          re_state        <= SM_MEM_WRITE;
          WR_BURST_REQ_O <= '1';
          WR_BURST_LEN_O <= std_logic_vector(to_unsigned(G_BURST_SIZE, WR_BURST_LEN_O'length));
          r_test_cnt     <= (others => '0');

        when SM_MEM_WRITE =>
          if WR_BURST_FINISH_I = '1' then
            WR_BURST_ADDR_O <= std_logic_vector(r_next_wr_burst_addr);
            if r_next_wr_burst_addr = (r_next_wr_burst_addr'range => '0') then
              re_state         <= SM_MEM_READ;
              WR_BURST_REQ_O  <= '0';
              RD_BURST_REQ_O  <= '1';
              RD_BURST_ADDR_O <= (others => '0');
            else
              WR_BURST_REQ_O <= '1';
            end if;
            RD_BURST_LEN_O <= std_logic_vector(to_unsigned(G_BURST_SIZE, RD_BURST_LEN_O'length));
          end if;

        when SM_MEM_READ =>
          if RD_BURST_DATA_VALID_I = '1' then
            RD_BURST_REQ_O <= '0';
            if RD_BURST_FINISH_I = '1' then
              RD_BURST_ADDR_O <= std_logic_vector(unsigned(RD_BURST_ADDR_O) + to_unsigned(G_BURST_SIZE, RD_BURST_ADDR_O'length));
              if r_next_rd_burst_addr = (r_next_rd_burst_addr'range => '0') then
                re_state         <= SM_MEM_WRITE;
                r_test_cnt      <= r_test_cnt + 1;
                WR_BURST_REQ_O  <= '1';
                WR_BURST_LEN_O  <= std_logic_vector(to_unsigned(G_BURST_SIZE, WR_BURST_LEN_O'length));
                WR_BURST_ADDR_O <= (others => '0');
              else
                RD_BURST_REQ_O <= '1';
                RD_BURST_LEN_O <= std_logic_vector(to_unsigned(G_BURST_SIZE, RD_BURST_LEN_O'length));
              end if;
            end if;
          end if;

        when others =>
          re_state <= SM_IDLE;
      end case;
    end if;
  end process;

end architecture;