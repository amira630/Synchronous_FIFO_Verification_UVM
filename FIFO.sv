////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO #(parameter FIFO_WIDTH = 16, FIFO_DEPTH = 8) (fifo_if.DUT fifoif);

logic clk, rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
logic [FIFO_WIDTH-1:0] data_in;
logic [FIFO_WIDTH-1:0] data_out;

// Interface signals
assign clk = fifoif.clk;
assign rst_n = fifoif.rst_n;
assign wr_en = fifoif.wr_en;
assign rd_en = fifoif.rd_en;
assign data_in = fifoif.data_in;

assign fifoif.data_out = data_out;
assign fifoif.wr_ack = wr_ack;
assign fifoif.overflow = overflow;
assign fifoif.full = full;
assign fifoif.empty = empty;
assign fifoif.almostfull = almostfull;
assign fifoif.almostempty = almostempty;
assign fifoif.underflow = underflow;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0;   //wr_ack and overflow were not reset
		overflow <= 0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin 
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0;  //overflow should be zero if wr_en and !full
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en) begin // should be && not & for conditional coverage
			overflow <= 1;
		end
		else begin
			overflow <= 0;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		data_out <= 0;  //data_out was not reset
		underflow <= 0; // rst_n was not accounted for
	end
	else if (rd_en && count != 0) begin 
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 1'b0; 
	end
	else if (rd_en) begin
		underflow <= 1'b1;
	end
	else begin
		underflow <= 1'b0; 
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if ({wr_en, rd_en} == 2'b11) begin  //The possibility of rd & wr enable with either empty or full was not considered.
			if (empty)
				count <= count + 1;
			else if	(full)
				count <= count - 1;
		end
		else if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if (rd_en && !empty) // for conditional coverage 
			count <= count - 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0; // underflow was placed inside read always block
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // it was FIFO_DEPTH-2, almostfull means 1 element can be added
assign almostempty = (count == 1)? 1 : 0;

endmodule