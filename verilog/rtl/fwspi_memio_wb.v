/****************************************************************************
 * fwspi_memio_wb.v
 * 
 * Derived from source with the following copyright/license:
 * 
 *  SPDX-FileCopyrightText: 2015 Clifford Wolf
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  SPDX-License-Identifier: ISC
 ****************************************************************************/
`include "wishbone_macros.svh"
  
/**
 * Module: fwspi_memio_wb
 * 
 * TODO: Add module documentation
 */
module fwspi_memio_wb (
		input clock,
		input reset,
		
		`WB_TARGET_PORT(cfg_, 32, 32),
		`WB_TARGET_PORT(flash_, 32, 32),

		output quad_mode,

		output flash_csb,
		output flash_clk,

		output flash_csb_oeb,
		output flash_clk_oeb,

		output flash_io0_oeb,
		output flash_io1_oeb,
		output flash_io2_oeb,
		output flash_io3_oeb,

		output flash_csb_ieb,
		output flash_clk_ieb,

		output flash_io0_ieb,
		output flash_io1_ieb,
		output flash_io2_ieb,
		output flash_io3_ieb,

		output flash_io0_do,
		output flash_io1_do,
		output flash_io2_do,
		output flash_io3_do,

		input  flash_io0_di,
		input  flash_io1_di,
		input  flash_io2_di,
		input  flash_io3_di
		);
	
	wire spimem_ready;
	wire [31:0] spimem_rdata;
	wire [31:0] spimemio_cfgreg_do;
	wire [3:0] cfgreg_we;
	wire spimemio_cfgreg_sel;
	wire valid;

	assign valid = flash_cyc && flash_stb;    
	assign flash_ack = spimem_ready;
	assign cfg_ack = spimemio_cfgreg_sel;

	assign spimemio_cfgreg_sel = cfg_cyc && cfg_stb;

	assign cfgreg_we = spimemio_cfgreg_sel ? cfg_sel & {4{cfg_we}} : 4'b 0000;
	assign flash_dat_r = spimem_rdata;
	assign cfg_dat_r = spimemio_cfgreg_do;

	fwspi_memio u_core (
			.clk    (clock),
			.reset  (reset),
			.valid  (valid),
			.ready  (spimem_ready),
			.addr   (flash_adr),
			.rdata  (spimem_rdata),

			.flash_csb    (flash_csb),
			.flash_clk    (flash_clk),

			.flash_csb_oeb (flash_csb_oeb),
			.flash_clk_oeb (flash_clk_oeb),

			.flash_io0_oeb (flash_io0_oeb),
			.flash_io1_oeb (flash_io1_oeb),
			.flash_io2_oeb (flash_io2_oeb),
			.flash_io3_oeb (flash_io3_oeb),

			.flash_csb_ieb (flash_csb_ieb),
			.flash_clk_ieb (flash_clk_ieb),

			.flash_io0_ieb (flash_io0_ieb),
			.flash_io1_ieb (flash_io1_ieb),
			.flash_io2_ieb (flash_io2_ieb),
			.flash_io3_ieb (flash_io3_ieb),

			.flash_io0_do (flash_io0_do),
			.flash_io1_do (flash_io1_do),
			.flash_io2_do (flash_io2_do),
			.flash_io3_do (flash_io3_do),

			.flash_io0_di (flash_io0_di),
			.flash_io1_di (flash_io1_di),
			.flash_io2_di (flash_io2_di),
			.flash_io3_di (flash_io3_di),

			.cfgreg_we(cfgreg_we),
			.cfgreg_di(cfg_dat_w),
			.cfgreg_do(spimemio_cfgreg_do),

			.quad_mode(quad_mode)
		);

endmodule
 


