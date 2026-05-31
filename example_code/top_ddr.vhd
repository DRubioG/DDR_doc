library IEEE;
use IEEE.STD_LOGIC_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity top_ddr is
  port (
    CLK_P_I : in std_logic;
    CLK_N_I : in std_logic;
    RST_N_I : in std_logic;

    -- DDR
    DDR4_ADR_O       : out std_logic_vector(16 downto 0);
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
end top_ddr;

architecture Behavioral of top_ddr is
  signal s_clk               : std_logic;
  signal s_rst_n             : std_logic;
  signal s_ddr_en            : std_logic;
  signal s_calib_complete    : std_logic;
  signal s_ddr_addr          : std_logic_vector(28 downto 0);
  signal s_ddr_cmd           : std_logic_vector(2 downto 0);
  signal s_ddr_wren          : std_logic;
  signal s_ddr_wrend         : std_logic;
  signal s_ddr_wr_rdy        : std_logic;
  signal s_ddr_wr_data       : std_logic_vector(511 downto 0);
  signal s_ddr_rdy           : std_logic;
  signal s_ddr_rdend         : std_logic;
  signal s_ddr_rd_data_valid : std_logic;
  signal s_ddr_rd_data       : std_logic_vector(511 downto 0);

  signal s_clk_in, s_clk_bufg : std_logic;

begin

  impl_data_creator : entity work.data_creator
    port map
    (
      CLK_I            => s_clk,
      RST_N_I          => s_rst_n,
      EN_DDR_O         => s_ddr_en,
      DDR_RDY_I        => s_ddr_rdy,
      CALIB_COMPLETE_I => s_calib_complete,
      DDR_ADDR_O       => s_ddr_addr,
      DDR_CMD_O        => s_ddr_cmd,
      -- write
      DDR_WREN_O    => s_ddr_wren,
      DDR_WREND_O   => s_ddr_wrend,
      DDR_WR_RDY_I  => s_ddr_wr_rdy,
      DDR_WR_DATA_O => s_ddr_wr_data,
      --read
      DDR_RDEND_I         => s_ddr_rdend,
      DDR_RD_DATA_VALID_I => s_ddr_rd_data_valid,
      DDR_RD_DATA_I       => s_ddr_rd_data
    );

  impl_IBUFDS : IBUFDS
  generic map(
    DIFF_TERM    => FALSE, -- Differential Termination
    IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
    IOSTANDARD   => "DEFAULT")
  port map
  (
    O  => s_clk_bufg, -- Buffer output
    I  => CLK_P_I, -- Diff_p buffer input (connect directly to top-level port)
    IB => CLK_N_I -- Diff_n buffer input (connect directly to top-level port)
  );
  impl_BUFG : BUFG
  port map
  (
    I => s_clk_bufg,
    O => s_clk_in
  );

  impl_ddr4 : entity work.ddr4
    port map
    (
      CLK_I   => s_clk_in,
      RST_N_I => RST_N_I,
      -- internal ports
      CLK_DDR_O        => s_clk,
      RST_O            => s_rst_n,
      DDR_EN_I         => s_ddr_en,
      DDR_RDY_O        => s_ddr_rdy,
      CALIB_COMPLETE_O => s_calib_complete,
      DDR_ADDR_I       => s_ddr_addr,
      DDR_CMD_I        => s_ddr_cmd,
      -- write
      DDR_WREN_I    => s_ddr_wren,
      DDR_WREND_I   => s_ddr_wrend,
      DDR_WR_RDY_O  => s_ddr_wr_rdy,
      DDR_WR_DATA_I => s_ddr_wr_data,
      --read
      DDR_RD_END_O        => s_ddr_rdend,
      DDR_RD_DATA_VALID_O => s_ddr_rd_data_valid,
      DDR_RD_DATA_O       => s_ddr_rd_data,

      -- external ddr ports
      DDR4_ADR         => DDR4_ADR_O,
      DDR4_BA_O        => DDR4_BA_O,
      DDR4_ACT_N_O     => DDR4_ACT_N_O,
      DDR4_BG_O        => DDR4_BG_O,
      DDR4_CKE_O       => DDR4_CKE_O,
      DDR4_ODT_O       => DDR4_ODT_O,
      DDR4_CS_N_O      => DDR4_CS_N_O,
      DDR4_CK_C_O      => DDR4_CK_C_O,
      DDR4_CK_T_O      => DDR4_CK_T_O,
      DDR4_RESET_N_O   => DDR4_RESET_N_O,
      DDR4_DM_DBI_N_IO => DDR4_DM_DBI_N_IO,
      DDR4_DQ_IO       => DDR4_DQ_IO,
      DDR4_DQS_C_IO    => DDR4_DQS_C_IO,
      DDR4_DQS_T_IO    => DDR4_DQS_T_IO
    );
end Behavioral;
