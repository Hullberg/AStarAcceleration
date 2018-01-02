// Transceiver Reconfiguration Controller
// pcie_xcvr_reconfig_SV.v


`timescale 1 ps / 1 ps
module pcie_xcvr_reconfig_SV (
		input  wire         npor,
		input  wire         reconfig_xcvr_clk,
		output wire         reconfig_busy,
		output wire [699:0] reconfig_to_xcvr,
		input  wire [459:0] reconfig_from_xcvr
	);

reg  [1:0]   por_r;
wire [6:0]   reconfig_mgmt_address;     //     reconfig_mgmt.address              input  wire
wire         reconfig_mgmt_read;        //                  .read                 input  wire
wire [31:0]  reconfig_mgmt_readdata;    //                  .readdata             output wire
wire         reconfig_mgmt_waitrequest; //                  .waitrequest          output wire
wire         reconfig_mgmt_write;       //                  .write                input  wire
wire [31:0]  reconfig_mgmt_writedata;   //                  .writedata            input  wire
reg          mgmt_rst_reset;


reg  [3:0]   por_reg;
reg  [7:0]   reset_counter;

  // Reconfiguration
  //
  assign reconfig_mgmt_address   = 7'h0;    //     reconfig_mgmt.address              input  wire
  assign reconfig_mgmt_read      = 1'b0;    //                  .read                 input  wire
  assign reconfig_mgmt_write     = 1'b0;    //                  .write                input  wire
  assign reconfig_mgmt_writedata = 32'h0;   //                  .writedata            input  wire
  
    //reset Synchronizer
   always @(posedge reconfig_xcvr_clk or negedge npor) begin
      if (npor == 1'b0) begin
         por_r           <= 2'b11;
         //mgmt_rst_reset  <= 1'b1;
      end
      else begin
         por_r[0]       <= 1'b0;
         por_r[1]       <= por_r[0];
         //mgmt_rst_reset <= por_r[1];
      end
   end

	always @(posedge reconfig_xcvr_clk) begin
		por_reg[0] <= npor;
		por_reg[1] <= por_reg[0];
		por_reg[2] <= por_reg[1];
		por_reg[3] <= por_reg[2];
   end
	
	always @ (posedge reconfig_xcvr_clk) begin
		if (por_reg[3] == 1'b1 && por_reg[2] == 1'b0) begin
			// detect falling edge of npor, reset reconfig block
			reset_counter = 8'h00;
		end
		else if (reset_counter == 8'hFF) begin
			// done reset
			mgmt_rst_reset = 1'b0;
		end
		else begin
			// in reset
			mgmt_rst_reset = 1'b1;
			reset_counter = reset_counter+1;
		end
	end
	
	
	pcie_reconfig_SV pcie_reconfig_inst (
		.reconfig_busy             (reconfig_busy),             //      reconfig_busy.reconfig_busy
		.mgmt_clk_clk              (reconfig_xcvr_clk),         //       mgmt_clk_clk.clk
		.mgmt_rst_reset            (mgmt_rst_reset),            //     mgmt_rst_reset.reset
		.reconfig_mgmt_address     (reconfig_mgmt_address),     //      reconfig_mgmt.address
		.reconfig_mgmt_read        (reconfig_mgmt_read),        //                   .read
		.reconfig_mgmt_readdata    (reconfig_mgmt_readdata),    //                   .readdata
		.reconfig_mgmt_waitrequest (reconfig_mgmt_waitrequest), //                   .waitrequest
		.reconfig_mgmt_write       (reconfig_mgmt_write),       //                   .write
		.reconfig_mgmt_writedata   (reconfig_mgmt_writedata),   //                   .writedata
		.reconfig_to_xcvr          (reconfig_to_xcvr),          //   reconfig_to_xcvr.reconfig_to_xcvr
		.reconfig_from_xcvr        (reconfig_from_xcvr)         // reconfig_from_xcvr.reconfig_from_xcvr
	);

endmodule
