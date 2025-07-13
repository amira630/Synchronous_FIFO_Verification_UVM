/////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 04-07-2025
// Description: Class containing all assertions for the DUT.
/////////////////////////////////////////////////////////////////

// Any further package imports:
import shared_pkg::*;

module fifo_sva (fifo_if.DUT fifoif);

    logic clk, rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    logic [FIFO_WIDTH-1:0] data_out;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    reg [max_fifo_addr:0] count;

    // Interface signals
    assign clk = fifoif.clk;
    assign rst_n = fifoif.rst_n;
    assign wr_en = fifoif.wr_en;
    assign rd_en = fifoif.rd_en;

    assign data_out = fifoif.data_out;
    assign wr_ack = fifoif.wr_ack;
    assign overflow = fifoif.overflow;
    assign full = fifoif.full;
    assign empty = fifoif.empty;
    assign almostfull= fifoif.almostfull;
    assign almostempty = fifoif.almostempty;
    assign underflow = fifoif.underflow;

    assign count = FIFO.count;

	// Assertions and coverage for FIFO behavior
	logic rst_deasserted;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			rst_deasserted <= 1'b0;
		else
			rst_deasserted <= 1'b1;
	end

	always @(posedge clk) begin
		if (!rst_deasserted) begin
			assert (data_out == 0 && empty && !almostfull && !almostempty && !underflow && !overflow && !full && !wr_ack && count == 0)
				else $error("Reset values incorrect at time %0t", $time);
		end
	end

	property overflow_prop;
		@(posedge clk) disable iff (~rst_n) (wr_en && full) |=> overflow ;
	endproperty

	property underflow_prop;
		@(posedge clk) disable iff (~rst_n) (rd_en && empty) |=> underflow ;
	endproperty

	property wr_ack_prop;
		@(posedge clk) disable iff (~rst_n) (wr_en && count < FIFO_DEPTH) |=> wr_ack ;
	endproperty

	property full_prop;
		@(posedge clk) disable iff (~rst_n) (count == FIFO_DEPTH) |-> full;
	endproperty

	property empty_prop;
		@(posedge clk) disable iff (~rst_n) (count == 0) |-> empty;
	endproperty

	property almostfull_prop;
		@(posedge clk) disable iff (~rst_n) (count == FIFO_DEPTH-1) |-> almostfull;
	endproperty

	property almostempty_prop;
		@(posedge clk) disable iff (~rst_n) (count == 1) |-> almostempty;
	endproperty

	property count_wr_prop;
		@(posedge clk) disable iff (~rst_n) ((wr_en && !full && !rd_en) || (wr_en && rd_en && empty)) |=> (count == $past(count) + 1);
	endproperty

	property count_rd_prop;
		@(posedge clk) disable iff (~rst_n) ((rd_en && !empty && !wr_en) || (wr_en && rd_en && full)) |=> (count == $past(count) - 1);
	endproperty	
	
	assert property (overflow_prop) else $error("Overflow occurred when FIFO is full");
	assert property (underflow_prop) else $error("Underflow occurred when FIFO is empty");
	assert property (wr_ack_prop) else $error("Write acknowledge not asserted when FIFO is not full");
	assert property (full_prop) else $error("FIFO not full when count is equal to FIFO_DEPTH");
	assert property (empty_prop) else $error("FIFO not empty when count is zero");
	assert property (almostfull_prop) else $error("FIFO not almost full when count is equal to FIFO_DEPTH-1");
	assert property (almostempty_prop) else $error("FIFO not almost empty when count is equal to 1");
	assert property (count_wr_prop) else $error("Count not updated correctly during write operation");
	assert property (count_rd_prop) else $error("Count not updated correctly during read operation");

	cover property (overflow_prop);
	cover property (underflow_prop);
	cover property (wr_ack_prop);
	cover property (full_prop);
	cover property (empty_prop);
	cover property (almostfull_prop);
	cover property (almostempty_prop);
	cover property (count_wr_prop);
	cover property (count_rd_prop);
endmodule