library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ddr4_top is
  port (
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
    c0_ddr4_dqs_t    : inout std_logic_vector(7 downto 0);

    --Differential system clocks
    sys_clk : in std_logic;

    error                  : out std_logic;
    c0_init_calib_complete : out std_logic;
    sys_rst                : in std_logic

  );
end entity ddr4_top;

architecture rtl of ddr4_top is
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
    c0_ddr4_aresetn : IN STD_LOGIC;
    c0_ddr4_s_axi_awid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    c0_ddr4_s_axi_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_s_axi_awlock : IN STD_LOGIC;
    c0_ddr4_s_axi_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_s_axi_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_awvalid : IN STD_LOGIC;
    c0_ddr4_s_axi_awready : OUT STD_LOGIC;
    c0_ddr4_s_axi_wdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    c0_ddr4_s_axi_wstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_s_axi_wlast : IN STD_LOGIC;
    c0_ddr4_s_axi_wvalid : IN STD_LOGIC;
    c0_ddr4_s_axi_wready : OUT STD_LOGIC;
    c0_ddr4_s_axi_bready : IN STD_LOGIC;
    c0_ddr4_s_axi_bid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_s_axi_bvalid : OUT STD_LOGIC;
    c0_ddr4_s_axi_arid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    c0_ddr4_s_axi_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    c0_ddr4_s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_s_axi_arlock : IN STD_LOGIC;
    c0_ddr4_s_axi_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    c0_ddr4_s_axi_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_arvalid : IN STD_LOGIC;
    c0_ddr4_s_axi_arready : OUT STD_LOGIC;
    c0_ddr4_s_axi_rready : IN STD_LOGIC;
    c0_ddr4_s_axi_rlast : OUT STD_LOGIC;
    c0_ddr4_s_axi_rvalid : OUT STD_LOGIC;
    c0_ddr4_s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    c0_ddr4_s_axi_rid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    c0_ddr4_s_axi_rdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    sys_rst : IN STD_LOGIC
  );
END COMPONENT;
  constant AXI_ADDR_WIDTH : integer := 32;

  signal c0_ddr4_aresetn : std_logic;
  signal c0_ddr4_rst     : std_logic;
  signal c0_ddr4_clk     : std_logic;

  -- Slave Interface Write Address Ports
  signal c0_ddr4_s_axi_awid    : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_awaddr  : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal c0_ddr4_s_axi_awlen   : std_logic_vector(7 downto 0);
  signal c0_ddr4_s_axi_awsize  : std_logic_vector(2 downto 0);
  signal c0_ddr4_s_axi_awburst : std_logic_vector(1 downto 0);
  signal c0_ddr4_s_axi_awlock  : std_logic;
  signal c0_ddr4_s_axi_awcache : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_awprot  : std_logic_vector(2 downto 0);
  signal c0_ddr4_s_axi_awqos   : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_awuser  : std_logic;
  signal c0_ddr4_s_axi_awvalid : std_logic;
  signal c0_ddr4_s_axi_awready : std_logic;

  -- Slave Interface Write Data Ports
  signal c0_ddr4_s_axi_wdata  : std_logic_vector(63 downto 0);
  signal c0_ddr4_s_axi_wstrb  : std_logic_vector(7 downto 0);
  signal c0_ddr4_s_axi_wlast  : std_logic;
  signal c0_ddr4_s_axi_wuser  : std_logic;
  signal c0_ddr4_s_axi_wvalid : std_logic;
  signal c0_ddr4_s_axi_wready : std_logic;

  -- Slave Interface Write Response Ports
  signal c0_ddr4_s_axi_bready : std_logic;
  signal c0_ddr4_s_axi_bid    : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_bresp  : std_logic_vector(1 downto 0);
  signal c0_ddr4_s_axi_buser  : std_logic;
  signal c0_ddr4_s_axi_bvalid : std_logic;

  -- Slave Interface Read Address Ports
  signal c0_ddr4_s_axi_arid    : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_araddr  : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal c0_ddr4_s_axi_arlen   : std_logic_vector(7 downto 0);
  signal c0_ddr4_s_axi_arsize  : std_logic_vector(2 downto 0);
  signal c0_ddr4_s_axi_arburst : std_logic_vector(1 downto 0);
  signal c0_ddr4_s_axi_arlock  : std_logic;
  signal c0_ddr4_s_axi_arcache : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_arprot  : std_logic_vector(2 downto 0);
  signal c0_ddr4_s_axi_arqos   : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_aruser  : std_logic;
  signal c0_ddr4_s_axi_arvalid : std_logic;
  signal c0_ddr4_s_axi_arready : std_logic;

  -- Slave Interface Read Data Ports

  signal c0_ddr4_s_axi_rid    : std_logic_vector(3 downto 0);
  signal c0_ddr4_s_axi_rdata  : std_logic_vector(63 downto 0);
  signal c0_ddr4_s_axi_rresp  : std_logic_vector(1 downto 0);
  signal c0_ddr4_s_axi_rlast  : std_logic;
  signal c0_ddr4_s_axi_ruser  : std_logic;
  signal c0_ddr4_s_axi_rvalid : std_logic;
  signal c0_ddr4_s_axi_rready : std_logic;
  
  signal wr_burst_data_req    : std_logic;
  signal wr_burst_finish      : std_logic;
  signal rd_burst_finish      : std_logic;
  signal rd_burst_req         : std_logic;
  signal wr_burst_req         : std_logic;
  signal rd_burst_len         : std_logic_vector(9 downto 0);
  signal wr_burst_len         : std_logic_vector(9 downto 0);
  signal rd_burst_addr        : std_logic_vector(31 downto 0);
  signal wr_burst_addr        : std_logic_vector(31 downto 0);
  signal rd_burst_data_valid  : std_logic;
  signal rd_burst_data        : std_logic_vector(63 downto 0);
  signal wr_burst_data        : std_logic_vector(63 downto 0);
begin
  mem_test_m0 : entity work.mem_test
    generic map(
      G_MEM_DATA_BITS => 64,
      G_ADDR_BITS     => 24
    )
    port map
    (
      RST_I                 => not c0_ddr4_aresetn,
      MEM_CLK_I             => c0_ddr4_clk,
      RD_BURST_REQ_O        => rd_burst_req,
      WR_BURST_REQ_O        => wr_burst_req,
      RD_BURST_LEN_O        => rd_burst_len,
      WR_BURST_LEN_O        => wr_burst_len,
      RD_BURST_ADDR_O       => rd_burst_addr,
      WR_BURST_ADDR_O       => wr_burst_addr,
      RD_BURST_DATA_VALID_I => rd_burst_data_valid,
      WR_BURST_DATA_REQ_I   => wr_burst_data_req,
      RD_BURST_DATA_I       => rd_burst_data,
      WR_BURST_DATA_O       => wr_burst_data,
      RD_BURST_FINISH_I     => rd_burst_finish,
      WR_BURST_FINISH_I     => wr_burst_finish,

      --error_cnt						=> error_cnt,
      ERROR_O => error
    );
  u_aq_axi_master : entity work.aq_axi_master
    generic map(
      AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
    )
    port map
    (
      ARESETN => c0_ddr4_aresetn,
      ACLK    => c0_ddr4_clk,

      M_AXI_AWID    => c0_ddr4_s_axi_awid,
      M_AXI_AWADDR  => c0_ddr4_s_axi_awaddr,
      M_AXI_AWLEN   => c0_ddr4_s_axi_awlen,
      M_AXI_AWSIZE  => c0_ddr4_s_axi_awsize,
      M_AXI_AWBURST => c0_ddr4_s_axi_awburst,
      M_AXI_AWLOCK  => c0_ddr4_s_axi_awlock,
      M_AXI_AWCACHE => c0_ddr4_s_axi_awcache,
      M_AXI_AWPROT  => c0_ddr4_s_axi_awprot,
      M_AXI_AWQOS   => c0_ddr4_s_axi_awqos,
      M_AXI_AWUSER  => c0_ddr4_s_axi_awuser,
      M_AXI_AWVALID => c0_ddr4_s_axi_awvalid,
      M_AXI_AWREADY => c0_ddr4_s_axi_awready,
      M_AXI_WDATA   => c0_ddr4_s_axi_wdata,
      M_AXI_WSTRB   => c0_ddr4_s_axi_wstrb,
      M_AXI_WLAST   => c0_ddr4_s_axi_wlast,
      M_AXI_WUSER   => c0_ddr4_s_axi_wuser,
      M_AXI_WVALID  => c0_ddr4_s_axi_wvalid,
      M_AXI_WREADY  => c0_ddr4_s_axi_wready,
      M_AXI_BID     => c0_ddr4_s_axi_bid,
      M_AXI_BRESP   => c0_ddr4_s_axi_bresp,
      M_AXI_BUSER   => c0_ddr4_s_axi_buser,
      M_AXI_BVALID  => c0_ddr4_s_axi_bvalid,
      M_AXI_BREADY  => c0_ddr4_s_axi_bready,
      M_AXI_ARID    => c0_ddr4_s_axi_arid,
      M_AXI_ARADDR  => c0_ddr4_s_axi_araddr,
      M_AXI_ARLEN   => c0_ddr4_s_axi_arlen,
      M_AXI_ARSIZE  => c0_ddr4_s_axi_arsize,
      M_AXI_ARBURST => c0_ddr4_s_axi_arburst,
      M_AXI_ARLOCK  => c0_ddr4_s_axi_arlock,
      M_AXI_ARCACHE => c0_ddr4_s_axi_arcache,
      M_AXI_ARPROT  => c0_ddr4_s_axi_arprot,
      M_AXI_ARQOS   => c0_ddr4_s_axi_arqos,
      M_AXI_ARUSER  => c0_ddr4_s_axi_aruser,
      M_AXI_ARVALID => c0_ddr4_s_axi_arvalid,
      M_AXI_ARREADY => c0_ddr4_s_axi_arready,
      M_AXI_RID     => c0_ddr4_s_axi_rid,
      M_AXI_RDATA   => c0_ddr4_s_axi_rdata,
      M_AXI_RRESP   => c0_ddr4_s_axi_rresp,
      M_AXI_RLAST   => c0_ddr4_s_axi_rlast,
      M_AXI_RUSER   => c0_ddr4_s_axi_ruser,
      M_AXI_RVALID  => c0_ddr4_s_axi_rvalid,
      M_AXI_RREADY  => c0_ddr4_s_axi_rready,

      MASTER_RST => '0',

      WR_START       => wr_burst_req,
      WR_ADRS        => (wr_burst_addr(29 downto 0), "000"),
      WR_LEN         => (wr_burst_len, "000"),
      WR_READY       => open,
      WR_FIFO_RE     => wr_burst_data_req,
      WR_FIFO_EMPTY  => '0',
      WR_FIFO_AEMPTY => '0',
      WR_FIFO_DATA   => wr_burst_data,
      WR_DONE        => wr_burst_finish,

      RD_START      => rd_burst_req,
      RD_ADRS       => (wr_burst_addr(29 downto 0), "000"),
      RD_LEN        => (rd_burst_len, "000"),
      RD_READY      => open,
      RD_FIFO_WE    => rd_burst_data_valid,
      RD_FIFO_FULL  => '0',
      RD_FIFO_AFULL => '0',
      RD_FIFO_DATA  => rd_burst_data,
      RD_DONE       => rd_burst_finish,
      DEBUG         => open
    );

  your_instance_name : ddr4_0
    port map
    (
      c0_init_calib_complete  => c0_init_calib_complete, -- output  c0_init_calib_complete
      dbg_clk                 => open, -- output  dbg_clk
      c0_sys_clk_i            => sys_clk, -- input  c0_sys_clk_i
      dbg_bus                 => open, -- output  [511 : 0] dbg_bus
      c0_ddr4_adr             => c0_ddr4_adr, -- output  [16 : 0] c0_ddr4_adr
      c0_ddr4_ba              => c0_ddr4_ba, -- output  [1 : 0] c0_ddr4_ba
      c0_ddr4_cke             => c0_ddr4_cke, -- output  [0 : 0] c0_ddr4_cke
      c0_ddr4_cs_n            => c0_ddr4_cs_n, -- output  [0 : 0] c0_ddr4_cs_n
      c0_ddr4_dm_dbi_n        => c0_ddr4_dm_dbi_n, -- inout  [7 : 0] c0_ddr4_dm_dbi_n
      c0_ddr4_dq              => c0_ddr4_dq, -- inout   c0_ddr4_dq
      c0_ddr4_dqs_c           => c0_ddr4_dqs_c, -- inout  [7 : 0] c0_ddr4_dqs_c
      c0_ddr4_dqs_t           => c0_ddr4_dqs_t, -- inout  [7 : 0] c0_ddr4_dqs_t
      c0_ddr4_odt             => c0_ddr4_odt, -- output  [0 : 0] c0_ddr4_odt
      c0_ddr4_bg              => c0_ddr4_bg, -- output  [0 : 0] c0_ddr4_bg
      c0_ddr4_reset_n         => c0_ddr4_reset_n, -- output  c0_ddr4_reset_n
      c0_ddr4_act_n           => c0_ddr4_act_n, -- output  c0_ddr4_act_n
      c0_ddr4_ck_c            => c0_ddr4_ck_c, -- output  [0 : 0] c0_ddr4_ck_c
      c0_ddr4_ck_t            => c0_ddr4_ck_t, -- output  [0 : 0] c0_ddr4_ck_t
      c0_ddr4_ui_clk          => c0_ddr4_clk, -- output  c0_ddr4_ui_clk
      c0_ddr4_ui_clk_sync_rst => c0_ddr4_rst, -- output  c0_ddr4_ui_clk_sync_rst
      c0_ddr4_aresetn         => c0_ddr4_aresetn, -- input  c0_ddr4_aresetn
      c0_ddr4_s_axi_awid      => c0_ddr4_s_axi_awid, -- input  [3 : 0] c0_ddr4_s_axi_awid
      c0_ddr4_s_axi_awaddr    => c0_ddr4_s_axi_awaddr, -- input  [31 : 0] c0_ddr4_s_axi_awaddr
      c0_ddr4_s_axi_awlen     => c0_ddr4_s_axi_awlen, -- input  [7 : 0] c0_ddr4_s_axi_awlen
      c0_ddr4_s_axi_awsize    => c0_ddr4_s_axi_awsize, -- input  [2 : 0] c0_ddr4_s_axi_awsize
      c0_ddr4_s_axi_awburst   => c0_ddr4_s_axi_awburst, -- input  [1 : 0] c0_ddr4_s_axi_awburst
      c0_ddr4_s_axi_awlock    => c0_ddr4_s_axi_awlock, -- input  [0 : 0] c0_ddr4_s_axi_awlock
      c0_ddr4_s_axi_awcache   => c0_ddr4_s_axi_awcache, -- input  [3 : 0] c0_ddr4_s_axi_awcache
      c0_ddr4_s_axi_awprot    => c0_ddr4_s_axi_awprot, -- input  [2 : 0] c0_ddr4_s_axi_awprot
      c0_ddr4_s_axi_awqos     => c0_ddr4_s_axi_awqos, -- input  [3 : 0] c0_ddr4_s_axi_awqos
      c0_ddr4_s_axi_awvalid   => c0_ddr4_s_axi_awvalid, -- input  c0_ddr4_s_axi_awvalid
      c0_ddr4_s_axi_awready   => c0_ddr4_s_axi_awready, -- output  c0_ddr4_s_axi_awready
      c0_ddr4_s_axi_wdata     => c0_ddr4_s_axi_wdata, -- input   c0_ddr4_s_axi_wdata
      c0_ddr4_s_axi_wstrb     => c0_ddr4_s_axi_wstrb, -- input  [7 : 0] c0_ddr4_s_axi_wstrb
      c0_ddr4_s_axi_wlast     => c0_ddr4_s_axi_wlast, -- input  c0_ddr4_s_axi_wlast
      c0_ddr4_s_axi_wvalid    => c0_ddr4_s_axi_wvalid, -- input  c0_ddr4_s_axi_wvalid
      c0_ddr4_s_axi_wready    => c0_ddr4_s_axi_wready, -- output  c0_ddr4_s_axi_wready
      c0_ddr4_s_axi_bready    => c0_ddr4_s_axi_bready, -- input  c0_ddr4_s_axi_bready
      c0_ddr4_s_axi_bid       => c0_ddr4_s_axi_bid, -- output  [3 : 0] c0_ddr4_s_axi_bid
      c0_ddr4_s_axi_bresp     => c0_ddr4_s_axi_bresp, -- output  [1 : 0] c0_ddr4_s_axi_bresp
      c0_ddr4_s_axi_bvalid    => c0_ddr4_s_axi_bvalid, -- output  c0_ddr4_s_axi_bvalid
      c0_ddr4_s_axi_arid      => c0_ddr4_s_axi_arid, -- input  [3 : 0] c0_ddr4_s_axi_arid
      c0_ddr4_s_axi_araddr    => c0_ddr4_s_axi_araddr, -- input  [31 : 0] c0_ddr4_s_axi_araddr
      c0_ddr4_s_axi_arlen     => c0_ddr4_s_axi_arlen, -- input  [7 : 0] c0_ddr4_s_axi_arlen
      c0_ddr4_s_axi_arsize    => c0_ddr4_s_axi_arsize, -- input  [2 : 0] c0_ddr4_s_axi_arsize
      c0_ddr4_s_axi_arburst   => c0_ddr4_s_axi_arburst, -- input  [1 : 0] c0_ddr4_s_axi_arburst
      c0_ddr4_s_axi_arlock    => c0_ddr4_s_axi_arlock, -- input  [0 : 0] c0_ddr4_s_axi_arlock
      c0_ddr4_s_axi_arcache   => c0_ddr4_s_axi_arcache, -- input  [3 : 0] c0_ddr4_s_axi_arcache
      c0_ddr4_s_axi_arprot    => c0_ddr4_s_axi_arprot, -- input  [2 : 0] c0_ddr4_s_axi_arprot
      c0_ddr4_s_axi_arqos     => c0_ddr4_s_axi_arqos, -- input  [3 : 0] c0_ddr4_s_axi_arqos
      c0_ddr4_s_axi_arvalid   => c0_ddr4_s_axi_arvalid, -- input  c0_ddr4_s_axi_arvalid
      c0_ddr4_s_axi_arready   => c0_ddr4_s_axi_arready, -- output  c0_ddr4_s_axi_arready
      c0_ddr4_s_axi_rready    => c0_ddr4_s_axi_rready, -- input  c0_ddr4_s_axi_rready
      c0_ddr4_s_axi_rlast     => c0_ddr4_s_axi_rlast, -- output  c0_ddr4_s_axi_rlast
      c0_ddr4_s_axi_rvalid    => c0_ddr4_s_axi_rvalid, -- output  c0_ddr4_s_axi_rvalid
      c0_ddr4_s_axi_rresp     => c0_ddr4_s_axi_rresp, -- output  [1 : 0] c0_ddr4_s_axi_rresp
      c0_ddr4_s_axi_rid       => c0_ddr4_s_axi_rid, -- output  [3 : 0] c0_ddr4_s_axi_rid
      c0_ddr4_s_axi_rdata     => c0_ddr4_s_axi_rdata, -- output   c0_ddr4_s_axi_rdata
      sys_rst                 => sys_rst -- input  sys_rst
    );

  process (c0_ddr4_clk)
  begin
    if rising_edge(c0_ddr4_clk) then
      c0_ddr4_aresetn <= not c0_ddr4_rst;
    end if;
  end process;

end architecture;
