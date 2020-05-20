//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top.v                                                   ////
////                                                              ////
////  This file is part of the SPI IP core project                ////
////  http://www.opencores.org/projects/spi/                      ////
////                                                              ////
////  Author(s):                                                  ////
////      - Simon Srot (simons@opencores.org)                     ////
////                                                              ////
////  All additional information is avaliable in the Readme.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2002 Authors                                   ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "reduced_opencores_spi_defines.v"
`include "reduced_opencores_spi_timescale.v"

module reduced_opencores_spi_top
(
  // Wishbone signals
  wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_i, wb_dat_o, wb_sel_i,
  wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_err_o, wb_int_o,

  // SPI signals
  ss_pad_o, sclk_pad_o, mosi_pad_o, miso_pad_i,
  
  debug_wb_clk_i,
  debug_wb_rst_i,
  debug_wb_adr_i,
  debug_wb_dat_i,
  debug_wb_dat_o,
  debug_wb_sel_i,
  debug_wb_we_i ,
  debug_wb_stb_i,
  debug_wb_cyc_i,
  debug_wb_ack_o,
  debug_wb_err_o,
  debug_wb_int_o,
  debug_divider,
  debug_ctrl   ,
  debug_ss     ,
  debug_wb_dat ,
  debug_tag_word_in,
  debug_tag_word_out
  
  
  
);

  parameter Tp = 1;

  // Wishbone signals
  input                            wb_clk_i;         // master clock input
  input                            wb_rst_i;         // synchronous active high reset
  input                      [4:0] wb_adr_i;         // lower address bits
  input                   [32-1:0] wb_dat_i;         // databus input
  output                  [32-1:0] wb_dat_o;         // databus output
  input                      [3:0] wb_sel_i;         // byte select inputs
  input                            wb_we_i;          // write enable input
  input                            wb_stb_i;         // stobe/core select signal
  input                            wb_cyc_i;         // valid bus cycle input
  output                           wb_ack_o;         // bus cycle acknowledge output
  output                           wb_err_o;         // termination w/ error
  output                           wb_int_o;         // interrupt request signal output
       


output                              debug_wb_clk_i;
output                              debug_wb_rst_i;	   
output        [4:0]                 debug_wb_adr_i;	   
output     [32-1:0]                 debug_wb_dat_i;	   
output     [32-1:0]                 debug_wb_dat_o;	   
output        [3:0]                 debug_wb_sel_i;
output                              debug_wb_we_i ;
output                              debug_wb_stb_i;
output                              debug_wb_cyc_i;
output                              debug_wb_err_o;
output                              debug_wb_ack_o;
output                              debug_wb_int_o;  
output       [`REDUCED_SPI_DIVIDER_LEN-1:0] debug_divider ;   
output       [`REDUCED_SPI_CTRL_BIT_NB-1:0] debug_ctrl    ;   
output             [`REDUCED_SPI_SS_NB-1:0] debug_ss      ;   
output                     [32-1:0] debug_wb_dat  ;  
input        [7:0]   debug_tag_word_in;
output       wire [7:0]   debug_tag_word_out; 
	   
  // SPI signals                                     
  output          [`REDUCED_SPI_SS_NB-1:0] ss_pad_o  ;         // slave select
  output                           sclk_pad_o;       // serial clock
  output                           mosi_pad_o;       // master out slave in
  input                            miso_pad_i;       // master in slave out
                                                     
  reg                     [32-1:0] wb_dat_o  ;
  reg                              wb_ack_o  ;
  reg                              wb_int_o  ;
                                               
  // Internal signals
  (* keep = 1, preserve = 1 *) reg       [`REDUCED_SPI_DIVIDER_LEN-1:0] divider;          // Divider register
  (* keep = 1, preserve = 1 *) reg       [`REDUCED_SPI_CTRL_BIT_NB-1:0] ctrl   ;             // Control and status register
  (* keep = 1, preserve = 1 *) reg             [`REDUCED_SPI_SS_NB-1:0] ss     ;               // Slave select register
  (* keep = 1, preserve = 1 *) reg                     [32-1:0] wb_dat ;            // wb data out
  
  wire         [`REDUCED_SPI_MAX_CHAR-1:0] rx;               // Rx register
  wire                             rx_negedge;       // miso is sampled on negative edge
  wire                             tx_negedge;       // mosi is driven on negative edge
  wire    [`REDUCED_SPI_CHAR_LEN_BITS-1:0] char_len;         // char len
  wire                             go;               // go
  wire                             lsb;              // lsb first on line
  wire                             ie;               // interrupt enable
  wire                             ass;              // automatic slave select
  wire                             spi_divider_sel;  // divider register select
  wire                             spi_ctrl_sel;     // ctrl register select
  wire                       [3:0] spi_tx_sel;       // tx_l register select
  wire                             spi_ss_sel;       // ss register select
  wire                             tip;              // transfer in progress
  wire                             pos_edge;         // recognize posedge of sclk
  wire                             neg_edge;         // recognize negedge of sclk
  wire                             last_bit;         // marks last character bit
  
  // Address decoder
  assign spi_divider_sel = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_DEVIDE);
  assign spi_ctrl_sel    = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_CTRL);
  assign spi_tx_sel[0]   = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_TX_0);
  assign spi_tx_sel[1]   = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_TX_1);
  assign spi_tx_sel[2]   = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_TX_2);
  assign spi_tx_sel[3]   = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_TX_3);
  assign spi_ss_sel      = wb_cyc_i & wb_stb_i & (wb_adr_i[`REDUCED_SPI_OFS_BITS] == `REDUCED_SPI_SS);
  
  // Read from registers
  always @(wb_adr_i or rx or ctrl or divider or ss)
  begin
    case (wb_adr_i[`REDUCED_SPI_OFS_BITS])
`ifdef REDUCED_SPI_MAX_CHAR_128
      `REDUCED_SPI_RX_0:    wb_dat = rx[31:0];
      `REDUCED_SPI_RX_1:    wb_dat = rx[63:32];
      `REDUCED_SPI_RX_2:    wb_dat = rx[95:64];
      `REDUCED_SPI_RX_3:    wb_dat = {{128-`REDUCED_SPI_MAX_CHAR{1'b0}}, rx[`REDUCED_SPI_MAX_CHAR-1:96]};
`else
`ifdef REDUCED_SPI_MAX_CHAR_64
      `REDUCED_SPI_RX_0:    wb_dat = rx[31:0];
      `REDUCED_SPI_RX_1:    wb_dat = {{64-`REDUCED_SPI_MAX_CHAR{1'b0}}, rx[`REDUCED_SPI_MAX_CHAR-1:32]};
      `REDUCED_SPI_RX_2:    wb_dat = 32'b0;
      `REDUCED_SPI_RX_3:    wb_dat = 32'b0;
`else
      `REDUCED_SPI_RX_0:    wb_dat = {{32-`REDUCED_SPI_MAX_CHAR{1'b0}}, rx[`REDUCED_SPI_MAX_CHAR-1:0]};
      `REDUCED_SPI_RX_1:    wb_dat = 32'b0;
      `REDUCED_SPI_RX_2:    wb_dat = 32'b0;
      `REDUCED_SPI_RX_3:    wb_dat = 32'b0;
`endif
`endif
      `REDUCED_SPI_CTRL:    wb_dat = {{32-`REDUCED_SPI_CTRL_BIT_NB{1'b0}}, ctrl};
      `REDUCED_SPI_DEVIDE:  wb_dat = {{32-`REDUCED_SPI_DIVIDER_LEN{1'b0}}, divider};
      `REDUCED_SPI_SS:      wb_dat = {{32-`REDUCED_SPI_SS_NB{1'b0}}, ss};
      default:      wb_dat = 32'bx;
    endcase
  end
  
  // Wb data out
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
      wb_dat_o <= #Tp 32'b0;
    else
      wb_dat_o <= #Tp wb_dat;
  end
  
  // Wb acknowledge
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
      wb_ack_o <= #Tp 1'b0;
    else
      wb_ack_o <= #Tp wb_cyc_i & wb_stb_i & ~wb_ack_o;
  end
  
  // Wb error
  assign wb_err_o = 1'b0;
  
  // Interrupt
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
      wb_int_o <= #Tp 1'b0;
    else if (ie && tip && last_bit && pos_edge)
      wb_int_o <= #Tp 1'b1;
    else if (wb_ack_o)
      wb_int_o <= #Tp 1'b0;
  end
  
  // Divider register
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
        divider <= #Tp {`REDUCED_SPI_DIVIDER_LEN{1'b0}};
    else if (spi_divider_sel && wb_we_i && !tip)
      begin
      `ifdef REDUCED_SPI_DIVIDER_LEN_8
        if (wb_sel_i[0])
          divider <= #Tp wb_dat_i[`REDUCED_SPI_DIVIDER_LEN-1:0];
      `endif
      `ifdef REDUCED_SPI_DIVIDER_LEN_16
        if (wb_sel_i[0])
          divider[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          divider[`REDUCED_SPI_DIVIDER_LEN-1:8] <= #Tp wb_dat_i[`REDUCED_SPI_DIVIDER_LEN-1:8];
      `endif
      `ifdef REDUCED_SPI_DIVIDER_LEN_24
        if (wb_sel_i[0])
          divider[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          divider[15:8] <= #Tp wb_dat_i[15:8];
        if (wb_sel_i[2])
          divider[`REDUCED_SPI_DIVIDER_LEN-1:16] <= #Tp wb_dat_i[`REDUCED_SPI_DIVIDER_LEN-1:16];
      `endif
      `ifdef REDUCED_SPI_DIVIDER_LEN_32
        if (wb_sel_i[0])
          divider[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          divider[15:8] <= #Tp wb_dat_i[15:8];
        if (wb_sel_i[2])
          divider[23:16] <= #Tp wb_dat_i[23:16];
        if (wb_sel_i[3])
          divider[`REDUCED_SPI_DIVIDER_LEN-1:24] <= #Tp wb_dat_i[`REDUCED_SPI_DIVIDER_LEN-1:24];
      `endif
      end
  end
  
  // Ctrl register
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
      ctrl <= #Tp {`REDUCED_SPI_CTRL_BIT_NB{1'b0}};
    else if(spi_ctrl_sel && wb_we_i && !tip)
      begin
        if (wb_sel_i[0])
          ctrl[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          ctrl[`REDUCED_SPI_CTRL_BIT_NB-1:8] <= #Tp wb_dat_i[`REDUCED_SPI_CTRL_BIT_NB-1:8];
      end
    else if(tip && last_bit && pos_edge)
      ctrl[`REDUCED_SPI_CTRL_GO] <= #Tp 1'b0;
  end
  
  assign rx_negedge = ctrl[`REDUCED_SPI_CTRL_RX_NEGEDGE];
  assign tx_negedge = ctrl[`REDUCED_SPI_CTRL_TX_NEGEDGE];
  assign go         = ctrl[`REDUCED_SPI_CTRL_GO];
  assign char_len   = ctrl[`REDUCED_SPI_CTRL_CHAR_LEN];
  assign lsb        = ctrl[`REDUCED_SPI_CTRL_LSB];
  assign ie         = ctrl[`REDUCED_SPI_CTRL_IE];
  assign ass        = ctrl[`REDUCED_SPI_CTRL_ASS];
  
  assign debug_tag_word_out = go ? debug_tag_word_in : 0;
  
  // Slave select register
  always @(posedge wb_clk_i or posedge wb_rst_i)
  begin
    if (wb_rst_i)
      ss <= #Tp {`REDUCED_SPI_SS_NB{1'b0}};
    else if(spi_ss_sel && wb_we_i && !tip)
      begin
      `ifdef REDUCED_SPI_SS_NB_8
        if (wb_sel_i[0])
          ss <= #Tp wb_dat_i[`REDUCED_SPI_SS_NB-1:0];
      `endif
      `ifdef REDUCED_SPI_SS_NB_16
        if (wb_sel_i[0])
          ss[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          ss[`REDUCED_SPI_SS_NB-1:8] <= #Tp wb_dat_i[`REDUCED_SPI_SS_NB-1:8];
      `endif
      `ifdef REDUCED_SPI_SS_NB_24
        if (wb_sel_i[0])
          ss[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          ss[15:8] <= #Tp wb_dat_i[15:8];
        if (wb_sel_i[2])
          ss[`REDUCED_SPI_SS_NB-1:16] <= #Tp wb_dat_i[`REDUCED_SPI_SS_NB-1:16];
      `endif
      `ifdef REDUCED_SPI_SS_NB_32
        if (wb_sel_i[0])
          ss[7:0] <= #Tp wb_dat_i[7:0];
        if (wb_sel_i[1])
          ss[15:8] <= #Tp wb_dat_i[15:8];
        if (wb_sel_i[2])
          ss[23:16] <= #Tp wb_dat_i[23:16];
        if (wb_sel_i[3])
          ss[`REDUCED_SPI_SS_NB-1:24] <= #Tp wb_dat_i[`REDUCED_SPI_SS_NB-1:24];
      `endif
      end
  end
  
  assign ss_pad_o = ~((ss & {`REDUCED_SPI_SS_NB{tip & ass}}) | (ss & {`REDUCED_SPI_SS_NB{!ass}}));
  
  reduced_opencores_spi_clgen clgen (.clk_in(wb_clk_i), .rst(wb_rst_i), .go(go), .enable(tip), .last_clk(last_bit),
                   .divider(divider), .clk_out(sclk_pad_o), .pos_edge(pos_edge), 
                   .neg_edge(neg_edge));
  
  reduced_opencores_spi_shift shift (.clk(wb_clk_i), .rst(wb_rst_i), .len(char_len[`REDUCED_SPI_CHAR_LEN_BITS-1:0]),
                   .latch(spi_tx_sel[3:0] & {4{wb_we_i}}), .byte_sel(wb_sel_i), .lsb(lsb), 
                   .go(go), .pos_edge(pos_edge), .neg_edge(neg_edge), 
                   .rx_negedge(rx_negedge), .tx_negedge(tx_negedge),
                   .tip(tip), .last(last_bit), 
                   .p_in(wb_dat_i), .p_out(rx), 
                   .s_clk(sclk_pad_o), .s_in(miso_pad_i), .s_out(mosi_pad_o));
                   
                   assign debug_wb_clk_i       =     wb_clk_i ;
                   assign debug_wb_rst_i       =     wb_rst_i ;
                   assign debug_wb_adr_i       =     wb_adr_i ;
                   assign debug_wb_dat_i       =     wb_dat_i ;
                   assign debug_wb_dat_o       =     wb_dat_o ;
                   assign debug_wb_sel_i       =     wb_sel_i ;
                   assign debug_wb_we_i        =     wb_we_i  ;
                   assign debug_wb_stb_i       =     wb_stb_i ;
                   assign debug_wb_cyc_i       =     wb_cyc_i ;
                   assign debug_wb_err_o       =     wb_err_o ;
                   assign debug_wb_ack_o       =     wb_ack_o ;
                   assign debug_wb_int_o       =     wb_int_o ;
                   assign debug_divider        =     divider  ;
                   assign debug_ctrl           =     ctrl     ;
                   assign debug_ss             =     ss       ;
                   assign debug_wb_dat         =     wb_dat   ;
                   
                   
                   
endmodule
  