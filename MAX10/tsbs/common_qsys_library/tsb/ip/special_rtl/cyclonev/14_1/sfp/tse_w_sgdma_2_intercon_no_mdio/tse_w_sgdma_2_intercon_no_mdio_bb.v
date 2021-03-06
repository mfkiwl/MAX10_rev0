
module tse_w_sgdma_2_intercon_no_mdio (
	avalon_slave_waitrequest,
	avalon_slave_readdata,
	avalon_slave_readdatavalid,
	avalon_slave_burstcount,
	avalon_slave_writedata,
	avalon_slave_address,
	avalon_slave_write,
	avalon_slave_read,
	avalon_slave_byteenable,
	avalon_slave_debugaccess,
	clk_10_clk,
	clk_100_clk,
	clk_50_clk,
	reset_100_reset_n,
	reset_50_reset_n,
	sgdma_rx_csr_irq_irq,
	sgdma_rx_m_write_waitrequest,
	sgdma_rx_m_write_address,
	sgdma_rx_m_write_write,
	sgdma_rx_m_write_writedata,
	sgdma_rx_m_write_byteenable,
	sgdma_tx_csr_irq_irq,
	sgdma_tx_m_read_readdata,
	sgdma_tx_m_read_readdatavalid,
	sgdma_tx_m_read_waitrequest,
	sgdma_tx_m_read_address,
	sgdma_tx_m_read_read,
	sgdma_tx_out_data,
	sgdma_tx_out_valid,
	sgdma_tx_out_ready,
	sgdma_tx_out_endofpacket,
	sgdma_tx_out_startofpacket,
	sgdma_tx_out_empty,
	tse_mac_mac_misc_connection_xon_gen,
	tse_mac_mac_misc_connection_xoff_gen,
	tse_mac_mac_misc_connection_ff_tx_crc_fwd,
	tse_mac_mac_misc_connection_ff_tx_septy,
	tse_mac_mac_misc_connection_tx_ff_uflow,
	tse_mac_mac_misc_connection_ff_tx_a_full,
	tse_mac_mac_misc_connection_ff_tx_a_empty,
	tse_mac_mac_misc_connection_rx_err_stat,
	tse_mac_mac_misc_connection_rx_frm_type,
	tse_mac_mac_misc_connection_ff_rx_dsav,
	tse_mac_mac_misc_connection_ff_rx_a_full,
	tse_mac_mac_misc_connection_ff_rx_a_empty,
	tse_mac_pcs_ref_clk_clock_connection_clk,
	tse_mac_serdes_control_connection_rx_recovclkout,
	tse_mac_serdes_control_connection_reconfig_togxb,
	tse_mac_serdes_control_connection_reconfig_fromgxb,
	tse_mac_serial_connection_rxp,
	tse_mac_serial_connection_txp,
	tse_mac_status_led_connection_crs,
	tse_mac_status_led_connection_link,
	tse_mac_status_led_connection_panel_link,
	tse_mac_status_led_connection_col,
	tse_mac_status_led_connection_an,
	tse_mac_status_led_connection_char_err,
	tse_mac_status_led_connection_disp_err,
	tse_mac_transmit_data,
	tse_mac_transmit_endofpacket,
	tse_mac_transmit_error,
	tse_mac_transmit_empty,
	tse_mac_transmit_ready,
	tse_mac_transmit_startofpacket,
	tse_mac_transmit_valid);	

	output		avalon_slave_waitrequest;
	output	[31:0]	avalon_slave_readdata;
	output		avalon_slave_readdatavalid;
	input	[2:0]	avalon_slave_burstcount;
	input	[31:0]	avalon_slave_writedata;
	input	[12:0]	avalon_slave_address;
	input		avalon_slave_write;
	input		avalon_slave_read;
	input	[3:0]	avalon_slave_byteenable;
	input		avalon_slave_debugaccess;
	input		clk_10_clk;
	input		clk_100_clk;
	input		clk_50_clk;
	input		reset_100_reset_n;
	input		reset_50_reset_n;
	output		sgdma_rx_csr_irq_irq;
	input		sgdma_rx_m_write_waitrequest;
	output	[31:0]	sgdma_rx_m_write_address;
	output		sgdma_rx_m_write_write;
	output	[31:0]	sgdma_rx_m_write_writedata;
	output	[3:0]	sgdma_rx_m_write_byteenable;
	output		sgdma_tx_csr_irq_irq;
	input	[31:0]	sgdma_tx_m_read_readdata;
	input		sgdma_tx_m_read_readdatavalid;
	input		sgdma_tx_m_read_waitrequest;
	output	[31:0]	sgdma_tx_m_read_address;
	output		sgdma_tx_m_read_read;
	output	[31:0]	sgdma_tx_out_data;
	output		sgdma_tx_out_valid;
	input		sgdma_tx_out_ready;
	output		sgdma_tx_out_endofpacket;
	output		sgdma_tx_out_startofpacket;
	output	[1:0]	sgdma_tx_out_empty;
	input		tse_mac_mac_misc_connection_xon_gen;
	input		tse_mac_mac_misc_connection_xoff_gen;
	input		tse_mac_mac_misc_connection_ff_tx_crc_fwd;
	output		tse_mac_mac_misc_connection_ff_tx_septy;
	output		tse_mac_mac_misc_connection_tx_ff_uflow;
	output		tse_mac_mac_misc_connection_ff_tx_a_full;
	output		tse_mac_mac_misc_connection_ff_tx_a_empty;
	output	[17:0]	tse_mac_mac_misc_connection_rx_err_stat;
	output	[3:0]	tse_mac_mac_misc_connection_rx_frm_type;
	output		tse_mac_mac_misc_connection_ff_rx_dsav;
	output		tse_mac_mac_misc_connection_ff_rx_a_full;
	output		tse_mac_mac_misc_connection_ff_rx_a_empty;
	input		tse_mac_pcs_ref_clk_clock_connection_clk;
	output		tse_mac_serdes_control_connection_rx_recovclkout;
	input	[139:0]	tse_mac_serdes_control_connection_reconfig_togxb;
	output	[91:0]	tse_mac_serdes_control_connection_reconfig_fromgxb;
	input		tse_mac_serial_connection_rxp;
	output		tse_mac_serial_connection_txp;
	output		tse_mac_status_led_connection_crs;
	output		tse_mac_status_led_connection_link;
	output		tse_mac_status_led_connection_panel_link;
	output		tse_mac_status_led_connection_col;
	output		tse_mac_status_led_connection_an;
	output		tse_mac_status_led_connection_char_err;
	output		tse_mac_status_led_connection_disp_err;
	input	[31:0]	tse_mac_transmit_data;
	input		tse_mac_transmit_endofpacket;
	input		tse_mac_transmit_error;
	input	[1:0]	tse_mac_transmit_empty;
	output		tse_mac_transmit_ready;
	input		tse_mac_transmit_startofpacket;
	input		tse_mac_transmit_valid;
endmodule
