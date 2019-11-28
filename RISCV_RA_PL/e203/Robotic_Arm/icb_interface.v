



module icb_interface (



	

	// input [32*12-1:0] stepperPosition,

	// output [32*12-1:0] stepCnt,
	// output currentLoopPowerOnA,
	// output currentLoopEnableA,

	// output currentLoopPowerOnB,
	// output currentLoopEnableB,

	// output stepperRST,

	input			i_icb_cmd_valid,
	output			i_icb_cmd_ready,
	input [31:0]	i_icb_cmd_addr, 
	input			i_icb_cmd_read, 
	input [31:0]	i_icb_cmd_wdata,
	
	output			i_icb_rsp_valid,
	input			i_icb_rsp_ready,
	output [31:0]	i_icb_rsp_rdata,

	input	clk,
	input	rst_n
);

reg [31:0] icb_reg0;
reg [31:0] icb_reg1;
reg [31:0] icb_reg2;
reg [31:0] icb_reg3;
reg [31:0] icb_reg4;
reg [31:0] icb_reg5;
reg [31:0] icb_reg6;
reg [31:0] icb_reg7;
reg [31:0] icb_reg8;
reg [31:0] icb_reg9;
reg [31:0] icb_reg10;
reg [31:0] icb_reg11;
reg [31:0] icb_reg12;
reg [31:0] icb_reg13;
reg [31:0] icb_reg14;
reg [31:0] icb_reg15;
reg [31:0] icb_reg16;
reg [31:0] icb_reg17;
reg [31:0] icb_reg18;
reg [31:0] icb_reg19;
reg [31:0] icb_reg20;
reg [31:0] icb_reg21;
reg [31:0] icb_reg22;
reg [31:0] icb_reg23;
reg [31:0] icb_reg24;
reg [31:0] icb_reg25;
reg [31:0] icb_reg26;
reg [31:0] icb_reg27;
reg [31:0] icb_reg28;
reg [31:0] icb_reg29;
reg [31:0] icb_reg30;
reg [31:0] icb_reg31;



reg icb_rsp_valid_reg;

reg [31:0] icb_rsp_rdata_reg;

assign i_icb_cmd_ready = i_icb_cmd_valid;
assign i_icb_rsp_valid = ( (~i_icb_cmd_read) & i_icb_cmd_valid ) 
						| icb_rsp_valid_reg;
assign i_icb_rsp_rdata = icb_rsp_rdata_reg;

wire [4:0] reg_mux = i_icb_cmd_addr[4:0];




//写状态，本拍给结果，下一拍录?
//读状态，下拍给结?
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		#1 icb_reg0 <= 'd0;
		#1 icb_reg1 <= 'd0;
		#1 icb_reg2 <= 'd0;
		#1 icb_reg3 <= 'd0;
		#1 icb_reg4 <= 'd0;
		#1 icb_reg5 <= 'd0;
		#1 icb_reg6 <= 'd0;
		#1 icb_reg7 <= 'd0;
		#1 icb_reg8 <= 'd0;
		#1 icb_reg9 <= 'd0;
		#1 icb_reg10 <= 'd0;
		#1 icb_reg11 <= 'd0;
		#1 icb_reg12 <= 'd0;
		#1 icb_reg13 <= 'd0;
		#1 icb_reg14 <= 'd0;
		#1 icb_reg15 <= 'd0;
		#1 icb_reg16 <= 'd0;
		#1 icb_reg17 <= 'd0;
		#1 icb_reg18 <= 'd0;
		#1 icb_reg19 <= 'd0;
		#1 icb_reg20 <= 'd0;
		#1 icb_reg21 <= 'd0;
		#1 icb_reg22 <= 'd0;
		#1 icb_reg23 <= 'd0;
		#1 icb_reg24 <= 'd0;
		#1 icb_reg25 <= 'd0;
		#1 icb_reg26 <= 'd0;
		#1 icb_reg27 <= 'd0;
		#1 icb_reg28 <= 'd0;
		#1 icb_reg29 <= 'd0;
		#1 icb_reg30 <= 'd0;
		#1 icb_reg31 <= 'd0;


		#1 icb_rsp_valid_reg <= 1'b0;
		#1 icb_rsp_rdata_reg <= 'd0;
	end
	else begin
		if ( ~i_icb_cmd_read & i_icb_cmd_valid ) begin //?
			case(reg_mux)
				5'd0: begin   #1 icb_reg0 <= i_icb_cmd_wdata;end
				5'd1: begin   #1 icb_reg1 <= i_icb_cmd_wdata;end
				5'd2: begin   #1 icb_reg2 <= i_icb_cmd_wdata;end
				5'd3: begin   #1 icb_reg3 <= i_icb_cmd_wdata;end
				5'd4: begin   #1 icb_reg4 <= i_icb_cmd_wdata;end
				5'd5: begin   #1 icb_reg5 <= i_icb_cmd_wdata;end
				5'd6: begin   #1 icb_reg6 <= i_icb_cmd_wdata;end
				5'd7: begin   #1 icb_reg7 <= i_icb_cmd_wdata;end
				5'd8: begin   #1 icb_reg8 <= i_icb_cmd_wdata;end
				5'd9: begin   #1 icb_reg9 <= i_icb_cmd_wdata;end
				5'd10:begin  #1  icb_reg10 <= i_icb_cmd_wdata;end
				5'd11:begin  #1  icb_reg11 <= i_icb_cmd_wdata;end
				5'd12:begin  #1  icb_reg12 <= i_icb_cmd_wdata;end
				5'd13:begin  #1  icb_reg13 <= i_icb_cmd_wdata;end
				5'd14:begin  #1  icb_reg14 <= i_icb_cmd_wdata;end
				5'd15:begin  #1  icb_reg15 <= i_icb_cmd_wdata;end
				5'd16:begin  #1  icb_reg16 <= i_icb_cmd_wdata;end
				5'd17:begin  #1  icb_reg17 <= i_icb_cmd_wdata;end
				5'd18:begin  #1  icb_reg18 <= i_icb_cmd_wdata;end
				5'd19:begin  #1  icb_reg19 <= i_icb_cmd_wdata;end
				5'd20:begin  #1  icb_reg20 <= i_icb_cmd_wdata;end
				5'd21:begin  #1  icb_reg21 <= i_icb_cmd_wdata;end
				5'd22:begin  #1  icb_reg22 <= i_icb_cmd_wdata;end
				5'd23:begin  #1  icb_reg23 <= i_icb_cmd_wdata;end
				5'd24:begin  #1  icb_reg24 <= i_icb_cmd_wdata;end
				5'd25:begin  #1  icb_reg25 <= i_icb_cmd_wdata;end
				5'd26:begin  #1  icb_reg26 <= i_icb_cmd_wdata;end
				5'd27:begin  #1  icb_reg27 <= i_icb_cmd_wdata;end
				5'd28:begin  #1  icb_reg28 <= i_icb_cmd_wdata;end
				5'd29:begin  #1  icb_reg29 <= i_icb_cmd_wdata;end
				5'd30:begin  #1  icb_reg30 <= i_icb_cmd_wdata;end
				5'd31:begin  #1  icb_reg31 <= i_icb_cmd_wdata;end
				default: begin end 





			endcase // reg_mux

			#1 icb_rsp_valid_reg <= 1'b0;
			#1 icb_rsp_rdata_reg <= 'd0;
		end

		else if ( i_icb_cmd_read & i_icb_cmd_valid ) begin //?
			#1 icb_rsp_valid_reg <= 1'b1;

			case(reg_mux)
				5'd0:  begin  #1 icb_rsp_rdata_reg <= icb_reg0;end
				5'd1:  begin  #1 icb_rsp_rdata_reg <= icb_reg1;end
				5'd2:  begin  #1 icb_rsp_rdata_reg <= icb_reg2;end
				5'd3:  begin  #1 icb_rsp_rdata_reg <= icb_reg3;end
				5'd4:  begin  #1 icb_rsp_rdata_reg <= icb_reg4;end
				5'd5:  begin  #1 icb_rsp_rdata_reg <= icb_reg5;end
				5'd6:  begin  #1 icb_rsp_rdata_reg <= icb_reg6;end
				5'd7:  begin  #1 icb_rsp_rdata_reg <= icb_reg7;end
				5'd8:  begin  #1 icb_rsp_rdata_reg <= icb_reg8;end
				5'd9:  begin  #1 icb_rsp_rdata_reg <= icb_reg9;end
				5'd10: begin #1  icb_rsp_rdata_reg <= icb_reg10;end
				5'd11: begin #1  icb_rsp_rdata_reg <= icb_reg11;end
				5'd12: begin #1  icb_rsp_rdata_reg <= icb_reg12;end
				5'd13: begin #1  icb_rsp_rdata_reg <= icb_reg13;end
				5'd14: begin #1  icb_rsp_rdata_reg <= icb_reg14;end
				5'd15: begin #1  icb_rsp_rdata_reg <= icb_reg15;end
				5'd16: begin #1  icb_rsp_rdata_reg <= icb_reg16;end
				5'd17: begin #1  icb_rsp_rdata_reg <= icb_reg17;end
				5'd18: begin #1  icb_rsp_rdata_reg <= icb_reg18;end
				5'd19: begin #1  icb_rsp_rdata_reg <= icb_reg19;end
				5'd20: begin #1  icb_rsp_rdata_reg <= icb_reg20;end
				5'd21: begin #1  icb_rsp_rdata_reg <= icb_reg21;end
				5'd22: begin #1  icb_rsp_rdata_reg <= icb_reg22;end
				5'd23: begin #1  icb_rsp_rdata_reg <= icb_reg23;end
				5'd24: begin #1  icb_rsp_rdata_reg <= icb_reg24;end
				5'd25: begin #1  icb_rsp_rdata_reg <= icb_reg25;end
				5'd26: begin #1  icb_rsp_rdata_reg <= icb_reg26;end
				5'd27: begin #1  icb_rsp_rdata_reg <= icb_reg27;end
				5'd28: begin #1  icb_rsp_rdata_reg <= icb_reg28;end
				5'd29: begin #1  icb_rsp_rdata_reg <= icb_reg29;end
				5'd30: begin #1  icb_rsp_rdata_reg <= icb_reg30;end
				5'd31: begin #1  icb_rsp_rdata_reg <= icb_reg31;end
			default: #1 icb_rsp_rdata_reg <= 'd66;



			endcase // reg_mux


		end

		else if ( i_icb_rsp_ready == 1'b1 ) begin
			#1 icb_rsp_valid_reg <= 1'b0;
			#1 icb_rsp_rdata_reg <= 'd0;
		end

		else begin


		end



	end


end


















	// 		8'h00   : reg_data_out <= slv_reg0;
	// 		8'h01   : reg_data_out <= slv_reg1;
	// 		8'h02   : reg_data_out <= slv_reg2;
	// 		8'h03   : reg_data_out <= slv_reg3;
	// 		8'h04   : reg_data_out <= slv_reg4;
	// 		8'h05   : reg_data_out <= slv_reg5;

	// 		8'h06   : reg_data_out <= slv_reg6;
	// 		8'h07   : reg_data_out <= slv_reg7;
	// 		8'h08   : reg_data_out <= slv_reg8;
	// 		8'h09   : reg_data_out <= slv_reg9;
	// 		8'h0A   : reg_data_out <= slv_reg10;
	// 		8'h0B   : reg_data_out <= slv_reg11;


	// 		8'h0C   : reg_data_out <= stepperPosition[31:0];
	// 		8'h0D   : reg_data_out <= stepperPosition[63:32];
	// 		8'h0E   : reg_data_out <= stepperPosition[95:64];
	// 		8'h0F   : reg_data_out <= stepperPosition[127:96];
	// 		8'h10   : reg_data_out <= stepperPosition[159:128];
	// 		8'h11   : reg_data_out <= stepperPosition[191:160];
	// 		8'h12   : reg_data_out <= stepperPosition[223:192];
	// 		8'h13   : reg_data_out <= stepperPosition[255:224];
	// 		8'h14   : reg_data_out <= stepperPosition[287:256];
	// 		8'h15   : reg_data_out <= stepperPosition[319:288];
	// 		8'h16   : reg_data_out <= stepperPosition[351:320];
	// 		8'h17   : reg_data_out <= stepperPosition[383:352];



	// assign stepCnt = {slv_reg11,slv_reg10,slv_reg9,slv_reg8,slv_reg7,slv_reg6,slv_reg5,slv_reg4,slv_reg3,slv_reg2,slv_reg1,slv_reg0};

	// assign currentLoopPowerOnA = slv_reg25[0];
	// assign currentLoopEnableA = slv_reg24[0];

	// assign currentLoopPowerOnB = slv_reg27[0];
	// assign currentLoopEnableB = slv_reg26[0];
	
	// assign stepperRST = slv_reg28[0];







endmodule






