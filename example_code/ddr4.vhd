library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ddr4 is
  port (
    CLK_I   : in std_logic;
    RST_N_I : in std_logic;
    -- internal ports
    CLK_DDR_O        : out std_logic;
    RST_O            : out std_logic;
    DDR_EN_I         : in std_logic;
    DDR_RDY_O        : out std_logic;
    CALIB_COMPLETE_O : out std_logic;
    DDR_ADDR_I       : in std_logic_vector(28 downto 0);
    DDR_CMD_I        : in std_logic_vector(2 downto 0);
    -- write
    DDR_WREN_I    : in std_logic;
    DDR_WREND_I   : in std_logic;
    DDR_WR_RDY_O  : out std_logic;
    DDR_WR_DATA_I : in std_logic_vector(511 downto 0);
    --read
    DDR_RD_DATA_VALID_O : out std_logic;
    DDR_RD_END_O        : out std_logic;
    DDR_RD_DATA_O       : out std_logic_vector(511 downto 0);

    -- external ddr ports
    DDR4_ADR         : out std_logic_vector(16 downto 0);
    DDR4_BA_O        : out std_logic_vector(1 downto 0);
    DDR4_ACT_N_O     : out std_logic;
    DDR4_BG_O        : out std_logic;
    DDR4_CKE_O       : out std_logic;
    DDR4_ODT_O       : out std_logic;
    DDR4_CS_N_O      : out std_logic;
    DDR4_CK_C_O      : out std_logic;
    DDR4_CK_T_O      : out std_logic;
    DDR4_RESET_N_O   : out std_logic;
    DDR4_DM_DBI_N_IO : inout std_logic_vector(7 downto 0);
    DDR4_DQ_IO       : inout std_logic_vector(63 downto 0);
    DDR4_DQS_C_IO    : inout std_logic_vector(7 downto 0);
    DDR4_DQS_T_IO    : inout std_logic_vector(7 downto 0)
  );
end ddr4;

architecture Behavioral of ddr4 is

  component ddr4_0
    port (
      c0_init_calib_complete    : out std_logic;
      dbg_clk                   : out std_logic;
      c0_sys_clk_i              : in std_logic;
      dbg_bus                   : out std_logic_vector(511 downto 0);
      c0_ddr4_adr               : out std_logic_vector(16 downto 0);
      c0_ddr4_ba                : out std_logic_vector(1 downto 0);
      c0_ddr4_cke               : out std_logic;
      c0_ddr4_cs_n              : out std_logic;
      c0_ddr4_dm_dbi_n          : inout std_logic_vector(7 downto 0);
      c0_ddr4_dq                : inout std_logic_vector(63 downto 0);
      c0_ddr4_dqs_c             : inout std_logic_vector(7 downto 0);
      c0_ddr4_dqs_t             : inout std_logic_vector(7 downto 0);
      c0_ddr4_odt               : out std_logic;
      c0_ddr4_bg                : out std_logic;
      c0_ddr4_reset_n           : out std_logic;
      c0_ddr4_act_n             : out std_logic;
      c0_ddr4_ck_c              : out std_logic;
      c0_ddr4_ck_t              : out std_logic;
      c0_ddr4_ui_clk            : out std_logic;
      c0_ddr4_ui_clk_sync_rst   : out std_logic;
      c0_ddr4_app_en            : in std_logic;
      c0_ddr4_app_hi_pri        : in std_logic;
      c0_ddr4_app_wdf_end       : in std_logic;
      c0_ddr4_app_wdf_wren      : in std_logic;
      c0_ddr4_app_rd_data_end   : out std_logic;
      c0_ddr4_app_rd_data_valid : out std_logic;
      c0_ddr4_app_rdy           : out std_logic;
      c0_ddr4_app_wdf_rdy       : out std_logic;
      c0_ddr4_app_addr          : in std_logic_vector(28 downto 0);
      c0_ddr4_app_cmd           : in std_logic_vector(2 downto 0);
      c0_ddr4_app_wdf_data      : in std_logic_vector(511 downto 0);
      c0_ddr4_app_wdf_mask      : in std_logic_vector(63 downto 0);
      c0_ddr4_app_rd_data       : out std_logic_vector(511 downto 0);
      sys_rst                   : in std_logic
    );
  end component;

  signal s_rst : std_logic;

begin

  s_rst <= not RST_N_I;

  ddr4 : ddr4_0
  port map
  (
    c0_init_calib_complete    => CALIB_COMPLETE_O,
    dbg_clk                   => open,
    c0_sys_clk_i              => CLK_I,
    dbg_bus                   => open,
    c0_ddr4_adr               => DDR4_ADR,
    c0_ddr4_ba                => DDR4_BA_O,
    c0_ddr4_cke               => DDR4_CKE_O,
    c0_ddr4_cs_n              => DDR4_CS_N_O,
    c0_ddr4_dm_dbi_n          => DDR4_DM_DBI_N_IO,
    c0_ddr4_dq                => DDR4_DQ_IO,
    c0_ddr4_dqs_c             => DDR4_DQS_C_IO,
    c0_ddr4_dqs_t             => DDR4_DQS_T_IO,
    c0_ddr4_odt               => DDR4_ODT_O,
    c0_ddr4_bg                => DDR4_BG_O,
    c0_ddr4_reset_n           => DDR4_RESET_N_O,
    c0_ddr4_act_n             => DDR4_ACT_N_O,
    c0_ddr4_ck_c              => DDR4_CK_C_O,
    c0_ddr4_ck_t              => DDR4_CK_T_O,

    c0_ddr4_ui_clk            => CLK_DDR_O,
    c0_ddr4_ui_clk_sync_rst   => RST_O,
    c0_ddr4_app_en            => DDR_EN_I,
    c0_ddr4_app_hi_pri        => '0',
    c0_ddr4_app_wdf_end       => DDR_WREND_I,
    c0_ddr4_app_wdf_wren      => DDR_WREN_I,
    c0_ddr4_app_rd_data_end   => DDR_RD_END_O,
    c0_ddr4_app_rd_data_valid => DDR_RD_DATA_VALID_O,
    c0_ddr4_app_rdy           => DDR_RDY_O,
    c0_ddr4_app_wdf_rdy       => DDR_WR_RDY_O,
    c0_ddr4_app_addr          => DDR_ADDR_I,
    c0_ddr4_app_cmd           => DDR_CMD_I,
    c0_ddr4_app_wdf_data      => DDR_WR_DATA_I,
    c0_ddr4_app_wdf_mask      => (others => '0'),
    c0_ddr4_app_rd_data       => DDR_RD_DATA_O,
    sys_rst                   => s_rst
  );

end Behavioral;
