	linnux_support_reduced_uarts u0 (
		.clk_50_clk                                       (<connected-to-clk_50_clk>),                                       //                                    clk_50.clk
		.counter_64_bit_0_current_count_export            (<connected-to-counter_64_bit_0_current_count_export>),            //            counter_64_bit_0_current_count.export
		.fmc_present_external_connection_export           (<connected-to-fmc_present_external_connection_export>),           //           fmc_present_external_connection.export
		.generic_hdl_info_word_export                     (<connected-to-generic_hdl_info_word_export>),                     //                     generic_hdl_info_word.export
		.gp_fifo_0_control_in_port                        (<connected-to-gp_fifo_0_control_in_port>),                        //                         gp_fifo_0_control.in_port
		.gp_fifo_0_control_out_port                       (<connected-to-gp_fifo_0_control_out_port>),                       //                                          .out_port
		.gp_fifo_0_flags_export                           (<connected-to-gp_fifo_0_flags_export>),                           //                           gp_fifo_0_flags.export
		.gp_fifo_0_read_data_export                       (<connected-to-gp_fifo_0_read_data_export>),                       //                       gp_fifo_0_read_data.export
		.gp_fifo_1_control_in_port                        (<connected-to-gp_fifo_1_control_in_port>),                        //                         gp_fifo_1_control.in_port
		.gp_fifo_1_control_out_port                       (<connected-to-gp_fifo_1_control_out_port>),                       //                                          .out_port
		.gp_fifo_1_flags_export                           (<connected-to-gp_fifo_1_flags_export>),                           //                           gp_fifo_1_flags.export
		.gp_fifo_1_read_data_export                       (<connected-to-gp_fifo_1_read_data_export>),                       //                       gp_fifo_1_read_data.export
		.hires_timer_irq_irq                              (<connected-to-hires_timer_irq_irq>),                              //                           hires_timer_irq.irq
		.nios_avalon_mm_50mhz_waitrequest                 (<connected-to-nios_avalon_mm_50mhz_waitrequest>),                 //                      nios_avalon_mm_50mhz.waitrequest
		.nios_avalon_mm_50mhz_readdata                    (<connected-to-nios_avalon_mm_50mhz_readdata>),                    //                                          .readdata
		.nios_avalon_mm_50mhz_readdatavalid               (<connected-to-nios_avalon_mm_50mhz_readdatavalid>),               //                                          .readdatavalid
		.nios_avalon_mm_50mhz_burstcount                  (<connected-to-nios_avalon_mm_50mhz_burstcount>),                  //                                          .burstcount
		.nios_avalon_mm_50mhz_writedata                   (<connected-to-nios_avalon_mm_50mhz_writedata>),                   //                                          .writedata
		.nios_avalon_mm_50mhz_address                     (<connected-to-nios_avalon_mm_50mhz_address>),                     //                                          .address
		.nios_avalon_mm_50mhz_write                       (<connected-to-nios_avalon_mm_50mhz_write>),                       //                                          .write
		.nios_avalon_mm_50mhz_read                        (<connected-to-nios_avalon_mm_50mhz_read>),                        //                                          .read
		.nios_avalon_mm_50mhz_byteenable                  (<connected-to-nios_avalon_mm_50mhz_byteenable>),                  //                                          .byteenable
		.nios_avalon_mm_50mhz_debugaccess                 (<connected-to-nios_avalon_mm_50mhz_debugaccess>),                 //                                          .debugaccess
		.pio_button_export                                (<connected-to-pio_button_export>),                                //                                pio_button.export
		.pio_button_irq_irq                               (<connected-to-pio_button_irq_irq>),                               //                            pio_button_irq.irq
		.pio_dips_export                                  (<connected-to-pio_dips_export>),                                  //                                  pio_dips.export
		.pio_leds_export                                  (<connected-to-pio_leds_export>),                                  //                                  pio_leds.export
		.reset_reset_n                                    (<connected-to-reset_reset_n>),                                    //                                     reset.reset_n
		.sd_clk_export                                    (<connected-to-sd_clk_export>),                                    //                                    sd_clk.export
		.sd_spi_cs_n_export                               (<connected-to-sd_spi_cs_n_export>),                               //                               sd_spi_cs_n.export
		.sd_spi_miso_export                               (<connected-to-sd_spi_miso_export>),                               //                               sd_spi_miso.export
		.sd_spi_mosi_export                               (<connected-to-sd_spi_mosi_export>),                               //                               sd_spi_mosi.export
		.spi_master_to_maxv_MISO                          (<connected-to-spi_master_to_maxv_MISO>),                          //                        spi_master_to_maxv.MISO
		.spi_master_to_maxv_MOSI                          (<connected-to-spi_master_to_maxv_MOSI>),                          //                                          .MOSI
		.spi_master_to_maxv_SCLK                          (<connected-to-spi_master_to_maxv_SCLK>),                          //                                          .SCLK
		.spi_master_to_maxv_SS_n                          (<connected-to-spi_master_to_maxv_SS_n>),                          //                                          .SS_n
		.spi_master_to_maxv_irq_irq                       (<connected-to-spi_master_to_maxv_irq_irq>),                       //                    spi_master_to_maxv_irq.irq
		.uart_0_external_connection_rxd                   (<connected-to-uart_0_external_connection_rxd>),                   //                uart_0_external_connection.rxd
		.uart_0_external_connection_txd                   (<connected-to-uart_0_external_connection_txd>),                   //                                          .txd
		.uart_0_irq_irq                                   (<connected-to-uart_0_irq_irq>),                                   //                                uart_0_irq.irq
		.uart_10_external_connection_rxd                  (<connected-to-uart_10_external_connection_rxd>),                  //               uart_10_external_connection.rxd
		.uart_10_external_connection_txd                  (<connected-to-uart_10_external_connection_txd>),                  //                                          .txd
		.uart_10_irq_irq                                  (<connected-to-uart_10_irq_irq>),                                  //                               uart_10_irq.irq
		.uart_13_external_connection_rxd                  (<connected-to-uart_13_external_connection_rxd>),                  //               uart_13_external_connection.rxd
		.uart_13_external_connection_txd                  (<connected-to-uart_13_external_connection_txd>),                  //                                          .txd
		.uart_13_irq_irq                                  (<connected-to-uart_13_irq_irq>),                                  //                               uart_13_irq.irq
		.uart_7_external_connection_rxd                   (<connected-to-uart_7_external_connection_rxd>),                   //                uart_7_external_connection.rxd
		.uart_7_external_connection_txd                   (<connected-to-uart_7_external_connection_txd>),                   //                                          .txd
		.uart_7_irq_irq                                   (<connected-to-uart_7_irq_irq>),                                   //                                uart_7_irq.irq
		.uart_enabled_word_export                         (<connected-to-uart_enabled_word_export>),                         //                         uart_enabled_word.export
		.uart_internal_disable_external_connection_export (<connected-to-uart_internal_disable_external_connection_export>), // uart_internal_disable_external_connection.export
		.uart_internal_enable_external_connection_export  (<connected-to-uart_internal_enable_external_connection_export>),  //  uart_internal_enable_external_connection.export
		.uart_is_regfile_external_connection_export       (<connected-to-uart_is_regfile_external_connection_export>)        //       uart_is_regfile_external_connection.export
	);

