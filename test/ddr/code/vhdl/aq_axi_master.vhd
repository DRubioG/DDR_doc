-- /*
--  * Copyright (C)2014-2015 AQUAXIS TECHNOLOGY.
--  *  Don't remove this header. 
--  * When you use this source, there is a need to inherit this header.
--  *
--  * License
--  *  For no commercial -
--  *   License:     The Open Software License 3.0
--  *   License URI: http:--www.opensource.org/licenses/OSL-3.0
--  *
--  *  For commmercial -
--  *   License:     AQUAXIS License 1.0
--  *   License URI: http:--www.aquaxis.com/licenses
--  *
--  * For further information please contact.
--  *	URI:    http:--www.aquaxis.com/
--  *	E-Mail: info(at)aquaxis.com
--  */

----------------------------------------------------------------------------------
-- Company: ALINX黑金
-- Engineer: 老梅
-- 
-- Create Date: 2016/11/17 10:27:06
-- Design Name: 
-- Module Name: mem_test
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aq_axi_master is
  generic (

    AXI_ADDR_WIDTH : integer := 32
  );
  port (

    -- Reset, Clock
    ARESETN : in std_logic;
    ACLK    : in std_logic;

    -- Master Write Address
    M_AXI_AWID    : out std_logic_vector(3 downto 0);
    M_AXI_AWADDR  : out std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
    M_AXI_AWLEN   : out std_logic_vector(7 downto 0); -- Burst Length: 0-255
    M_AXI_AWSIZE  : out std_logic_vector(2 downto 0); -- Burst Size: Fixed 2'b011
    M_AXI_AWBURST : out std_logic_vector(1 downto 0); -- Burst Type: Fixed 2'b01(Incremental Burst)
    M_AXI_AWLOCK  : out std_logic; -- Lock: Fixed 2'b00
    M_AXI_AWCACHE : out std_logic_vector(3 downto 0); -- Cache: Fiex 2'b0011
    M_AXI_AWPROT  : out std_logic_vector(2 downto 0); -- Protect: Fixed 2'b000
    M_AXI_AWQOS   : out std_logic_vector(2 downto 0); -- QoS: Fixed 2'b0000
    M_AXI_AWUSER  : out std_logic; -- User: Fixed 32'd0
    M_AXI_AWVALID : out std_logic;
    M_AXI_AWREADY : in std_logic;

    -- Master Write Data
    M_AXI_WDATA  : out std_logic_vector(63 downto 0);
    M_AXI_WSTRB  : out std_logic_vector(7 downto 0);
    M_AXI_WLAST  : out std_logic;
    M_AXI_WUSER  : out std_logic;
    M_AXI_WVALID : out std_logic;
    M_AXI_WREADY : in std_logic;

    -- Master Write Response
    M_AXI_BID    : in std_logic_vector(3 downto 0);
    M_AXI_BRESP  : in std_logic_vector(1 downto 0);
    M_AXI_BUSER  : in std_logic;
    M_AXI_BVALID : in std_logic;
    M_AXI_BREADY : out std_logic;

    -- Master Read Address
    M_AXI_ARID    : out std_logic_vector(3 downto 0);
    M_AXI_ARADDR  : out std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
    M_AXI_ARLEN   : out std_logic_vector(7 downto 0);
    M_AXI_ARSIZE  : out std_logic_vector(2 downto 0);
    M_AXI_ARBURST : out std_logic_vector(1 downto 0);
    M_AXI_ARLOCK  : out std_logic;
    M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
    M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
    M_AXI_ARQOS   : out std_logic_vector(3 downto 0);
    M_AXI_ARUSER  : out std_logic;
    M_AXI_ARVALID : out std_logic;
    M_AXI_ARREADY : in std_logic;

    -- Master Read Data 
    M_AXI_RID    : in std_logic_vector(3 downto 0);
    M_AXI_RDATA  : in std_logic_vector(63 downto 0);
    M_AXI_RRESP  : in std_logic_vector(1 downto 0);
    M_AXI_RLAST  : in std_logic;
    M_AXI_RUSER  : in std_logic;
    M_AXI_RVALID : in std_logic;
    M_AXI_RREADY : out std_logic;

    -- Local Bus
    MASTER_RST : in std_logic;

    WR_START       : in std_logic; --写开始
    WR_ADRS        : in std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);--写地址
    WR_LEN         : in std_logic_vector(31 downto 0); --写数据长度
    WR_READY       : out std_logic;--（）
    WR_FIFO_RE     : out std_logic;--忙碌
    WR_FIFO_EMPTY  : in std_logic;--（）
    WR_FIFO_AEMPTY : in std_logic;--（）
    WR_FIFO_DATA   : in std_logic_vector(63 downto 0);--写入数据
    WR_DONE        : out std_logic;--写完成

    RD_START      : in std_logic;--读开始
    RD_ADRS       : in std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
    RD_LEN        : in std_logic_vector(31 downto 0);
    RD_READY      : out std_logic;
    RD_FIFO_WE    : out std_logic;
    RD_FIFO_FULL  : in std_logic;
    RD_FIFO_AFULL : in std_logic;
    RD_FIFO_DATA  : out std_logic_vector(63 downto 0);
    RD_DONE       : out std_logic;

    DEBUG : out std_logic_vector(31 downto 0)
  );
end entity aq_axi_master;

architecture rtl of aq_axi_master is
COMPONENT ila_1

PORT (
	clk : IN STD_LOGIC;



	probe0 : IN STD_LOGIC; 
	probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe3 : IN STD_LOGIC; 
	probe4 : IN STD_LOGIC; 
	probe5 : IN STD_LOGIC; 
	probe6 : IN STD_LOGIC; 
	probe7 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
	probe8 : IN STD_LOGIC; 
	probe9 : IN STD_LOGIC; 
	probe10 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe11 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe12 : IN STD_LOGIC; 
	probe13 : IN STD_LOGIC; 
	probe14 : IN STD_LOGIC; 
	probe15 : IN STD_LOGIC; 
	probe16 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
	probe17 : IN STD_LOGIC;
	probe18 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT  ;

subtype fsm is std_logic_vector(2 downto 0);

constant  S_WR_IDLE : fsm:= "000";
constant  S_WA_WAIT : fsm := "001";
constant  S_WA_START : fsm := "010";
constant  S_WD_WAIT : fsm := "011";
constant  S_WD_PROC : fsm := "100";
constant  S_WR_WAIT : fsm := "101";
constant  S_WR_DONE : fsm := "110";  

  signal wr_state : fsm;

  signal reg_wr_adrs                         : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal reg_wr_len                          : std_logic_vector(31 downto 0);
  signal reg_awvalid, reg_wvalid, reg_w_last : std_logic;
  signal reg_w_len                           : std_logic_vector(7 downto 0);
  signal reg_w_stb                           : std_logic_vector(7 downto 0);
  signal reg_wr_status                       : std_logic_vector(1 downto 0);
  signal reg_w_count, reg_r_count            : std_logic_vector(3 downto 0);

  signal rd_chkdata, wr_chkdata : std_logic_vector(7 downto 0);
  signal resp                   : std_logic_vector(1 downto 0);
  signal rd_first_data          : std_logic;
  signal rd_fifo_enable         : std_logic;
  signal rd_fifo_cnt            : std_logic_vector(31 downto 0);

--   type fsm2 is (
subtype fsm2 is std_logic_vector(2 downto 0);

constant S_RD_IDLE : fsm2 := "000";
constant S_RA_WAIT : fsm2 := "001";
constant S_RA_START : fsm2 := "010";
constant S_RD_WAIT : fsm2 := "011";
constant S_RD_PROC : fsm2 := "100";
constant S_RD_DONE : fsm2 := "101";
--   );

  signal rd_state                : fsm2;
  signal reg_rd_adrs             : std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
  signal reg_rd_len              : std_logic_vector(31 downto 0);
  signal reg_arvalid, reg_r_last : std_logic;
  signal reg_r_len               : std_logic_vector(7 downto 0);

begin

  your_instance_name : ila_1
    port map
    (
      clk     => ACLK, -- input wire clk
      probe0  => WR_START, -- input wire [0:0]  probe0  
      probe1  => WR_ADRS, -- input wire [31:0]  probe1 
      probe2  => WR_LEN, -- input wire [31:0]  probe2 
      probe3  => WR_READY, -- input wire [0:0]  probe3 
      probe4  => WR_FIFO_RE, -- input wire [0:0]  probe4 
      probe5  => WR_FIFO_EMPTY, -- input wire [0:0]  probe5 
      probe6  => WR_FIFO_AEMPTY, -- input wire [0:0]  probe6 
      probe7  => WR_FIFO_DATA, -- input wire [63:0]  probe7 
      probe8  => WR_DONE, -- input wire [0:0]  probe8 
      probe9  => RD_START, -- input wire [0:0]  probe9 
      probe10 => RD_ADRS, -- input wire [31:0]  probe10 
      probe11 => RD_LEN, -- input wire [31:0]  probe11 
      probe12 => RD_READY, -- input wire [0:0]  probe12 
      probe13 => RD_FIFO_WE, -- input wire [0:0]  probe13 
      probe14 => RD_FIFO_FULL, -- input wire [0:0]  probe14 
      probe15 => RD_FIFO_AFULL, -- input wire [0:0]  probe15 
      probe16 => RD_FIFO_DATA, -- input wire [63:0]  probe16 
      probe17 => RD_DONE, -- input wire [0:0]  probe17 
      probe18 => DEBUG -- input wire [31:0]  probe18
    );

  WR_DONE <= '1' when wr_state = S_WR_DONE else
    '0';
  WR_FIFO_RE <= rd_first_data or (reg_wvalid and not(WR_FIFO_EMPTY) and M_AXI_WREADY and rd_fifo_enable);

  process (ACLK, ARESETN)
  begin
    if ARESETN = '0' then
      rd_fifo_cnt <= (others => '0');
    elsif rising_edge(ACLK) then
      if WR_FIFO_RE = '1' then
        rd_fifo_cnt <= std_logic_vector(unsigned(rd_fifo_cnt) + 1);
      else
        if wr_state = S_WR_IDLE then
          rd_fifo_cnt <= (others => '0');
        end if;
      end if;
    end if;
  end process;

  process (ACLK, ARESETN)
  begin
    if ARESETN = '0' then
      rd_fifo_enable <= '0';
    elsif rising_edge(ACLK) then
      if wr_state = S_WR_IDLE and WR_START = '1' then
        rd_fifo_enable <= '1';
      else
        if WR_FIFO_RE = '1' and rd_fifo_cnt = std_logic_vector(unsigned(RD_LEN(31 downto 3)) - 1) then
          rd_fifo_enable <= '0';
        end if;

      end if;
    end if;
  end process;

  -- Write State
  process (ACLK, ARESETN)
  begin
    if ARESETN = '0' then
      wr_state      <= S_WR_IDLE;
      reg_wr_adrs   <= (others => '0');
      reg_wr_len    <= (others => '0');
      reg_awvalid   <= '0';
      reg_wvalid    <= '0';
      reg_w_last    <= '0';
      reg_w_len     <= (others => '0');
      reg_w_stb     <= (others => '0');
      reg_wr_status <= (others => '0');
      reg_w_count   <= (others => '0');
      reg_r_count   <= (others => '0');
      wr_chkdata    <= (others => '0');
      rd_chkdata    <= (others => '0');
      resp          <= (others => '0');
      rd_first_data <= '0';

    elsif rising_edge(ACLK) then
      if (MASTER_RST) then
        wr_state <= S_WR_IDLE;
      else
        case(wr_state) is
          when S_WR_IDLE =>
          if (WR_START) then
            wr_state      <= S_WA_WAIT;
            reg_wr_adrs   <= WR_ADRS;
            reg_wr_len    <= std_logic_vector(unsigned(WR_LEN) - 1);
            rd_first_data <= '1';
          end if;
          reg_awvalid   <= '0';
          reg_wvalid    <= '0';
          reg_w_last    <= '0';
          reg_w_len     <= (others => '0');
          reg_w_stb     <= (others => '0');
          reg_wr_status <= (others => '0');

          when S_WA_WAIT                                                                         =>
          if WR_FIFO_AEMPTY = '0' or (reg_wr_len(31 downto 11) = (reg_wr_len(31 downto 11)'range => '0')) then
            wr_state <= S_WA_START;
          end if;
          rd_first_data <= '0';

          when S_WA_START =>
          wr_state                 <= S_WD_WAIT;
          reg_awvalid              <= '1';
          reg_wr_len(31 downto 11) <= std_logic_vector(unsigned(reg_wr_len(31 downto 11)) - 1);
          if reg_wr_len(31 downto 11) /= (reg_wr_len(31 downto 11)'range => '0') then
            reg_w_len  <= (others                                          => '1');
            reg_w_last <= '0';
            reg_w_stb  <= (others => '1');
          else
            reg_w_len  <= reg_wr_len(10 downto 3);
            reg_w_last <= '1';
            reg_w_stb  <= (others => '1');
          end if;
          when S_WD_WAIT =>
          if M_AXI_AWREADY = '1' then
            wr_state    <= S_WD_PROC;
            reg_awvalid <= '0';
            reg_wvalid  <= '1';
          end if;

          when S_WD_PROC =>
          if M_AXI_WREADY = '1' and WR_FIFO_EMPTY = '0' then
            if reg_w_len = (reg_w_len'range => '0') then
              wr_state   <= S_WR_WAIT;
              reg_wvalid <= '0';
              reg_w_stb  <= (others => '0');
            else

              reg_w_len <= std_logic_vector(unsigned(reg_w_len) - 1);
            end if;
          end if;

          when S_WR_WAIT =>
          if M_AXI_BVALID = '1' then
            reg_wr_status <= reg_wr_status or M_AXI_BRESP;
            if (reg_w_last) then
              wr_state <= S_WR_DONE;
            else

              wr_state    <= S_WA_WAIT;
              reg_wr_adrs <= std_logic_vector(unsigned(reg_wr_adrs) + 2048);
            end if;
          end if;

          when S_WR_DONE =>
          wr_state <= S_WR_IDLE;
          when others =>
          wr_state <= S_WR_IDLE;

        end case;
      end if;
    end if;

  end process;

  M_AXI_AWID    <= (others => '0') ;
  M_AXI_AWADDR  <= reg_wr_adrs;
  M_AXI_AWLEN   <= reg_w_len;
  M_AXI_AWSIZE  <= "011";
  M_AXI_AWBURST <= "01";
  M_AXI_AWLOCK  <= '0';
  M_AXI_AWCACHE <= "0011";
  M_AXI_AWPROT  <= "000";
  M_AXI_AWQOS   <= "0000";
  M_AXI_AWUSER  <= '1';
  M_AXI_AWVALID <= reg_awvalid;

  M_AXI_WDATA <= WR_FIFO_DATA;

  M_AXI_WSTRB <= (others                               => '1') when reg_wvalid = '1' and WR_FIFO_EMPTY = '0' else
    (others                                              => '0');
  M_AXI_WLAST <= '1' when reg_w_len = (reg_w_len'range => '0') else
    '0';

  M_AXI_WUSER  <= '1';
  M_AXI_WVALID <= reg_wvalid and not WR_FIFO_EMPTY;
  M_AXI_BREADY <= M_AXI_BVALID;

  WR_READY <= '1' when wr_state = S_WR_IDLE else
    '0';

  RD_DONE <= '1' when rd_state = S_RD_DONE else
    '0';

  -- Read State
  process (ACLK, ARESETN)
  begin
    if ARESETN = '0' then
      rd_state    <= S_RD_IDLE;
      reg_rd_adrs <= (others => '0');
      reg_rd_len  <= (others => '0');
      reg_arvalid <= '0';
      reg_r_len   <= (others => '0');
    elsif rising_edge(ACLK) then
      case rd_state is
        when S_RD_IDLE =>
          if RD_START = '1' then
            rd_state    <= S_RA_WAIT;
            reg_rd_adrs <= RD_ADRS;
            reg_rd_len  <= std_logic_vector(unsigned(RD_LEN) - 1);
          end if;
          reg_arvalid <= '0';
          reg_r_len   <= (others => '0');

        when S_RA_WAIT =>
          if RD_FIFO_AFULL = '0' then
            rd_state <= S_RA_START;
          end if;

        when S_RA_START =>
          rd_state                 <= S_RD_WAIT;
          reg_arvalid              <= '1';
          reg_rd_len(31 downto 11) <= std_logic_vector(unsigned(reg_rd_len(31 downto 11)) - 1);
          if reg_rd_len(31 downto 11) /= (reg_rd_len(31 downto 11)'range => '0') then
            reg_r_last <= '0';
            reg_r_len  <= (others => '0') ;
          else

            reg_r_last <= '1';
            reg_r_len  <= reg_rd_len(10 downto 3);
          end if;

        when S_RD_WAIT =>
          if M_AXI_ARREADY = '1' then
            rd_state    <= S_RD_PROC;
            reg_arvalid <= '0';
          end if;

        when S_RD_PROC =>
          if M_AXI_RVALID = '1' then
            if M_AXI_RLAST = '1' then
              if reg_r_last = '1' then
                rd_state <= S_RD_DONE;
              else

                rd_state    <= S_RA_WAIT;
                reg_rd_adrs <= std_logic_vector(unsigned(reg_rd_adrs) + 2048);
              end if;
            else
              reg_r_len <= std_logic_vector(unsigned(reg_r_len) - 1);
            end if;
          end if;

        when S_RD_DONE =>
          rd_state <= S_RD_IDLE;
      end case;
    end if;
  end process;

  -- Master Read Address
  M_AXI_ARID    <= (others => '0') ;
  M_AXI_ARADDR  <= reg_rd_adrs;
  M_AXI_ARLEN   <= reg_r_len;
  M_AXI_ARSIZE  <= "011";
  M_AXI_ARBURST <= "01";
  M_AXI_ARLOCK  <= '0';
  M_AXI_ARCACHE <= "0011";
  M_AXI_ARPROT  <= "000";
  M_AXI_ARQOS   <= "0000";
  M_AXI_ARUSER  <= '1';
  M_AXI_ARVALID <= reg_arvalid;

  M_AXI_RREADY <= M_AXI_RVALID and not RD_FIFO_FULL;


  RD_READY <= '1' when rd_state = S_RD_IDLE else '0';
  
    
  RD_FIFO_WE   <= M_AXI_RVALID;
  RD_FIFO_DATA <= M_AXI_RDATA;

  DEBUG <= (reg_wr_len(31 downto 8), '0', wr_state(2 downto 0), '0', rd_state(2 downto 0));


end architecture;
