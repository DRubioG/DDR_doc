library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nereid_ddr3 is
  port (
    clk_in : in std_logic;

    -- DDR3 Physical Interface Signals
    --Inouts
    DDR3_DQ_IO  : inout std_logic_vector(15 downto 0);
    DDR3_DQS_N_IO  : inout std_logic_vector(1 downto 0);
    DDR3_DQS_P_IO  : inout std_logic_vector(1 downto 0);
    -- Outputs
    DDR3_ADDR_O  : out std_logic_vector(13 downto 0);
    DDR3_BA_O  : out std_logic_vector(2 downto 0);
    DDR3_RAS_N_O  : out std_logic;
    DDR3_CAS_N_O  : out std_logic;
    DDR3_WE_N_O  : out std_logic;
    DDR3_RESET_N_O  : out std_logic;
    DDR3_CK_P_O  : out std_logic;
    DDR3_CK_N_O  : out std_logic;
    DDR3_CKE_O  : out std_logic;
    DDR3_CS_N_O  : out std_logic;
    DDR3_DM_O  : out std_logic_vector(1 downto 0);
    DDR3_ODT_O  : out std_logic;

    -- LEDs to signal pass/fail
    LED_PASS_O  : out std_logic;
    LED_FAIL_O  : out std_logic;
    LED_CALIB_O  : out std_logic
  );
end entity nereid_ddr3;

architecture rtl of nereid_ddr3 is

  signal calib_done : std_logic;

  signal app_addr : std_logic_vector(27 downto 0) := (others => '0');
  signal app_cmd  : std_logic_vector(2 downto 0)  := (others => '0');
  signal app_en   : std_logic;
  signal app_rdy  : std_logic;

  signal app_wdf_data : std_logic_vector(127 downto 0);
  signal app_wdf_end  : std_logic := 1;
  signal app_wdf_wren : std_logic;
  signal app_wdf_rdy  : std_logic;

  signal app_rd_data : std_logic_vector(127 downto 0);
  signal app_wdf_mask : std_logic_vector(15 downto 0) = 0;
  signal app_rd_data_end   : std_logic;
  signal app_rd_data_valid : std_logic;

  signal app_sr_req    : std_logic := 0;
  signal app_ref_req   : std_logic := 0;
  signal app_zq_req    : std_logic := 0;
  signal app_sr_active : std_logic;
  signal app_ref_ack   : std_logic;
  signal app_zq_ack    : std_logic;

  signal ui_clk          : std_logic;
  signal ui_clk_sync_rst : std_logic;

  signal sys_clk_i : std_logic;

  constant data_to_write : std_logic_vector(127 downto 0) := (x"cafebabe", x"12345678", x"AA55AA55", x"55AA55AA");
  signal data_read_from_memory : std_logic_vector(127 downto 0) := (others => '0') ;

  -- Power-on-reset generator circuit.
  -- Asserts resetn for 1023 cycles, then deasserts
  -- `resetn` is Active low reset
  signal por_counter : std_logic := 1023;

  
  type fsm is (
    IDLE,
    WRITE,
    WRITE_DONE,
    READ,
    READ_DONE,
    PARK
  );
  signal state : fsm;

  constant CMD_WRITE : std_logic_vector(2 downto 0) := "000";
  constant CMD_READ  : std_logic_vector(2 downto 0) := "001";


  signal resetn : std_logic;
begin

  process (clk_in)
  begin
    if rising_edge(clk_in) then
      if por_counter = '1' then
        por_counter <= por_counter - 1;
      end if;
    end if;
  end process;
  resetn <= '1' when por_counter = 0 else
    '0';

  -- Clock Wizard
  -- DDR3 core requires 200MHz input clock
  -- We generate this clock using Xilinx Clocking Wizard IP Core
  clk_wiz : clk_wiz
  port map
  (
    clk_in (clk_in),
    clk_200 (sys_clk_i),
    resetn (resetn)
  );

  -- Instatiation of MIG core named `mem`
  mem : mem
  port map
  (
    -- DDR3 Physical interface ports
    DDR3_ADDR_O     => DDR3_ADDR_O ,
    DDR3_BA_O       => DDR3_BA_O ,
    DDR3_CAS_N_O    => DDR3_CAS_N_O ,
    DDR3_CK_N_O     => DDR3_CK_N_O ,
    DDR3_CK_P_O     => DDR3_CK_P_O ,
    DDR3_CKE_O      => DDR3_CKE_O ,
    DDR3_RAS_N_O    => DDR3_RAS_N_O ,
    DDR3_RESET_N_O  => DDR3_RESET_N_O ,
    DDR3_WE_N_O     => DDR3_WE_N_O ,
    DDR3_DQ_IO       => DDR3_DQ_IO ,
    DDR3_DQS_N_IO    => DDR3_DQS_N_IO ,
    DDR3_DQS_P_IO    => DDR3_DQS_P_IO ,
    DDR3_CS_N_O     => DDR3_CS_N_O ,
    DDR3_DM_O       => DDR3_DM_O ,
    DDR3_ODT_O      => DDR3_ODT_O ,

    init_calib_complete => calib_done,

    -- User interface ports
    app_addr          => app_addr,
    app_cmd           => app_cmd,
    app_en            => app_en,
    app_wdf_data      => app_wdf_data,
    app_wdf_end       => app_wdf_end,
    app_wdf_wren      => app_wdf_wren,
    app_rd_data       => app_rd_data,
    app_rd_data_end   => app_rd_data_end,
    app_rd_data_valid => app_rd_data_valid,
    app_rdy           => app_rdy,
    app_wdf_rdy       => app_wdf_rdy,
    app_sr_req        => app_sr_req,
    app_ref_req       => app_ref_req,
    app_zq_req        => app_zq_req,
    app_sr_active     => app_sr_active,
    app_ref_ack       => app_ref_ack,
    app_zq_ack        => app_zq_ack,
    ui_clk            => ui_clk,
    ui_clk_sync_rst   => ui_clk_sync_rst,
    app_wdf_mask      => app_wdf_mask,
    -- Clock and Reset input ports
    sys_clk_i => sys_clk_i,
    sys_rst   => resetn
  );

  LED_CALIB_O  <= not calib_done;

  process (ui_clk)
  begin
    if rising_edge(ui_clk) then
      if ui_clk_sync_rst = '1' then
        state        <= IDLE;
        app_en       <= 0;
        app_wdf_wren <= 0;
      else
        case state is
          when IDLE =>
            if calib_done = '1' then
              state <= WRITE;
            end if;

          when WRITE =>
            if app_rdy = '1' and app_wdf_rdy = '1' then
              state        <= WRITE_DONE;
              app_en       <= 1;
              app_wdf_wren <= 1;
              app_addr     <= 0;
              app_cmd      <= CMD_WRITE;
              app_wdf_data <= data_to_write;
            end if;

          when WRITE_DONE =>
            if app_rdy = '1' and app_en = '1' then
              app_en <= 0;
            end if;

            if app_wdf_rdy = '1' and app_wdf_wren = '1' then
              app_wdf_wren <= 0;
            end if;

            if app_en = '0' and app_wdf_wren = '0' then
              state <= READ;
            end if;
          when READ =>
            if app_rdy = '1' then
              app_en   <= 1;
              app_addr <= 0;
              app_cmd  <= CMD_READ;
              state    <= READ_DONE;
            end if;

          when READ_DONE =>
            if app_rdy = '1' and app_en = '1' then
              app_en <= 0;
            end if;

            if app_rd_data_valid = '1' then
              data_read_from_memory <= app_rd_data;
              state                 <= PARK;
            end if;
          when PARK =>
            if data_to_write = data_read_from_memory then
              LED_PASS_O  <= 0;
            else
              if data_to_write /= data_read_from_memory then
                LED_FAIL_O  <= 0;
              end if;
            when others =>
              state <= IDLE;
            end case;
        end if;
      end if;
    end process;

  end architecture;