library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ddr4 is
    Port ( 
        clk_in : in std_logic;
        rst_n : in std_logic;
        -- internal ports
        clk_ddr_out : out std_logic;
        rst_out : out std_logic;
        ddr_en : in std_logic;
        ddr_rdy : out std_logic;
        calib_complete : out std_logic;
        ddr_addr : in std_logic_vector(28 downto 0);
        ddr_cmd : in std_logic_vector(2 downto 0);
        -- write
        ddr_wren : in std_logic;
        ddr_wrend : in std_logic;
        ddr_wr_rdy : out std_logic;
        ddr_wr_data : in std_logic_vector(511 downto 0);
        --read
        ddr_rd_data_valid : out std_logic;
        ddr_rdend : out std_logic;
        ddr_rd_data : out std_logic_vector(511 downto 0);
        
        -- external ddr ports
        ddr4_adr : out std_logic_vector(16 downto 0);
        ddr4_ba : out std_logic_vector(1 downto 0);
        ddr4_act_n : out std_logic;
        ddr4_bg : out std_logic;
        ddr4_cke : out std_logic;
        ddr4_odt : out std_logic;
        ddr4_cs_n : out std_logic;
        ddr4_ck_c : out std_logic;
        ddr4_ck_t : out std_logic;
        ddr4_reset_n : out std_logic;
        ddr4_dm_dbi_n : inout std_logic_vector(7 downto 0);
        ddr4_dq : inout std_logic_vector(63 downto 0);
        ddr4_dqs_c : inout std_logic_vector(7 downto 0);
        ddr4_dqs_t : inout std_logic_vector(7 downto 0)
    );
end ddr4;

architecture Behavioral of ddr4 is

COMPONENT ddr4_0
  PORT (
    c0_init_calib_complete : OUT STD_LOGIC;
    dbg_clk : OUT STD_LOGIC;
    c0_sys_clk_i : IN STD_LOGIC;
    dbg_bus : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    c0_ddr4_adr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
    c0_ddr4_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_cke : OUT STD_LOGIC;
    c0_ddr4_cs_n : OUT STD_LOGIC;
    c0_ddr4_dm_dbi_n : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_dq : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    c0_ddr4_dqs_c : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_dqs_t : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_odt : OUT STD_LOGIC;
    c0_ddr4_bg : OUT STD_LOGIC;
    c0_ddr4_reset_n : OUT STD_LOGIC;
    c0_ddr4_act_n : OUT STD_LOGIC;
    c0_ddr4_ck_c : OUT STD_LOGIC;
    c0_ddr4_ck_t : OUT STD_LOGIC;
    c0_ddr4_ui_clk : OUT STD_LOGIC;
    c0_ddr4_ui_clk_sync_rst : OUT STD_LOGIC;
    c0_ddr4_app_en : IN STD_LOGIC;
    c0_ddr4_app_hi_pri : IN STD_LOGIC;
    c0_ddr4_app_wdf_end : IN STD_LOGIC;
    c0_ddr4_app_wdf_wren : IN STD_LOGIC;
    c0_ddr4_app_rd_data_end : OUT STD_LOGIC;
    c0_ddr4_app_rd_data_valid : OUT STD_LOGIC;
    c0_ddr4_app_rdy : OUT STD_LOGIC;
    c0_ddr4_app_wdf_rdy : OUT STD_LOGIC;
    c0_ddr4_app_addr : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    c0_ddr4_app_cmd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_app_wdf_data : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    c0_ddr4_app_wdf_mask : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c0_ddr4_app_rd_data : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    sys_rst : IN STD_LOGIC 
  );
END COMPONENT;

signal rst : std_logic;

begin

    rst <= not rst_n;

ddr4 : ddr4_0
  PORT MAP (
    c0_init_calib_complete => calib_complete,
    dbg_clk => open,
    c0_sys_clk_i => clk_in,
    dbg_bus => open,
    c0_ddr4_adr => ddr4_adr,
    c0_ddr4_ba => ddr4_ba,
    c0_ddr4_cke => ddr4_cke,
    c0_ddr4_cs_n => ddr4_cs_n,
    c0_ddr4_dm_dbi_n => ddr4_dm_dbi_n,
    c0_ddr4_dq => ddr4_dq,
    c0_ddr4_dqs_c => ddr4_dqs_c,
    c0_ddr4_dqs_t => ddr4_dqs_t,
    c0_ddr4_odt => ddr4_odt,
    c0_ddr4_bg => ddr4_bg,
    c0_ddr4_reset_n => ddr4_reset_n,
    c0_ddr4_act_n => ddr4_act_n,
    c0_ddr4_ck_c => ddr4_ck_c,
    c0_ddr4_ck_t => ddr4_ck_t,
    c0_ddr4_ui_clk => clk_ddr_out,
    c0_ddr4_ui_clk_sync_rst => rst_out,
    c0_ddr4_app_en => ddr_en,
    c0_ddr4_app_hi_pri => '0',
    c0_ddr4_app_wdf_end => ddr_wrend,
    c0_ddr4_app_wdf_wren => ddr_wren,
    c0_ddr4_app_rd_data_end => ddr_rdend,
    c0_ddr4_app_rd_data_valid => ddr_rd_data_valid,
    c0_ddr4_app_rdy => ddr_rdy,
    c0_ddr4_app_wdf_rdy => ddr_wr_rdy,
    c0_ddr4_app_addr => ddr_addr,
    c0_ddr4_app_cmd => ddr_cmd,
    c0_ddr4_app_wdf_data => ddr_wr_data,
    c0_ddr4_app_wdf_mask => (others=>'0'),
    c0_ddr4_app_rd_data => ddr_rd_data,
    sys_rst => rst
  );

end Behavioral;
