library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;
entity top is
  port (
    sys_clk_p        : in std_logic;
    sys_clk_n        : in std_logic;
    key1             : in std_logic;
    c0_ddr4_act_n    : out std_logic;
    c0_ddr4_adr      : out std_logic_vector(1 downto 0);
    c0_ddr4_ba       : out std_logic_vector(1 downto 0);
    c0_ddr4_bg       : out std_logic;
    c0_ddr4_cke      : out std_logic;
    c0_ddr4_odt      : out std_logic;
    c0_ddr4_cs_n     : out std_logic;
    c0_ddr4_ck_t     : out std_logic;
    c0_ddr4_ck_c     : out std_logic;
    c0_ddr4_reset_n  : out std_logic;
    c0_ddr4_dm_dbi_n : inout std_logic_vector(7 downto 0);
    c0_ddr4_dq       : inout std_logic_vector(63 downto 0);
    c0_ddr4_dqs_c    : inout std_logic_vector(7 downto 0);
    c0_ddr4_dqs_t    : inout std_logic_vector(7 downto 0)
  );
end entity top;

architecture rtl of top is

  signal sys_clk_buf, sys_clk : std_logic;

begin

  IBUFDS_inst : IBUFDS
  port map
  (
    O  => sys_clk_buf, -- Buffer output
    I  => sys_clk_p, -- Diff_p buffer input (connect directly to top-level port)
    IB => sys_clk_n -- Diff_n buffer input (connect directly to top-level port)
  );

  BUFG_inst : BUFG
  port map
  (
    O => sys_clk, -- 1-bit output: Clock output
    I => sys_clk_buf -- 1-bit input: Clock input
  );

  IDELAYCTRL_inst : IDELAYCTRL
  generic map(
    SIM_DEVICE => "ULTRASCALE" -- Must be set to "ULTRASCALE" 
  )
  port map
  (
    RDY    => open, -- 1-bit output: Ready output
    REFCLK => sys_clk, -- 1-bit input: Reference clock input
    RST    => not key1 -- 1-bit input: Active high reset input. Asynchronous assert, synchronous deassert to
    -- REFCLK.
  );
  ddr4_top_inst : entity work.ddr4_top
    port map
    (
      c0_ddr4_act_n          => c0_ddr4_act_n,
      c0_ddr4_adr            => c0_ddr4_adr,
      c0_ddr4_ba             => c0_ddr4_ba,
      c0_ddr4_bg             => c0_ddr4_bg,
      c0_ddr4_cke            => c0_ddr4_cke,
      c0_ddr4_odt            => c0_ddr4_odt,
      c0_ddr4_cs_n           => c0_ddr4_cs_n,
      c0_ddr4_ck_t           => c0_ddr4_ck_t,
      c0_ddr4_ck_c           => c0_ddr4_ck_c,
      c0_ddr4_reset_n        => c0_ddr4_reset_n,
      c0_ddr4_dm_dbi_n       => c0_ddr4_dm_dbi_n,
      c0_ddr4_dq             => c0_ddr4_dq,
      c0_ddr4_dqs_c          => c0_ddr4_dqs_c,
      c0_ddr4_dqs_t          => c0_ddr4_dqs_t,
      sys_clk                => sys_clk,
      error                  => open,
      c0_init_calib_complete => open,
      sys_rst                => not key1
    );
end architecture;