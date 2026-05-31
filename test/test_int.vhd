
  entity ddr4_0 is
    port (
      c0_sys_clk_i              : in std_logic;
    --   ! @virtualbus DDR @dir out
    --   c0_init_calib_complete    : out std_logic;
    --   dbg_clk                   : out std_logic;
    --   dbg_bus                   : out std_logic_vector(511 downto 0);
    --   c0_ddr4_adr               : out std_logic_vector(16 downto 0);
    --   c0_ddr4_ba                : out std_logic_vector(1 downto 0);
    --   c0_ddr4_cke               : out std_logic;
    --   c0_ddr4_cs_n              : out std_logic;
    --   c0_ddr4_dm_dbi_n          : inout std_logic_vector(7 downto 0);
    --   c0_ddr4_dq                : inout std_logic_vector(63 downto 0);
    --   c0_ddr4_dqs_c             : inout std_logic_vector(7 downto 0);
    --   c0_ddr4_dqs_t             : inout std_logic_vector(7 downto 0);
    --   c0_ddr4_odt               : out std_logic;
    --   c0_ddr4_bg                : out std_logic;
    --   c0_ddr4_reset_n           : out std_logic;
    --   c0_ddr4_act_n             : out std_logic;
    --   c0_ddr4_ck_c              : out std_logic;
    --   c0_ddr4_ck_t              : out std_logic;


    -- ! @end
      c0_ddr4_ui_clk            : out std_logic;
      c0_ddr4_ui_clk_sync_rst   : out std_logic;
      c0_ddr4_app_en            : in std_logic;
      c0_ddr4_app_addr          : in std_logic_vector(28 downto 0);
      c0_ddr4_app_cmd           : in std_logic_vector(2 downto 0);
      c0_ddr4_app_rdy           : out std_logic;
      c0_ddr4_app_hi_pri        : in std_logic;

      c0_ddr4_app_wdf_end       : in std_logic;
      c0_ddr4_app_wdf_wren      : in std_logic;
      c0_ddr4_app_wdf_data      : in std_logic_vector(511 downto 0);
      c0_ddr4_app_wdf_rdy       : out std_logic;
          c0_ddr4_app_wdf_mask      : in std_logic_vector(63 downto 0);

    
      c0_ddr4_app_rd_data       : out std_logic_vector(511 downto 0);

      c0_ddr4_app_rd_data_end   : out std_logic;
      c0_ddr4_app_rd_data_valid : out std_logic;
      sys_rst                   : in std_logic
    );
  end entity;