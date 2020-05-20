`default_nettype none
`include "interface_defs.v"
`include "arria_v_specific_interfaces.v"

module arria_v_strandalone_serialite_priority_xcvr_1_channel_w_uart_control_external_reconfig
#(
parameter ctl_rxhpp_ftl_DEFAULT = 50,
parameter ctl_rxhpp_eopdav_DEFAULT = 1,
parameter ctl_txhpp_fth_DEFAULT = 50,
parameter REGFILE_BAUD_RATE = 2000000,
parameter [63:0] xcvr_name = "undef",
parameter [127:0] diagnostic_uart_name = {"Slhpp_",xcvr_name},
parameter [127:0] phy_and_reconfig_uart_name = {"PhyCtl",xcvr_name},
parameter synchronizer_depth = 3
)
(
	input XCVR_RX,
	output XCVR_TX,
	input CLKIN_125MHz,
	input RESET_FOR_CLKIN_125MHz,
	input CLKIN_50MHz,
	input RESET_FOR_CLKIN_50MHz,
	output diagnostic_uart_tx,
	input  diagnostic_uart_rx,
	output slite_phy_and_reconfig_uart_tx,
	input  slite_phy_and_reconfig_uart_rx,
	avalon_st_32_bit_packet_interface  avalon_st_packet_tx_out,
	avalon_st_32_bit_packet_interface  avalon_st_packet_rx_in,	
	output [7:0] current_rx_packet_id,
	output rx_clk,
	input wire [91:0]  reconfig_from_xcvr,
	input wire [139:0] reconfig_to_xcvr,
    input wire       DIAGNOSTIC_UART_IS_SECONDARY_UART,
    input wire [7:0] DIAGNOSTIC_UART_NUM_SECONDARY_UARTS,
    input wire [7:0] DIAGNOSTIC_UART_ADDRESS_OF_THIS_UART,    
	input wire       SLITE_PHY_AND_RECONFIG_UART_IS_SECONDARY_UART,
    input wire [7:0] SLITE_PHY_AND_RECONFIG_UART_NUM_SECONDARY_UARTS,
    input wire [7:0] SLITE_PHY_AND_RECONFIG_UART_ADDRESS_OF_THIS_UART
);

arria_v_seriallite_ii_custom_phy_interface serialite_channel_custom_phy_interface();

import uart_regfile_types::*;


wire [15:0] avalon_st_tx_packet_length_in_bytes;
wire [47:0] avalon_st_tx_packet_count;
wire [63:0] avalon_st_tx_total_byte_count;
wire        avalon_st_tx_packet_ended_now;

determine_avalon_st_packet_length
determine_tx_avalon_st_packet_length
(
.avalon_st_interface_in(avalon_st_packet_tx_out),
.reset_n(reset_serialite_n),
.packet_length_in_bytes(avalon_st_tx_packet_length_in_bytes),
.raw_packet_length(),
.packet_count(avalon_st_tx_packet_count),
.total_byte_count(avalon_st_tx_total_byte_count),
.packet_ended_now(avalon_st_tx_packet_ended_now)
);


wire [15:0] avalon_st_rx_packet_length_in_bytes;
wire [47:0] avalon_st_rx_packet_count;
wire [63:0] avalon_st_rx_total_byte_count;
wire        avalon_st_rx_packet_ended_now;

determine_avalon_st_packet_length
determine_rx_avalon_st_packet_length
(
.avalon_st_interface_in(avalon_st_packet_rx_in),
.reset_n(reset_serialite_n),
.packet_length_in_bytes(avalon_st_rx_packet_length_in_bytes),
.raw_packet_length(),
.packet_count(avalon_st_rx_packet_count),
.total_byte_count(avalon_st_rx_total_byte_count),
.packet_ended_now(avalon_st_rx_packet_ended_now)
);

reg [31:0] current_tx_word_counter = 0;
reg [31:0] current_tx_packet_counter = 0;

reg [31:0] current_rx_word_counter = 0;
reg [31:0] current_rx_packet_counter = 0;

reg [7:0] current_tx_packet_id_counter = 0;

wire xcvr_loopback_enable;
wire actual_xcvr_loopback_enable;
	wire reset_serialite_n;

	
	/* input	*/ logic     	rxin;
	/* input	*/ logic     	ctrl_tc_force_train;
	/* input	*/ logic     	trefclk;
	/* input	*/ logic     	gxb_powerdown;
	(* keep = 1 *)/* input	*/ logic     	mreset_n;
	(* keep = 1 *)/* input	*/ logic     	rxhpp_clk;
	(* keep = 1 *)/* input	*/ logic     	rxhpp_ena;
	(* keep = 1 *)/* input	*/ logic     [7:0]	ctl_rxhpp_ftl;
	(* keep = 1 *)/* input	*/ logic     	    ctl_rxhpp_eopdav;
	(* keep = 1 *)/* input	*/ logic     	    txhpp_clk;
	(* keep = 1 *)/* input	*/ logic     	    txhpp_ena;
	(* keep = 1 *)/* input	*/ logic     	    txhpp_sop;
	(* keep = 1 *)/* input	*/ logic     	    txhpp_eop;
	(* keep = 1 *)/* input	*/ logic     	    txhpp_err;
	(* keep = 1 *)/* input	*/ logic     [1:0]	txhpp_mty;
	(* keep = 1 *)/* input	*/ logic     [31:0]	txhpp_dat;
	(* keep = 1 *)/* input	*/ logic     [7:0]	txhpp_adr;
	(* keep = 1 *)/* input	*/ logic     [7:0]	ctl_txhpp_fth;
	(* keep = 1 *)/* input	*/ logic     	ctrl_tc_serial_lpbena;
	/* input	*/ logic     	reconfig_clk;

	/* output	*/ logic     	rrefclk;
	/* output	*/ logic     	txout;
	
	/* output	*/ logic     	tx_coreclock;
	/* output	*/ logic     	rcvd_clk_out;
	(* keep = 1 *) /* output	*/ logic     	rxhpp_sop;
	(* keep = 1 *) /* output	*/ logic     	rxhpp_eop;
	(* keep = 1 *) /* output	*/ logic     	rxhpp_err;
	(* keep = 1 *) /* output	*/ logic     [1:0]	rxhpp_mty;
	(* keep = 1 *) /* output	*/ logic     [31:0]	rxhpp_dat;
	(* keep = 1 *) /* output	*/ logic     [7:0]	rxhpp_adr;
    (* keep = 1 *) /* output	*/ logic     	txhpp_dav;	
	(* keep = 1 *) /* output	*/ logic    rxhpp_val;	
    (* keep = 1 *) /* output	*/ logic    rxhpp_dav;
	
    (* keep = 1 *)	/* output	*/ logic            stat_rr_link;
    (* keep = 1 *)	/* output	*/ logic     [3:0]	stat_rr_gxsync;
	(* keep = 1 *) /* output	*/ logic     	    stat_rr_freqlock;
	(* keep = 1 *) /* output	*/ logic            stat_rr_rxlocked;
	(* keep = 1 *)/* output	*/ logic     [3:0]	stat_rr_pattdet;
	(* keep = 1 *)/* output	*/ logic     	    stat_tc_pll_locked;
	(* keep = 1 *) /* output	*/ logic     	    stat_tc_rst_done;
	(* keep = 1 *) /* output	*/ logic     	    stat_tc_foffre_empty;
	(* keep = 1 *) /* output	*/ logic     	    stat_rr_ebprx;
	(* keep = 1 *) /* output	*/ logic     	    stat_rxhpp_empty;
	
	(* keep = 1 *) /* output	*/ logic  [3:0]	err_rr_8berrdet;
	(* keep = 1 *) /* output	*/ logic  [3:0]	err_rr_disp;
	(* keep = 1 *) /* output	*/ logic     	err_rr_pcfifo_uflw;
	(* keep = 1 *) /* output	*/ logic     	err_rr_pcfifo_oflw;
	(* keep = 1 *) /* output	*/ logic     	err_rr_rlv;
	(* keep = 1 *) /* output	*/ logic     	err_tc_rxhpp_oflw;
	(* keep = 1 *) /* output	*/ logic     	err_tc_pcfifo_oflw;
	(* keep = 1 *) /* output	*/ logic     	err_tc_pcfifo_uflw;
	(* keep = 1 *) /* output	*/ logic     	err_txhpp_oflw;
	(* keep = 1 *) /* output	*/ logic     	err_rr_foffre_oflw;
	(* keep = 1 *) /* output	*/ logic     	err_rr_bip8;
	(* keep = 1 *) /* output	*/ logic     	err_rr_crc;
	(* keep = 1 *) /* output	*/ logic     	err_rr_fcrx_bne;
	(* keep = 1 *) /* output	*/ logic     	err_rr_roerx_bne;
	(* keep = 1 *) /* output	*/ logic     	err_rr_invalid_lmprx;
	(* keep = 1 *) /* output	*/ logic     	err_rr_missing_start_dcw;
	(* keep = 1 *) /* output	*/ logic     	err_rr_addr_mismatch;
	(* keep = 1 *) /* output	*/ logic     	err_rr_pol_rev_required;
    (* keep = 1 *) /* output	*/ logic        err_tc_roe_rsnd_gt4;
	(* keep = 1 *) /* output	*/ logic        stat_tc_roe_timeout;
	(* keep = 1 *) /* output	*/ logic        stat_rr_roe_ack;
	(* keep = 1 *) /* output	*/ logic        stat_rr_roe_nack;
	(* keep = 1 *) /* output	*/ logic        err_tc_is_drop;
	(* keep = 1 *) /* output	*/ logic        err_tc_lm_fifo_oflw;
	(* keep = 1 *) /* output	*/ logic        err_rr_rx2txfifo_oflw;
	(* keep = 1 *) /* output	*/ logic		stat_rr_fc_rdp_valid;
	(* keep = 1 *) /* output	*/ logic		stat_rr_fc_hpp_valid;
	(* keep = 1 *) /* output	*/ logic[7:0]	stat_rr_fc_value;
	(* keep = 1 *) /* output	*/ logic		stat_tc_fc_rdp_retransmit;
	(* keep = 1 *) /* output	*/ logic		stat_tc_fc_hpp_retransmit;
	(* keep = 1 *) /* output	*/ logic		stat_tc_rdp_thresh_breach;
	(* keep = 1 *) /* output	*/ logic		stat_tc_hpp_thresh_breach;
	(* keep = 1 *) wire [7:0] controlled_tx_adr;
	
    (* keep = 1 *) logic	[31:0]	tx_parallel_data_in;
	(* keep = 1 *) logic	[3:0]	tx_ctrlenable;
	(* keep = 1 *) logic [31:0]     rx_parallel_data_out;
	(* keep = 1 *) logic 	        rx_coreclk;
	(* keep = 1 *) logic 	        tx_coreclk;
	(* keep = 1 *) logic [3:0]	    rx_ctrldetect;
	(* keep = 1 *) logic 	        flip_polarity;
	(* keep = 1 *) logic            rx_is_lockedtoref;
	(* keep = 1 *) logic            rx_bitslipboundaryselectout;
	(* keep = 1 *) logic            rx_is_lockedtodata;
	(* keep = 1 *) logic            rx_signaldetect;
	(* keep = 1 *) logic [3:0]      rx_runningdisp;
	(* keep = 1 *) logic phy_mgmt_clk;
   (* keep = 1 *)  reg phy_mgmt_clk_reset_n = 0;
   
   (* keep = 1 *) wire xcvr_tx_ready ;
   (* keep = 1 *) wire xcvr_rx_ready  ;
   (* keep = 1 *) wire tx_forceelecidle;
   
	wire override_ready;
	wire actual_override_ready;
	wire override_tx_ready;
	wire actual_override_tx_ready;
	
	
assign reconfig_clk = CLKIN_50MHz;

(* keep = 1 *)  wire [31:0] slite_error = {
    1'b0,err_tc_is_drop,err_tc_lm_fifo_oflw,err_rr_rx2txfifo_oflw,
    err_rr_8berrdet[3:0],
    err_rr_disp[3:0],
 	err_rr_pcfifo_uflw,  	err_rr_pcfifo_oflw, 	err_rr_rlv, 	err_tc_rxhpp_oflw, 	
	err_tc_pcfifo_oflw, 	err_tc_pcfifo_uflw, 	err_txhpp_oflw, 		err_rr_foffre_oflw,
 	err_rr_bip8, 	         err_rr_crc, 	err_rr_fcrx_bne, 	err_rr_roerx_bne,
 	err_rr_invalid_lmprx, 	err_rr_missing_start_dcw, 	err_rr_addr_mismatch, 	err_rr_pol_rev_required
};

(* keep = 1 *)  wire [31:0] slite_status = {
  flip_polarity,
  1'b0,1'b0,rxhpp_dav,txhpp_dav, 
  stat_rr_gxsync [3:0],
  stat_rr_pattdet [3:0],
  stat_rr_freqlock,  stat_rr_rxlocked,    stat_tc_pll_locked, stat_rr_link,
  stat_tc_rst_done,  stat_tc_foffre_empty,  stat_rr_ebprx,  stat_rxhpp_empty
 };
 
(* keep = 1 *)  wire [31:0] custom_phy_status = {
    rx_bitslipboundaryselectout, 
	2'b0, rx_signaldetect, rx_is_lockedtodata,
    2'b0, xcvr_tx_ready, xcvr_rx_ready,
    rx_runningdisp[3:0],
	rx_ctrldetect[3:0],
    tx_ctrlenable[3:0]
};

doublesync_no_reset #(.synchronizer_depth(synchronizer_depth))
sync_xcvr_loopback_enable
(
.indata(xcvr_loopback_enable),
.outdata(actual_xcvr_loopback_enable),
.clk(tx_coreclock)
);

doublesync_no_reset #(.synchronizer_depth(synchronizer_depth))
sync_override_ready
(
.indata(override_ready),
.outdata(actual_override_ready),
.clk(rxhpp_clk)
);
		
doublesync_no_reset #(.synchronizer_depth(synchronizer_depth))
sync_override_tx_ready
(
.indata(override_tx_ready),
.outdata(actual_override_tx_ready),
.clk(txhpp_clk)
);

(* keep = 1 *) wire [7:0] atlantic_to_st_converter_fifo_usedw;
(* keep = 1 *) wire       atlantic_to_st_converter_fifo_almost_empty ;
(* keep = 1 *) wire       atlantic_to_st_converter_fifo_almost_full  ;
(* keep = 1 *) wire       atlantic_to_st_converter_fifo_empty        ;
(* keep = 1 *) wire       atlantic_to_st_converter_fifo_full       ;
(* keep = 1 *) wire       atlantic_to_st_converter_fifo_flush;  
		

	
	atlantic_32_bit_packet_interface txout_atlantic_interface();
	atlantic_32_bit_packet_interface rxin_atlantic_interface();
	
	convert_from_priority_atlantic_interface_to_avalon_st_sink
	convert_from_priority_atlantic_interface_to_avalon_st_sink_inst
	(
	.atlantic_packet(rxin_atlantic_interface),
	.avalon_st_packet_to_sink(avalon_st_packet_rx_in                     ),
	.override_avalon_st_ready(actual_override_ready                      ),
    .fifo_usedw              (atlantic_to_st_converter_fifo_usedw        ),
    .fifo_almost_empty       (atlantic_to_st_converter_fifo_almost_empty ),	
    .fifo_almost_full        (atlantic_to_st_converter_fifo_almost_full  ),	
    .fifo_empty              (atlantic_to_st_converter_fifo_empty        ),	
    .fifo_full               (atlantic_to_st_converter_fifo_full         ),	
    .fifo_flush   	         (atlantic_to_st_converter_fifo_flush        ),  	
	.reset_n                 (mreset_n)
	);
	
	convert_from_avalon_st_source_to_atlantic
	convert_from_avalon_st_source_to_atlantic_inst
	(
	.avalon_st_packet_from_source(avalon_st_packet_tx_out),
	.atlantic_packet(txout_atlantic_interface),
	.override_avalon_st_ready(actual_override_tx_ready),
	.atlantic_adr(controlled_tx_adr)
	);
	
assign gxb_powerdown = 1'b0;	
assign rxin = XCVR_RX;
assign XCVR_TX = txout;
assign ctrl_tc_force_train = 1'b0;
assign trefclk = CLKIN_125MHz;
assign mreset_n = reset_serialite_n;
assign rx_clk = rrefclk;
assign ctrl_tc_serial_lpbena = actual_xcvr_loopback_enable;


assign rxhpp_clk = rxin_atlantic_interface.clk;
assign rxhpp_ena = rxin_atlantic_interface.ena;
assign rxin_atlantic_interface.dav = rxhpp_dav;
assign rxin_atlantic_interface.val = rxhpp_val;
assign rxin_atlantic_interface.sop = rxhpp_sop;
assign rxin_atlantic_interface.eop = rxhpp_eop;
assign rxin_atlantic_interface.mty = rxhpp_mty;
assign rxin_atlantic_interface.err = rxhpp_err;
assign rxin_atlantic_interface.dat = rxhpp_dat;
assign rxin_atlantic_interface.adr = rxhpp_adr;

assign current_rx_packet_id = rxin_atlantic_interface.adr;

assign txout_atlantic_interface.dav = txhpp_dav;
assign txhpp_clk = txout_atlantic_interface.clk;
assign txhpp_ena = txout_atlantic_interface.ena;
assign txhpp_sop = txout_atlantic_interface.sop;
assign txhpp_eop = txout_atlantic_interface.eop;
assign txhpp_err = txout_atlantic_interface.err;
assign txhpp_mty = txout_atlantic_interface.mty;
assign txhpp_dat = txout_atlantic_interface.dat;
assign txhpp_adr = txout_atlantic_interface.adr;
wire txhpp_sop_edge_det_wire;

edge_detector 
txhpp_sop_edge_detector
(
 .insignal (txhpp_sop), 
 .outsignal(txhpp_sop_edge_det_wire), 
 .clk      (txhpp_clk)
);
/*
always @(posedge txhpp_clk or negedge reset_serialite_n)
begin
       if (~reset_serialite_n) 
	   begin
	        current_tx_word_counter <= 0;
	   end else
	   begin
			   if (txhpp_ena && txhpp_dav)
			   begin
					current_tx_word_counter <= current_tx_word_counter + 1;	   
			   end  
       end	   
end
*/

always @(posedge txhpp_clk or negedge reset_serialite_n)
begin
       if (~reset_serialite_n) 
	   begin
	        current_tx_packet_counter <= 0;
	   end else
       begin
			   if (txhpp_sop_edge_det_wire)
			   begin
					current_tx_packet_counter <= current_tx_packet_counter + 1;	   
			   end 
	   end
end

wire rxhpp_sop_edge_det_wire;
edge_detector 
rxhpp_sop_edge_detector
(
 .insignal (rxhpp_sop), 
 .outsignal(rxhpp_sop_edge_det_wire), 
 .clk      (rxhpp_clk)
);
/*
always @(posedge rxhpp_clk or negedge reset_serialite_n)
begin
       if (~reset_serialite_n) 
	   begin
	        current_rx_word_counter <= 0;
	   end else 
	   begin
		   if (rxhpp_val)
		   begin
				current_rx_word_counter <= current_rx_word_counter + 1;	   
		   end  
       end 	   
end
*/
always @(posedge rxhpp_clk or negedge reset_serialite_n)
begin
       if (~reset_serialite_n) 
	   begin
	         current_rx_packet_counter <= 0;
	   end else
	   begin
		   if (rxhpp_sop_edge_det_wire)
		   begin
				current_rx_packet_counter <= current_rx_packet_counter + 1;	   
		   end 
	   end
end

 (* keep = 1 *) wire [6:0]     reconfig_mgmt_address     ;    
 (* keep = 1 *) wire           reconfig_mgmt_read        ;    
 (* keep = 1 *) wire [31:0]    reconfig_mgmt_readdata    ;
 (* keep = 1 *) wire           reconfig_mgmt_waitrequest ;
 (* keep = 1 *) wire           reconfig_mgmt_write       ;      
 (* keep = 1 *) wire [31:0]    reconfig_mgmt_writedata   ;  
 (* keep = 1 *) wire           reconfig_reset;

serialite_xcvr_priority_only_logical_channel_0
serialite_xcvr_priority_only_inst
 (
	//.rxin                         ( rxin                        ),
	//.trefclk                      ( trefclk                     ),
	.mreset_n                     ( mreset_n                    ),
	.rxhpp_clk                    ( rxhpp_clk                   ),
	.rxhpp_ena                    ( rxhpp_ena                   ),
	.ctl_rxhpp_ftl                ( ctl_rxhpp_ftl               ),
	.ctl_rxhpp_eopdav             ( ctl_rxhpp_eopdav            ),
	.txhpp_clk                    ( txhpp_clk                   ),
	.txhpp_ena                    ( txhpp_ena                   ),
	.txhpp_sop                    ( txhpp_sop                   ),
	.txhpp_eop                    ( txhpp_eop                   ),
	.txhpp_err                    ( txhpp_err                   ),
	.txhpp_mty                    ( txhpp_mty                   ),
	.txhpp_dat                    ( txhpp_dat                   ),
	.txhpp_adr                    ( txhpp_adr                   ),
	.ctl_txhpp_fth                ( ctl_txhpp_fth               ),
	.rrefclk                      ( rrefclk                     ),
	.stat_rr_link                 ( stat_rr_link                ),
	//.txout                        ( txout                       ),
	//.stat_tc_pll_locked           ( stat_tc_pll_locked          ),
	.tx_coreclock                 ( tx_coreclock                ),
	//.err_rr_8berrdet              ( err_rr_8berrdet             ),
	.err_rr_disp                  ( err_rr_disp                 ),
	//.err_rr_rlv                   ( err_rr_rlv                  ),
	//.stat_rr_gxsync               ( stat_rr_gxsync              ),
	//.stat_rr_freqlock             ( stat_rr_freqlock            ),
	.stat_rr_pattdet              ( stat_rr_pattdet             ),
	.rxhpp_sop                    ( rxhpp_sop                   ),
	.rxhpp_eop                    ( rxhpp_eop                   ),
	.rxhpp_err                    ( rxhpp_err                   ),
	.rxhpp_mty                    ( rxhpp_mty                   ),
	.rxhpp_dat                    ( rxhpp_dat                   ),
	.rxhpp_adr                    ( rxhpp_adr                   ),
	.rxhpp_val                    ( rxhpp_val                   ),
	.rxhpp_dav                    ( rxhpp_dav                   ),
	.stat_rxhpp_empty             ( stat_rxhpp_empty            ),
	.err_tc_rxhpp_oflw            ( err_tc_rxhpp_oflw           ),
	.err_txhpp_oflw               ( err_txhpp_oflw              ),
	.txhpp_dav                    ( txhpp_dav                   ),
	.err_rr_foffre_oflw           ( err_rr_foffre_oflw          ),
	.stat_tc_foffre_empty         ( stat_tc_foffre_empty        ),
	.stat_rr_ebprx                ( stat_rr_ebprx               ),
	.err_rr_bip8                  ( err_rr_bip8                 ),
	.err_rr_crc                   ( err_rr_crc                  ),
  //.err_rr_fcrx_bne              ( err_rr_fcrx_bne             ),
  //.err_rr_roerx_bne             ( err_rr_roerx_bne            ),
	.err_rr_invalid_lmprx         ( err_rr_invalid_lmprx        ),
	.err_rr_missing_start_dcw     ( err_rr_missing_start_dcw    ),
	.err_rr_addr_mismatch         ( err_rr_addr_mismatch        ),
	.err_rr_pol_rev_required      ( err_rr_pol_rev_required     ),
	.err_tc_roe_rsnd_gt4          ( err_tc_roe_rsnd_gt4         ),
	.stat_tc_roe_timeout          ( stat_tc_roe_timeout         ),
	.stat_rr_roe_ack              ( stat_rr_roe_ack             ),
	.stat_rr_roe_nack             ( stat_rr_roe_nack            ),
    .err_tc_is_drop               (err_tc_is_drop               ),
    .err_tc_lm_fifo_oflw          (err_tc_lm_fifo_oflw          ),
    .err_rr_rx2txfifo_oflw        (err_rr_rx2txfifo_oflw        ),
	.stat_rr_fc_rdp_valid         (stat_rr_fc_rdp_valid),
	.stat_rr_fc_hpp_valid         (stat_rr_fc_hpp_valid),
	.stat_rr_fc_value             (stat_rr_fc_value),
	.stat_tc_fc_rdp_retransmit    (stat_tc_fc_rdp_retransmit),
	.stat_tc_fc_hpp_retransmit    (stat_tc_fc_hpp_retransmit),
	.stat_tc_rdp_thresh_breach    (stat_tc_rdp_thresh_breach),
	.stat_tc_hpp_thresh_breach    (stat_tc_hpp_thresh_breach),
	
	//XCVR Control
	.rx_parallel_data_out          ( rx_parallel_data_out   ),
	.rx_coreclk                    ( rx_coreclk             ),
	.tx_parallel_data_in           ( tx_parallel_data_in    ),
	.tx_ctrlenable                 ( tx_ctrlenable          ),
	.tx_coreclk                    ( tx_coreclk             ),
	.rx_ctrldetect                 ( rx_ctrldetect          ),
	.flip_polarity                 ( flip_polarity          )	
	
	);

	
	 assign xcvr_tx_ready                                               = serialite_channel_custom_phy_interface.tx_ready;
	 assign xcvr_rx_ready                                               = serialite_channel_custom_phy_interface.rx_ready;
	 assign serialite_channel_custom_phy_interface.pll_ref_clk          = CLKIN_125MHz;
	 assign txout                                                       = serialite_channel_custom_phy_interface.tx_serial_data;
	 assign serialite_channel_custom_phy_interface.tx_forceelecidle     = tx_forceelecidle;
	 assign stat_tc_pll_locked                                          = serialite_channel_custom_phy_interface.pll_locked;
	 assign serialite_channel_custom_phy_interface.rx_serial_data       = rxin;
	 assign rx_runningdisp                                              = serialite_channel_custom_phy_interface.rx_runningdisp;
	 assign err_rr_disp                                                 = serialite_channel_custom_phy_interface.rx_disperr;
	 assign err_rr_8berrdet                                             = serialite_channel_custom_phy_interface.rx_errdetect;
	 assign stat_rr_freqlock                                            = serialite_channel_custom_phy_interface.rx_is_lockedtoref;
	 assign rx_is_lockedtodata                                          = serialite_channel_custom_phy_interface.rx_is_lockedtodata;
	 assign rx_signaldetect                                             = serialite_channel_custom_phy_interface.rx_signaldetect;
	 assign stat_rr_pattdet                                             = serialite_channel_custom_phy_interface.rx_patterndetect;
	 assign stat_rr_gxsync                                              = serialite_channel_custom_phy_interface.rx_syncstatus;
	 assign rx_bitslipboundaryselectout                                 = serialite_channel_custom_phy_interface.rx_bitslipboundaryselectout;
	 assign err_rr_rlv                                                  = serialite_channel_custom_phy_interface.rx_rlv;
	 assign serialite_channel_custom_phy_interface.tx_coreclkin         = tx_coreclk;
	 assign serialite_channel_custom_phy_interface.rx_coreclkin         = rx_coreclk;
	 assign tx_coreclk                                                  = serialite_channel_custom_phy_interface.tx_clkout;
	 assign rx_coreclk                                                  = serialite_channel_custom_phy_interface.rx_clkout;
	 assign serialite_channel_custom_phy_interface.tx_parallel_data     = tx_parallel_data_in;
	 assign serialite_channel_custom_phy_interface.tx_datak             = tx_ctrlenable;
	 assign rx_parallel_data_out                                        = serialite_channel_custom_phy_interface.rx_parallel_data;
	 assign rx_ctrldetect                                               = serialite_channel_custom_phy_interface.rx_datak;

			
    parameter local_regfile_data_numbytes        =   4;
    parameter local_regfile_data_width           =   8*local_regfile_data_numbytes;
    parameter local_regfile_desc_numbytes        =  16;
    parameter local_regfile_desc_width           =   8*local_regfile_desc_numbytes;
    parameter num_of_local_regfile_control_regs  =  16;
    parameter num_of_local_regfile_status_regs   =  32;
	
    wire [local_regfile_data_width-1:0] local_regfile_control_regs_default_vals[num_of_local_regfile_control_regs-1:0];
    wire [local_regfile_data_width-1:0] local_regfile_control_regs             [num_of_local_regfile_control_regs-1:0];
    wire [local_regfile_data_width-1:0] local_regfile_control_regs_bitwidth    [num_of_local_regfile_control_regs-1:0];
    wire [local_regfile_data_width-1:0] local_regfile_control_status           [num_of_local_regfile_status_regs-1:0];
    wire [local_regfile_desc_width-1:0] local_regfile_control_desc             [num_of_local_regfile_control_regs-1:0];
    wire [local_regfile_desc_width-1:0] local_regfile_status_desc              [num_of_local_regfile_status_regs-1:0];
	
    wire local_regfile_control_rd_error;
	wire local_regfile_control_async_reset = 1'b0;
	wire local_regfile_control_wr_error;
	wire local_regfile_control_transaction_error;
	
	
	wire [3:0] local_regfile_main_sm;
	wire [2:0] local_regfile_tx_sm;
	wire [7:0] local_regfile_command_count;
	
	assign local_regfile_control_regs_default_vals[0]  =  0;
    assign local_regfile_control_desc[0]               = "ctrlled_tx_adr";
    assign controlled_tx_adr                           = local_regfile_control_regs[0];
    assign local_regfile_control_regs_bitwidth[0]      = 8;		
	 
	 
	assign local_regfile_control_regs_default_vals[1] = ctl_rxhpp_ftl_DEFAULT;
    assign local_regfile_control_desc[1] = "ctl_rxhpp_ftl";
    assign ctl_rxhpp_ftl                 = local_regfile_control_regs[1];
    assign local_regfile_control_regs_bitwidth[1] = 8;		
	 
	assign local_regfile_control_regs_default_vals[2] = ctl_rxhpp_eopdav_DEFAULT;
    assign local_regfile_control_desc[2] = "ctl_rxhpp_eopdav";
    assign ctl_rxhpp_eopdav = local_regfile_control_regs[2];
    assign local_regfile_control_regs_bitwidth[2] = 1;		
	 
	assign local_regfile_control_regs_default_vals[3] = ctl_txhpp_fth_DEFAULT;
    assign local_regfile_control_desc[3] = "ctl_txhpp_fth";
    assign ctl_txhpp_fth    = local_regfile_control_regs[3];
    assign local_regfile_control_regs_bitwidth[3] = 16;			
	
	assign local_regfile_control_regs_default_vals[4] = 0;
    assign local_regfile_control_desc[4] = "loopback_enable";
    assign xcvr_loopback_enable  = local_regfile_control_regs[4];
    assign local_regfile_control_regs_bitwidth[4] = 1;		
	 
	assign local_regfile_control_regs_default_vals[5] = 1;
    assign local_regfile_control_desc[5] = "resetSerialite_n";
    assign reset_serialite_n = local_regfile_control_regs[5];
    assign local_regfile_control_regs_bitwidth[5] = 1;		
	
	
	assign local_regfile_control_regs_default_vals[6] = 0;
    assign local_regfile_control_desc[6] = "ovrride_rx_ready";
    assign override_ready = local_regfile_control_regs[6];
    assign local_regfile_control_regs_bitwidth[6] = 1;		
	 
	assign local_regfile_control_regs_default_vals[7] = 0;
    assign local_regfile_control_desc[7] = "ovrride_tx_ready";
    assign override_tx_ready = local_regfile_control_regs[7];
    assign local_regfile_control_regs_bitwidth[7] = 1;		
	 
	assign local_regfile_control_regs_default_vals[8] = 0;
    assign local_regfile_control_desc[8] = "atlConvFifoFlush";
    assign atlantic_to_st_converter_fifo_flush = local_regfile_control_regs[8];
    assign local_regfile_control_regs_bitwidth[8] = 1;		
	/*
	assign local_regfile_control_regs_default_vals[9] = 1;
    assign local_regfile_control_desc[9] = "reconfigReset_n";
    assign arria_v_xcvr_reconfig_reset_n  = local_regfile_control_regs[9];
    assign local_regfile_control_regs_bitwidth[9] = 1;		
	*/
	assign local_regfile_control_regs_default_vals[10] = 0;
    assign local_regfile_control_desc[10] = "txForceElecIdle";
    assign tx_forceelecidle  = local_regfile_control_regs[10];
    assign local_regfile_control_regs_bitwidth[10] = 1;	
	
	 
	assign local_regfile_control_status[0] = 32'h12345678;
	assign local_regfile_status_desc[0]    ="StatusAlive";
		
    assign local_regfile_control_status[1] =  slite_status;
	assign local_regfile_status_desc[1]    = "slite_status";
	  
    assign local_regfile_control_status[2] = slite_error;
	assign local_regfile_status_desc[2]    = "slite_error"; 

    assign local_regfile_control_status[3] = avalon_st_packet_rx_in.data;
	assign local_regfile_status_desc[3]    = "rx_in_data"; 

    assign local_regfile_control_status[4] = avalon_st_packet_tx_out.data;
	assign local_regfile_status_desc[4]    = "tx_out_data"; 

    assign local_regfile_control_status[5] = current_rx_packet_id;
	assign local_regfile_status_desc[5]    = "rx_packet_id"; 
	
	assign local_regfile_control_status[6] = custom_phy_status;			 
	assign local_regfile_status_desc[6]    = "CustomPhyStatus"; 

	assign local_regfile_control_status[7] = {avalon_st_packet_rx_in.ready,avalon_st_packet_rx_in.valid,avalon_st_packet_rx_in.sop,
	                                          avalon_st_packet_rx_in.eop,avalon_st_packet_rx_in.empty[1:0],avalon_st_packet_rx_in.error};
	assign local_regfile_status_desc[7]    = "rx_pkt_sigs"; 
	
	
	assign local_regfile_control_status[8] = {avalon_st_packet_tx_out.ready,avalon_st_packet_tx_out.valid,avalon_st_packet_tx_out.sop,
	                                          avalon_st_packet_tx_out.eop,avalon_st_packet_tx_out.empty[1:0],avalon_st_packet_tx_out.error};
	assign local_regfile_status_desc[8]    = "tx_pkt_sigs"; 
	
	
    assign local_regfile_control_status[9] = rxin_atlantic_interface.dat;
	assign local_regfile_status_desc[9]    = "atl_rx_in_data"; 

    assign local_regfile_control_status[10] = txout_atlantic_interface.dat;
	assign local_regfile_status_desc[10]    = "atl_tx_out_data"; 
	
    assign local_regfile_control_status[11] = {
	                                          rxin_atlantic_interface.eop,
	                                          rxin_atlantic_interface.sop,
											  rxin_atlantic_interface.ena,
	                                          rxin_atlantic_interface.dav,
											  rxin_atlantic_interface.mty[1:0],
											  rxin_atlantic_interface.val,
											  rxin_atlantic_interface.err
											  };
	assign local_regfile_status_desc[11]    = "atl_rx_pkt_sigs"; 
	
	
	assign local_regfile_control_status[12] =  {
	                                          txout_atlantic_interface.eop,
	                                          txout_atlantic_interface.sop,
											  txout_atlantic_interface.ena,
	                                          txout_atlantic_interface.dav,
											  txout_atlantic_interface.mty[1:0],
											  txout_atlantic_interface.val,
											  txout_atlantic_interface.err
											  };
	assign local_regfile_status_desc[12]    = "atl_tx_pkt_sigs"; 
	
	
	assign local_regfile_control_status[13] =  {
	                                          err_tc_roe_rsnd_gt4,
	                                          stat_tc_roe_timeout,
	                                          stat_rr_roe_ack,
	                                          stat_rr_roe_nack
											           };
	assign local_regfile_status_desc[13]    = "RetryOnErrorStat"; 
	
	assign local_regfile_control_status[14] = 
			{
			 stat_tc_rdp_thresh_breach,
	         stat_tc_hpp_thresh_breach,			
			 stat_rr_fc_rdp_valid,
	         stat_rr_fc_hpp_valid,		     
	         stat_tc_fc_rdp_retransmit,
	         stat_tc_fc_hpp_retransmit,
			 stat_rr_fc_value
			 };
			 
	assign local_regfile_status_desc[14]    = "FlowCtrlStats"; 

	assign local_regfile_control_status[15] = 
			{
			 atlantic_to_st_converter_fifo_almost_empty,
			 atlantic_to_st_converter_fifo_almost_full,
			 atlantic_to_st_converter_fifo_empty,
			 atlantic_to_st_converter_fifo_full,
			 atlantic_to_st_converter_fifo_usedw
			 };
			 
	assign local_regfile_status_desc[15]    = "AtlToSTFifoStats"; 
	
	assign local_regfile_control_status[16] = current_tx_packet_counter;
	assign local_regfile_status_desc[16]    = "tx_packet_cnt"; 
	
	assign local_regfile_control_status[17] = avalon_st_tx_packet_length_in_bytes;
	assign local_regfile_status_desc[17]    = "tx_pkt_len_bytes"; 
	

	
	assign local_regfile_control_status[19] = avalon_st_rx_packet_length_in_bytes;
	assign local_regfile_status_desc[19]    = "rx_pkt_len_bytes"; 
	
	assign local_regfile_control_status[20] = avalon_st_tx_packet_count[47:32];
	assign local_regfile_status_desc[20]    = "tx_pkt_cnt_47_32"; 
	
	assign local_regfile_control_status[21] = avalon_st_tx_packet_count[31:0];
	assign local_regfile_status_desc[21]    = "tx_pkt_cnt_31_0"; 
	
	assign local_regfile_control_status[22] = avalon_st_rx_packet_count[47:32];
	assign local_regfile_status_desc[22]    = "rx_pkt_cnt_47_32"; 
	
	assign local_regfile_control_status[23] = avalon_st_rx_packet_count[31:0];
	assign local_regfile_status_desc[23]    = "rx_pkt_cnt_31_0"; 
			
	assign local_regfile_control_status[24] = avalon_st_tx_total_byte_count[63:32];
	assign local_regfile_status_desc[24]    = "tx_byt_cnt_63_32"; 
	
	assign local_regfile_control_status[25] = avalon_st_tx_total_byte_count[31:0];
	assign local_regfile_status_desc[25]    = "tx_byt_cnt_31_0"; 
	
	assign local_regfile_control_status[26] = avalon_st_rx_total_byte_count[63:32];
	assign local_regfile_status_desc[26]    = "rx_byt_cnt_63_32"; 
	
	assign local_regfile_control_status[27] = avalon_st_rx_total_byte_count[31:0];
	assign local_regfile_status_desc[27]    = "rx_byt_cnt_31_0"; 
	
	assign local_regfile_control_status[28] = tx_parallel_data_in;			 
	assign local_regfile_status_desc[28]    = "txParDatIn"; 

	assign local_regfile_control_status[29] = rx_parallel_data_out;			 
	assign local_regfile_status_desc[29]    = "rxParDatOut"; 

	uart_controlled_register_file_ver3
	#( 
	  .NUM_OF_CONTROL_REGS(num_of_local_regfile_control_regs),
	  .NUM_OF_STATUS_REGS(num_of_local_regfile_status_regs),
	  .DATA_WIDTH_IN_BYTES  (local_regfile_data_numbytes),
      .DESC_WIDTH_IN_BYTES  (local_regfile_desc_numbytes),
	  .INIT_ALL_CONTROL_REGS_TO_DEFAULT (1'b0),  
	  .CONTROL_REGS_DEFAULT_VAL         (0),
	  .CLOCK_SPEED_IN_HZ(50000000),
      .UART_BAUD_RATE_IN_HZ(REGFILE_BAUD_RATE)
	)
	local_uart_register_file
	(	
	 .DISPLAY_NAME(diagnostic_uart_name),
	 .CLK(CLKIN_50MHz),
	 .REG_ACTIVE_HIGH_ASYNC_RESET(local_regfile_control_async_reset),
	 .CONTROL(local_regfile_control_regs),
	 .CONTROL_DESC(local_regfile_control_desc),
	 .CONTROL_BITWIDTH(local_regfile_control_regs_bitwidth),
	 .STATUS(local_regfile_control_status),
	 .STATUS_DESC (local_regfile_status_desc),
	 .CONTROL_INIT_VAL(local_regfile_control_regs_default_vals),
	 .TRANSACTION_ERROR(local_regfile_control_transaction_error),
	 .WR_ERROR(local_regfile_control_wr_error),
	 .RD_ERROR(local_regfile_control_rd_error),
	 .USER_TYPE(uart_regfile_types::GENERIC_UART_REGFILE),
	 .NUM_SECONDARY_UARTS (DIAGNOSTIC_UART_NUM_SECONDARY_UARTS),
     .ADDRESS_OF_THIS_UART(DIAGNOSTIC_UART_ADDRESS_OF_THIS_UART),
     .IS_SECONDARY_UART   (DIAGNOSTIC_UART_IS_SECONDARY_UART),	 
	 
	 //UART
	 .uart_active_high_async_reset(1'b0),
	 .rxd(diagnostic_uart_rx),
	 .txd(diagnostic_uart_tx),
	 
	 //UART DEBUG
	 .main_sm               (local_regfile_main_sm),
	 .tx_sm                 (local_regfile_tx_sm),
	 .command_count         (local_regfile_command_count)
	  
	);
	

parameter slit_phy_and_reconfig_local_regfile_address_numbits         =  16;
parameter slit_phy_and_reconfig_local_regfile_data_numbytes           =  4;
parameter slit_phy_and_reconfig_local_regfile_desc_numbytes           =  16;
parameter slit_phy_and_reconfig_num_of_local_regfile_control_regs     =  32'hA00;

	
uart_wishbone_bridge_interface 	
#(                                                                                                     
  .DATA_NUMBYTES                                (slit_phy_and_reconfig_local_regfile_data_numbytes                       ),
  .DESC_NUMBYTES                                (slit_phy_and_reconfig_local_regfile_desc_numbytes                       ),
  .NUM_OF_CONTROL_REGS                          (slit_phy_and_reconfig_num_of_local_regfile_control_regs               ) //taken from QSYS address space
)
phy_and_reconfig_uart_interface_pins();

assign phy_and_reconfig_uart_interface_pins.display_name         = phy_and_reconfig_uart_name;
assign phy_and_reconfig_uart_interface_pins.clk                  = CLKIN_50MHz;
assign phy_and_reconfig_uart_interface_pins.async_reset          = local_regfile_control_async_reset;
assign phy_and_reconfig_uart_interface_pins.user_type            = uart_regfile_types::SERIALLITE_PRIORITY_PACKETS_CTRL_REGFILE;
assign phy_and_reconfig_uart_interface_pins.num_secondary_uarts  = SLITE_PHY_AND_RECONFIG_UART_NUM_SECONDARY_UARTS ; 
assign phy_and_reconfig_uart_interface_pins.address_of_this_uart = SLITE_PHY_AND_RECONFIG_UART_ADDRESS_OF_THIS_UART;
assign phy_and_reconfig_uart_interface_pins.is_secondary_uart    = SLITE_PHY_AND_RECONFIG_UART_IS_SECONDARY_UART   ;
assign phy_and_reconfig_uart_interface_pins.rxd                  = slite_phy_and_reconfig_uart_rx;
assign slite_phy_and_reconfig_uart_tx                            = phy_and_reconfig_uart_interface_pins.txd;

	   avalon_mm_simple_bridge_interface 
		#(
			.num_address_bits(32),
			.num_data_bits(32)
		)
		phy_and_reconfig_avalon_mm_control_interface_pins();

		uart_controlled_avalon_mm_master_no_pipeline_w_interfaces
		#(
			.NUM_OF_CONTROL_REGS   (slit_phy_and_reconfig_num_of_local_regfile_control_regs),
			.DATA_NUMBYTES         (slit_phy_and_reconfig_local_regfile_data_numbytes      ),
			.DESC_NUMBYTES         (slit_phy_and_reconfig_local_regfile_desc_numbytes      ),
			.ADDRESS_WIDTH_IN_BITS (slit_phy_and_reconfig_local_regfile_address_numbits    ),		  
			.CLOCK_SPEED_IN_HZ(50000000),
            .UART_BAUD_RATE_IN_HZ(REGFILE_BAUD_RATE),
			.USE_AUTO_RESET(1'b1),
			.DISABLE_ERROR_MONITORING(1'b1)				
		)
		uart_control_of_arria_v_seriallite_xcvr_standalone_phy_and_reconfig
		(
		 .uart_regfile_interface_pins(phy_and_reconfig_uart_interface_pins),
		 .avalon_mm_slave_interface_pins(phy_and_reconfig_avalon_mm_control_interface_pins)
		);
			
	    arria_v_seriallite_xcvr_standalone_phy_external_reconfig 
        arria_v_seriallite_xcvr_standalone_phy_external_reconfig_inst		(
        .clk_125_mhz_clk                                         (CLKIN_125MHz                                                                          ),                                         //                  clk_125_mhz.clk
        .reset_for_clk_125_mhz_reset_n                           (!RESET_FOR_CLKIN_125MHz                                                               ),                                           //                        reset.reset_n
        .avalon_slave_address                                    (phy_and_reconfig_avalon_mm_control_interface_pins.address                                ),                                    //                 avalon_slave.address
        .avalon_slave_read                                       (phy_and_reconfig_avalon_mm_control_interface_pins.read                                   ),                                       //                             .read
        .avalon_slave_readdata                                   (phy_and_reconfig_avalon_mm_control_interface_pins.readdata                               ),                                   //                             .readdata
        .avalon_slave_write                                      (phy_and_reconfig_avalon_mm_control_interface_pins.write                                  ),                                      //                             .write
        .avalon_slave_writedata                                  (phy_and_reconfig_avalon_mm_control_interface_pins.writedata                              ),                                  //                             .writedata
        .avalon_slave_waitrequest                                (phy_and_reconfig_avalon_mm_control_interface_pins.waitrequest                            ),                                //                             .waitrequest
        .avalon_bridge_reset_50_mhz_reset_n                      (!RESET_FOR_CLKIN_50MHz    ),                      //   avalon_bridge_reset_50_mhz.reset_n
        .avalon_bridge_clock_50_mhz_clk                          ( CLKIN_50MHz                                                      ),                          //   avalon_bridge_clock_50_mhz.clk
        .seriallite_xcvr_phy_control_tx_ready                    (serialite_channel_custom_phy_interface.tx_ready                   ),                    //  seriallite_xcvr_phy_control.tx_ready
        .seriallite_xcvr_phy_control_rx_ready                    (serialite_channel_custom_phy_interface.rx_ready                   ),                    //                             .rx_ready
        .seriallite_xcvr_phy_control_pll_ref_clk                 (serialite_channel_custom_phy_interface.pll_ref_clk                ),                 //                             .pll_ref_clk
        .seriallite_xcvr_phy_control_tx_serial_data              (serialite_channel_custom_phy_interface.tx_serial_data             ),              //                             .tx_serial_data
        .seriallite_xcvr_phy_control_tx_forceelecidle            (serialite_channel_custom_phy_interface.tx_forceelecidle           ),            //                             .tx_forceelecidle
        .seriallite_xcvr_phy_control_pll_locked                  (serialite_channel_custom_phy_interface.pll_locked                 ),                  //                             .pll_locked
        .seriallite_xcvr_phy_control_rx_serial_data              (serialite_channel_custom_phy_interface.rx_serial_data             ),              //                             .rx_serial_data
        .seriallite_xcvr_phy_control_rx_runningdisp              (serialite_channel_custom_phy_interface.rx_runningdisp             ),              //                             .rx_runningdisp
        .seriallite_xcvr_phy_control_rx_disperr                  (serialite_channel_custom_phy_interface.rx_disperr                 ),                  //                             .rx_disperr
        .seriallite_xcvr_phy_control_rx_errdetect                (serialite_channel_custom_phy_interface.rx_errdetect               ),                //                             .rx_errdetect
        .seriallite_xcvr_phy_control_rx_is_lockedtoref           (serialite_channel_custom_phy_interface.rx_is_lockedtoref          ),           //                             .rx_is_lockedtoref
        .seriallite_xcvr_phy_control_rx_is_lockedtodata          (serialite_channel_custom_phy_interface.rx_is_lockedtodata         ),          //                             .rx_is_lockedtodata
        .seriallite_xcvr_phy_control_rx_signaldetect             (serialite_channel_custom_phy_interface.rx_signaldetect            ),             //                             .rx_signaldetect
        .seriallite_xcvr_phy_control_rx_patterndetect            (serialite_channel_custom_phy_interface.rx_patterndetect           ),            //                             .rx_patterndetect
        .seriallite_xcvr_phy_control_rx_syncstatus               (serialite_channel_custom_phy_interface.rx_syncstatus              ),               //                             .rx_syncstatus
        .seriallite_xcvr_phy_control_rx_bitslipboundaryselectout (serialite_channel_custom_phy_interface.rx_bitslipboundaryselectout), //                             .rx_bitslipboundaryselectout
        .seriallite_xcvr_phy_control_rx_rlv                      (serialite_channel_custom_phy_interface.rx_rlv                     ),                      //                             .rx_rlv
        .seriallite_xcvr_phy_control_tx_coreclkin                (serialite_channel_custom_phy_interface.tx_coreclkin               ),                //                             .tx_coreclkin
        .seriallite_xcvr_phy_control_rx_coreclkin                (serialite_channel_custom_phy_interface.rx_coreclkin               ),                //                             .rx_coreclkin
        .seriallite_xcvr_phy_control_tx_clkout                   (serialite_channel_custom_phy_interface.tx_clkout                  ),                   //                             .tx_clkout
        .seriallite_xcvr_phy_control_rx_clkout                   (serialite_channel_custom_phy_interface.rx_clkout                  ),                   //                             .rx_clkout
        .seriallite_xcvr_phy_control_tx_parallel_data            (serialite_channel_custom_phy_interface.tx_parallel_data           ),            //                             .tx_parallel_data
        .seriallite_xcvr_phy_control_tx_datak                    (serialite_channel_custom_phy_interface.tx_datak                   ),                    //                             .tx_datak
        .seriallite_xcvr_phy_control_rx_parallel_data            (serialite_channel_custom_phy_interface.rx_parallel_data           ),            //                             .rx_parallel_data
        .seriallite_xcvr_phy_control_rx_datak                    (serialite_channel_custom_phy_interface.rx_datak                   ),                     //                             .rx_datak
		.reconfig_to_xcvr_export                                 (reconfig_to_xcvr),                                 //            reconfig_to_xcvr.export
        .reconfig_from_xcvr_export                               (reconfig_from_xcvr)                                //          reconfig_from_xcvr.export

    );
	
	
	
endmodule
`default_nettype wire
