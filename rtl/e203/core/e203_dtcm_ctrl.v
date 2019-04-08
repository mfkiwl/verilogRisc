//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-04 17:23:37
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_dtcm_ctrl
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision:    -   
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////
 /*                                                                      
 Copyright 2018 Nuclei System Technology, Inc.                
																																				 
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
																																				 
		 http://www.apache.org/licenses/LICENSE-2.0                          
																																				 
	Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
																																				 
																																				 
																																				 
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The dtcm_ctrl module control the DTCM access requests 
//
// ====================================================================
`include "e203_defines.v"

	`ifdef E203_HAS_DTCM //{

module e203_dtcm_ctrl(
	output dtcm_active,
	// The cgstop is coming from CSR (0xBFE mcgstop)'s filed 1
	// // This register is our self-defined CSR register to disable the 
	// DTCM SRAM clock gating for debugging purpose
	input  tcm_cgstop,
	// Note: the DTCM ICB interface only support the single-transaction
	
	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// LSU ICB to DTCM
	//    * Bus cmd channel
	input  lsu2dtcm_icb_cmd_valid, // Handshake valid
	output lsu2dtcm_icb_cmd_ready, // Handshake ready
	// Note: The data on rdata or wdata channel must be naturally aligned, this is in line with the AXI definition
	input  [`E203_DTCM_ADDR_WIDTH-1:0]   lsu2dtcm_icb_cmd_addr, // Bus transaction start addr 
	input  lsu2dtcm_icb_cmd_read,   // Read or write
	input  [32-1:0] lsu2dtcm_icb_cmd_wdata, 
	input  [4-1:0] lsu2dtcm_icb_cmd_wmask, 

	//    * Bus RSP channel
	output lsu2dtcm_icb_rsp_valid, // Response valid 
	input  lsu2dtcm_icb_rsp_ready, // Response ready
	output lsu2dtcm_icb_rsp_err,   // Response error
						// Note: the RSP rdata is inline with AXI definition
	output [32-1:0] lsu2dtcm_icb_rsp_rdata, 

	input  clk,
	input  rst_n
	);

	wire clk_dtcm_ram;


	wire arbt_icb_cmd_valid;
	wire arbt_icb_cmd_ready;
	wire [`E203_DTCM_ADDR_WIDTH-1:0] arbt_icb_cmd_addr;
	wire arbt_icb_cmd_read;
	wire [`E203_DTCM_DATA_WIDTH-1:0] arbt_icb_cmd_wdata;
	wire [`E203_DTCM_WMSK_WIDTH-1:0] arbt_icb_cmd_wmask;

	wire arbt_icb_rsp_valid;
	wire arbt_icb_rsp_ready;
	wire arbt_icb_rsp_err;
	wire [`E203_DTCM_DATA_WIDTH-1:0] arbt_icb_rsp_rdata;


	localparam DTCM_ARBT_I_NUM = 1;
	localparam DTCM_ARBT_I_PTR_W = 1;


	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_valid;
	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_ready;
	wire [DTCM_ARBT_I_NUM*`E203_DTCM_ADDR_WIDTH-1:0] arbt_bus_icb_cmd_addr;
	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_read;
	wire [DTCM_ARBT_I_NUM*`E203_DTCM_DATA_WIDTH-1:0] arbt_bus_icb_cmd_wdata;
	wire [DTCM_ARBT_I_NUM*`E203_DTCM_WMSK_WIDTH-1:0] arbt_bus_icb_cmd_wmask;

	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_valid;
	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_ready;
	wire [DTCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_err;
	wire [DTCM_ARBT_I_NUM*`E203_DTCM_DATA_WIDTH-1:0] arbt_bus_icb_rsp_rdata;
	
	//LSU take higher priority
	assign arbt_bus_icb_cmd_valid = lsu2dtcm_icb_cmd_valid;
	assign arbt_bus_icb_cmd_addr = lsu2dtcm_icb_cmd_addr;
	assign arbt_bus_icb_cmd_read = lsu2dtcm_icb_cmd_read;
	assign arbt_bus_icb_cmd_wdata = lsu2dtcm_icb_cmd_wdata;
	assign arbt_bus_icb_cmd_wmask = lsu2dtcm_icb_cmd_wmask;
	assign lsu2dtcm_icb_cmd_ready = arbt_bus_icb_cmd_ready;


	assign lsu2dtcm_icb_rsp_valid = arbt_bus_icb_rsp_valid;
	assign lsu2dtcm_icb_rsp_err = arbt_bus_icb_rsp_err;
	assign lsu2dtcm_icb_rsp_rdata = arbt_bus_icb_rsp_rdata;
	assign arbt_bus_icb_rsp_ready = lsu2dtcm_icb_rsp_ready;

	sirv_gnrl_icb_arbt # (
		.ARBT_SCHEME (0),// Priority based
		.ALLOW_0CYCL_RSP (0),// Dont allow the 0 cycle response because for ITCM and DTCM, 
												 //   Dcache, .etc, definitely they cannot reponse as 0 cycle
		.FIFO_OUTS_NUM   (`E203_DTCM_OUTS_NUM),
		.FIFO_CUT_READY(0),
		.USR_W      (1),
		.ARBT_NUM   (DTCM_ARBT_I_NUM  ),
		.ARBT_PTR_W (DTCM_ARBT_I_PTR_W),
		.AW         (`E203_DTCM_ADDR_WIDTH),
		.DW         (`E203_DTCM_DATA_WIDTH) 
	) u_dtcm_icb_arbt(
		.o_icb_cmd_valid        (arbt_icb_cmd_valid )     ,
		.o_icb_cmd_ready        (arbt_icb_cmd_ready )     ,
		.o_icb_cmd_read         (arbt_icb_cmd_read )      ,
		.o_icb_cmd_addr         (arbt_icb_cmd_addr )      ,
		.o_icb_cmd_wdata        (arbt_icb_cmd_wdata )     ,
		.o_icb_cmd_wmask        (arbt_icb_cmd_wmask)      ,
		.o_icb_cmd_burst        ()     ,
		.o_icb_cmd_beat         ()     ,
		.o_icb_cmd_lock         ()     ,
		.o_icb_cmd_excl         ()     ,
		.o_icb_cmd_size         ()     ,
		.o_icb_cmd_usr          ()     ,
																	
		.o_icb_rsp_valid        (arbt_icb_rsp_valid )     ,
		.o_icb_rsp_ready        (arbt_icb_rsp_ready )     ,
		.o_icb_rsp_err          (arbt_icb_rsp_err)        ,
		.o_icb_rsp_rdata        (arbt_icb_rsp_rdata )     ,
		.o_icb_rsp_usr          (1'b0),
		.o_icb_rsp_excl_ok      (1'b0),
																 
		.i_bus_icb_cmd_ready    (arbt_bus_icb_cmd_ready ) ,
		.i_bus_icb_cmd_valid    (arbt_bus_icb_cmd_valid ) ,
		.i_bus_icb_cmd_read     (arbt_bus_icb_cmd_read )  ,
		.i_bus_icb_cmd_addr     (arbt_bus_icb_cmd_addr )  ,
		.i_bus_icb_cmd_wdata    (arbt_bus_icb_cmd_wdata ) ,
		.i_bus_icb_cmd_wmask    (arbt_bus_icb_cmd_wmask)  ,
		.i_bus_icb_cmd_burst    ({2*DTCM_ARBT_I_NUM{1'b0}}) ,
		.i_bus_icb_cmd_beat     ({2*DTCM_ARBT_I_NUM{1'b0}}) ,
		.i_bus_icb_cmd_lock     ({1*DTCM_ARBT_I_NUM{1'b0}}),
		.i_bus_icb_cmd_excl     ({1*DTCM_ARBT_I_NUM{1'b0}}),
		.i_bus_icb_cmd_size     ({2*DTCM_ARBT_I_NUM{1'b0}}),
		.i_bus_icb_cmd_usr      ({1*DTCM_ARBT_I_NUM{1'b0}}),

																	
		.i_bus_icb_rsp_valid    (arbt_bus_icb_rsp_valid ) ,
		.i_bus_icb_rsp_ready    (arbt_bus_icb_rsp_ready ) ,
		.i_bus_icb_rsp_err      (arbt_bus_icb_rsp_err)    ,
		.i_bus_icb_rsp_rdata    (arbt_bus_icb_rsp_rdata ) ,
		.i_bus_icb_rsp_usr      (),
		.i_bus_icb_rsp_excl_ok  (),
															 
		.clk					(clk),
		.rst_n					(rst_n)
	);




	wire sram_icb_cmd_ready;
	wire sram_icb_cmd_valid;
	wire [`E203_DTCM_ADDR_WIDTH-1:0] sram_icb_cmd_addr;
	wire sram_icb_cmd_read;
	wire [`E203_DTCM_DATA_WIDTH-1:0] sram_icb_cmd_wdata;
	wire [`E203_DTCM_WMSK_WIDTH-1:0] sram_icb_cmd_wmask;

	assign arbt_icb_cmd_ready = sram_icb_cmd_ready;

	assign sram_icb_cmd_valid = arbt_icb_cmd_valid;
	assign sram_icb_cmd_addr  = arbt_icb_cmd_addr;
	assign sram_icb_cmd_read  = arbt_icb_cmd_read;
	assign sram_icb_cmd_wdata = arbt_icb_cmd_wdata;
	assign sram_icb_cmd_wmask = arbt_icb_cmd_wmask;

	wire sram_icb_rsp_valid;
	wire sram_icb_rsp_ready;
	wire [`E203_DTCM_DATA_WIDTH-1:0] sram_icb_rsp_rdata;
	wire sram_icb_rsp_err;


	wire dtcm_sram_ctrl_active;


	wire sram_icb_rsp_read;


 `ifndef E203_HAS_ECC //{
	sirv_sram_icb_ctrl #(
		.DW     (`E203_DTCM_DATA_WIDTH),
		.AW     (`E203_DTCM_ADDR_WIDTH),
		.MW     (`E203_DTCM_WMSK_WIDTH),
		.AW_LSB (2),// DTCM is 32bits wide, so the LSB is 2
		.USR_W  (1) 
	) u_sram_icb_ctrl (
		.sram_ctrl_active (dtcm_sram_ctrl_active),
		.tcm_cgstop       (tcm_cgstop),
		 
		.i_icb_cmd_valid (sram_icb_cmd_valid),
		.i_icb_cmd_ready (sram_icb_cmd_ready),
		.i_icb_cmd_read  (sram_icb_cmd_read ),
		.i_icb_cmd_addr  (sram_icb_cmd_addr ), 
		.i_icb_cmd_wdata (sram_icb_cmd_wdata), 
		.i_icb_cmd_wmask (sram_icb_cmd_wmask), 
		.i_icb_cmd_usr   (sram_icb_cmd_read ),
	
		.i_icb_rsp_valid (sram_icb_rsp_valid),
		.i_icb_rsp_ready (sram_icb_rsp_ready),
		.i_icb_rsp_rdata (sram_icb_rsp_rdata),
		.i_icb_rsp_usr   (sram_icb_rsp_read),
	
		.ram_cs   (dtcm_ram_cs  ),  
		.ram_we   (dtcm_ram_we  ),  
		.ram_addr (dtcm_ram_addr), 
		.ram_wem  (dtcm_ram_wem ),
		.ram_din  (dtcm_ram_din ),          
		.ram_dout (dtcm_ram_dout),
		.clk_ram  (clk_dtcm_ram ),
	
		.test_mode(1'b0),
		.clk  (clk  ),
		.rst_n(rst_n)  
	);

	assign sram_icb_rsp_err = 1'b0;
	`endif//}

		

	assign sram_icb_rsp_ready = arbt_icb_rsp_ready;

	assign arbt_icb_rsp_valid = sram_icb_rsp_valid;
	assign arbt_icb_rsp_err   = sram_icb_rsp_err;
	assign arbt_icb_rsp_rdata = sram_icb_rsp_rdata;


	assign dtcm_active = lsu2dtcm_icb_cmd_valid | dtcm_sram_ctrl_active;


`ifdef E203_HAS_DTCM
	e203_dtcm_ram u_e203_dtcm_ram (
		.cs   (dtcm_ram_cs),
		.we   (dtcm_ram_we),
		.addr (dtcm_ram_addr),
		.wem  (dtcm_ram_wem),
		.din  (dtcm_ram_din),
		.dout (dtcm_ram_dout),
		.rst_n(rst_n),
		.clk  (clk_dtcm_ram)
	);

`endif





endmodule

	`endif//}
