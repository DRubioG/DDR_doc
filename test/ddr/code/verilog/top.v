`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 13:04:45
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
(
	output[3:0]   tx_disable,        
	input         sys_clk_p,
    input         sys_clk_n,

    input         mgtrefclk_n,
    input         mgtrefclk_p,    
    input [3:0]   RXN_IN,
    input [3:0]   RXP_IN,
    output[3:0]   TXN_OUT,
    output[3:0]   TXP_OUT,
	//ethernet 1
	output         		e1_mdc,
	inout          		e1_mdio,
	output				e1_reset,			
	output [3:0]   		e1_rgmii_txd,
	output         		e1_rgmii_txctl,
	output         		e1_rgmii_txc,
	input  [3:0]   		e1_rgmii_rxd,
	input          		e1_rgmii_rxctl,
	input          		e1_rgmii_rxc,
	//ethernet 1
	output         		e2_mdc,
	inout          		e2_mdio,
	output				e2_reset,			
	output [3:0]   		e2_rgmii_txd,
	output         		e2_rgmii_txctl,
	output         		e2_rgmii_txc,
	input  [3:0]   		e2_rgmii_rxd,
	input          		e2_rgmii_rxctl,
	input          		e2_rgmii_rxc,
	//key led
	input 				key1,
    input 				key2,
    output [1:0]		led1_2,
    output [1:0]		led3_4,
	//hdmi
	output                   hdmi_clk,
    output[23:0]             hdmi_d,
    output                   hdmi_de,
    output                   hdmi_hs,
	output                   hdmi_vs,
    inout                    hdmi_scl,
    inout                    hdmi_sda,
	//eeprom
	inout                    eeprom_i2c_sda,
    inout                    eeprom_i2c_scl,
	//sd
	output           		 sd_ncs,
	output           		 sd_dclk,
	output           		 sd_mosi,
	input            		 sd_miso,
	//ddr4
	output                             c0_ddr4_act_n   ,
	output [16:0]                      c0_ddr4_adr     ,
	output [1:0]                       c0_ddr4_ba      ,
	output [0:0]                       c0_ddr4_bg      ,
	output [0:0]                       c0_ddr4_cke     ,
	output [0:0]                       c0_ddr4_odt     ,
	output [0:0]                       c0_ddr4_cs_n    ,
	output [0:0]                       c0_ddr4_ck_t    ,
	output [0:0]                       c0_ddr4_ck_c    ,
	output                             c0_ddr4_reset_n ,
	inout [7:0]                        c0_ddr4_dm_dbi_n,
	inout [63:0]                       c0_ddr4_dq      ,
	inout [7:0]                        c0_ddr4_dqs_c   ,
	inout [7:0]                        c0_ddr4_dqs_t  ,
	//uart
	input                        uart_rx,
	output                       uart_tx
    );

wire		locked ;
wire		sys_clk ;
wire		sys_clk_buf ;
wire		clk_100Mhz ;
wire		clk_50Mhz ;

wire		eeprom_boot_reset ;
wire		eeprom_boot_reset_ack ;
wire [7:0]	reboot_times ;
wire		eeprom_error ;
wire		sd_error ;
wire		ddr4_error ;
wire		c0_init_calib_complete ;
wire [31:0]	gt_status ;


assign e1_reset = locked ;
assign e2_reset = locked ;

IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) IBUFDS_inst (
   .O(sys_clk_buf),  // Buffer output
   .I(sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
   .IB(sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
);

   BUFG BUFG_inst (
      .O(sys_clk), // 1-bit output: Clock output
      .I(sys_clk_buf)  // 1-bit input: Clock input
   );

sys_clock pll_inst
 (
  // Clock out ports
  .clk_out1(clk_100Mhz),     // output clk_out1
  .clk_out2(clk_50Mhz),     // output clk_out1
  // Status and control signals
  .reset(1'b0), // input reset
  .locked(locked),       // output locked
 // Clock in ports
  .clk_in1(sys_clk));	

gt_top gt_inst
(
    .tx_disable         (tx_disable     ),
	.clk_100Mhz         (clk_100Mhz     ),
	.rst_n              (locked          ),
	.status             (gt_status         ),
    .mgtrefclk_n        (mgtrefclk_n    ),
    .mgtrefclk_p        (mgtrefclk_p    ),
    .RXN_IN             (RXN_IN         ),
    .RXP_IN             (RXP_IN         ),
    .TXN_OUT            (TXN_OUT        ),
    .TXP_OUT            (TXP_OUT        )
);

(* IODELAY_GROUP = "delay_group" *)
IDELAYCTRL #(
   .SIM_DEVICE("ULTRASCALE")  // Must be set to "ULTRASCALE" 
)
IDELAYCTRL_inst (
   .RDY(),       // 1-bit output: Ready output
   .REFCLK(sys_clk), // 1-bit input: Reference clock input
   .RST(~key1)        // 1-bit input: Active high reset input. Asynchronous assert, synchronous deassert to
                    // REFCLK.
); 

ethernet_test
#(
	.LOCAL_IP_ADDR 	(32'hc0a80204 	),
	.DST_IP_ADDR 	(32'hc0a80203 	),
	.LOCAL_MAC_ADDR (48'h00_0a_35_01_fe_d1 )
)
eth1
 (
  .rst_n         (locked      ),
  .sys_clk 	     (clk_50Mhz 	  ),
  .led 	    	 ( 	  ),
  .e_mdc         (e1_mdc      ),
  .e_mdio        (e1_mdio     ),
  .rgmii_txd     (e1_rgmii_txd  ),
  .rgmii_txctl   (e1_rgmii_txctl),
  .rgmii_txc     (e1_rgmii_txc  ),
  .rgmii_rxd     (e1_rgmii_rxd  ),
  .rgmii_rxctl   (e1_rgmii_rxctl),
  .rgmii_rxc     (e1_rgmii_rxc  )
 
 );	
	
ethernet_test 
#(
	.LOCAL_IP_ADDR 	(32'hc0a80205 	),
	.DST_IP_ADDR 	(32'hc0a80203 	),
	.LOCAL_MAC_ADDR (48'h00_0a_35_01_fe_d2 )
)
eth2
 (
  .rst_n         (locked      ),
  .sys_clk 	     (clk_50Mhz 	  ),
  .led 	    	 ( 	  ),
  .e_mdc         (e2_mdc      ),
  .e_mdio        (e2_mdio     ),
  .rgmii_txd     (e2_rgmii_txd  ),
  .rgmii_txctl   (e2_rgmii_txctl),
  .rgmii_txc     (e2_rgmii_txc  ),
  .rgmii_rxd     (e2_rgmii_rxd  ),
  .rgmii_rxctl   (e2_rgmii_rxctl),
  .rgmii_rxc     (e2_rgmii_rxc  )
 
 );	

led key_led_inst(
    .clk	   (clk_50Mhz),
    .rst_n	   (locked),
    .key1	   (key1	),
    .key2	   (key2	),
    .led1_2	   (led1_2	),
    .led3_4    (led3_4 )

);



hdmi_top hdmi_inst(
    .sys_clk	  (sys_clk),
    .hdmi_clk	  (hdmi_clk	),
    .hdmi_d		  (hdmi_d		),
    .hdmi_de	  (hdmi_de	),
    .hdmi_hs	  (hdmi_hs	),
	.hdmi_vs	  (hdmi_vs	),
    .hdmi_scl	  (hdmi_scl	),
    .hdmi_sda     (hdmi_sda   )
);

i2c_eeprom_test eeprom_inst(
    .clk		(clk_50Mhz),
    .rst_n		(locked),
    .i2c_sda	(eeprom_i2c_sda),
    .i2c_scl    (eeprom_i2c_scl),
    .boot_reset    (eeprom_boot_reset),
    .boot_reset_ack    (eeprom_boot_reset_ack),
    .reboot_times    (reboot_times),
    .eeprom_error    (eeprom_error)
);

sd_card_test sd_inst(
    .sys_clk	(clk_50Mhz	),
    .rst_n		(locked		),
    .sd_ncs		(sd_ncs		),
    .sd_dclk	(sd_dclk	),
    .sd_mosi	(sd_mosi	),
    .sd_miso	(sd_miso	),
    .sd_error   (sd_error   )

);


ddr4_top ddr4_test_inst
(
	.c0_ddr4_act_n            (c0_ddr4_act_n   ),
	.c0_ddr4_adr              (c0_ddr4_adr     ),
	.c0_ddr4_ba               (c0_ddr4_ba      ),
	.c0_ddr4_bg               (c0_ddr4_bg      ),
	.c0_ddr4_cke              (c0_ddr4_cke     ),
	.c0_ddr4_odt              (c0_ddr4_odt     ),
	.c0_ddr4_cs_n             (c0_ddr4_cs_n    ),
	.c0_ddr4_ck_t             (c0_ddr4_ck_t    ),
	.c0_ddr4_ck_c             (c0_ddr4_ck_c    ),
	.c0_ddr4_reset_n          (c0_ddr4_reset_n ),
	.c0_ddr4_dm_dbi_n         (c0_ddr4_dm_dbi_n),
	.c0_ddr4_dq               (c0_ddr4_dq      ),
	.c0_ddr4_dqs_c            (c0_ddr4_dqs_c   ),
	.c0_ddr4_dqs_t            (c0_ddr4_dqs_t   ),

	.sys_clk       	  		  (sys_clk),
	.error	       	  		  (ddr4_error),
	.c0_init_calib_complete	       	  		  (c0_init_calib_complete),
	.sys_rst	          	  (~key1	  	 )
   );

uart_test uart_inst(
    .sys_clk				(clk_50Mhz),      
    .rst_n					(locked),      
	.eeprom_error			(eeprom_error	),
	.sd_error				(sd_error		),
	.ddr4_error				(ddr4_error		),
	.c0_init_calib_complete				(c0_init_calib_complete		),
	.gt_status				(gt_status[31:26]		),
	.eeprom_boot_reset		(eeprom_boot_reset),
	.eeprom_boot_reset_ack	(eeprom_boot_reset_ack),
	.reboot_times			(reboot_times),
	.uart_rx				(uart_rx),
	.uart_tx        		(uart_tx)
);

 
endmodule
