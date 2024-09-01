library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity top_ddr is
    Port (
        clk_p : in std_logic;
        clk_n : in std_logic;
        rst_n : in std_logic;
    
        -- DDR
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
end top_ddr;

architecture Behavioral of top_ddr is

component data_creator is
    Port ( 
        clk_in : in std_logic;
        rst : in std_logic;
        en_ddr : out std_logic;
        ddr_addr : out std_logic_vector(28 downto 0);
        ddr_cmd : out std_logic_vector(2 downto 0);
        -- write
        ddr_wren : out std_logic;
        ddr_wrend : out std_logic;
        ddr_wr_rdy : in std_logic;
        ddr_wr_data : out std_logic_vector(511 downto 0);
        --read
        ddr_rden : in std_logic;
        ddr_rdend : in std_logic;
        ddr_rd_rdy : in std_logic;
        ddr_rd_data : in std_logic_vector(511 downto 0)
    );
end component;

component ddr4 is
    Port ( 
        clk_in : in std_logic;
        rst_n : in std_logic;
        -- internal ports
        clk_ddr_out : out std_logic;
        rst_out : out std_logic;
        ddr_en : in std_logic;
        ddr_addr : in std_logic_vector(28 downto 0);
        ddr_cmd : in std_logic_vector(2 downto 0);
        -- write
        ddr_wren : in std_logic;
        ddr_wrend : in std_logic;
        ddr_wr_rdy : out std_logic;
        ddr_wr_data : in std_logic_vector(511 downto 0);
        --read
        ddr_rden : out std_logic;
        ddr_rdend : out std_logic;
        ddr_rd_rdy : out std_logic;
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
end component;

signal clk_s : std_logic;
signal rst_s : std_logic;
signal ddr_en_s : std_logic;
signal ddr_addr_s : std_logic_vector(28 downto 0);
signal ddr_cmd_s : std_logic_vector(2 downto 0);
signal ddr_wren_s : std_logic;
signal ddr_wrend_s : std_logic;
signal ddr_wr_rdy_s : std_logic;
signal ddr_wr_data_s : std_logic_vector(511 downto 0);
signal ddr_rden_s : std_logic;
signal ddr_rdend_s : std_logic;
signal ddr_rd_rdy_s : std_logic;
signal ddr_rd_data_s : std_logic_vector(511 downto 0);

signal clk_in_s , clk_in_s0: std_logic;

begin

impl_data_creator : data_creator
    Port map ( 
        clk_in => clk_s,
        rst => rst_s,
        en_ddr => ddr_en_s,
        ddr_addr => ddr_addr_s,
        ddr_cmd => ddr_cmd_s,
        -- write
        ddr_wren => ddr_wren_s,
        ddr_wrend => ddr_wrend_s,
        ddr_wr_rdy => ddr_wr_rdy_s,
        ddr_wr_data => ddr_wr_data_s,
        --read
        ddr_rden => ddr_rden_s,
        ddr_rdend => ddr_rdend_s,
        ddr_rd_rdy => ddr_rd_rdy_s,
        ddr_rd_data => ddr_rd_data_s
    );
    
    
    
    
    
impl_IBUFDS : IBUFDS
generic map (
   DIFF_TERM => FALSE, -- Differential Termination
   IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
   IOSTANDARD => "DEFAULT")
port map (
   O => clk_in_s0,  -- Buffer output
   I => clk_p,  -- Diff_p buffer input (connect directly to top-level port)
   IB => clk_n -- Diff_n buffer input (connect directly to top-level port)
);

 
impl_BUFG : BUFG
    port map(
        I => clk_in_s0,
        O => clk_in_s
    );

impl_ddr4 : ddr4 
    Port map( 
        clk_in => clk_in_s,
        rst_n => rst_n,
        -- internal ports
        clk_ddr_out => clk_s,
        rst_out => rst_s,
        ddr_en => ddr_en_s,
        ddr_addr => ddr_addr_s,
        ddr_cmd => ddr_cmd_s,
        -- write
        ddr_wren => ddr_wren_s,
        ddr_wrend => ddr_wrend_s,
        ddr_wr_rdy => ddr_wr_rdy_s,
        ddr_wr_data => ddr_wr_data_s,
        --read
        ddr_rden => ddr_rden_s,
        ddr_rdend => ddr_rdend_s,
        ddr_rd_rdy => ddr_rd_rdy_s,
        ddr_rd_data => ddr_rd_data_s,
        
        -- external ddr ports
        ddr4_adr => ddr4_adr,
        ddr4_ba => ddr4_ba,
        ddr4_act_n => ddr4_act_n,
        ddr4_bg => ddr4_bg,
        ddr4_cke => ddr4_cke,
        ddr4_odt => ddr4_odt,
        ddr4_cs_n => ddr4_cs_n,
        ddr4_ck_c => ddr4_ck_c,
        ddr4_ck_t => ddr4_ck_t,
        ddr4_reset_n => ddr4_reset_n,
        ddr4_dm_dbi_n => ddr4_dm_dbi_n,
        ddr4_dq => ddr4_dq,
        ddr4_dqs_c => ddr4_dqs_c,
        ddr4_dqs_t => ddr4_dqs_t
    );


end Behavioral;
