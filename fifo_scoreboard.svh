////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Scoreboard class for a UVM verification scoreboardironment.
////////////////////////////////////////////////////////////////////////////////

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_export #(fifo_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;

    fifo_seq_item seq_item_sb;

    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    logic [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];
    logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    logic [max_fifo_addr:0] count;

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item_sb = fifo_seq_item::type_id::create("seq_item_sb");
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Entered scoreboard run_phase", UVM_MEDIUM);
        forever begin
            sb_fifo.get(seq_item_sb);
            // call ref model
            fifo_reference_model(seq_item_sb);
            // compare
            `uvm_info(get_type_name(), $sformatf("Got item from FIFO: data_out=%0h", seq_item_sb.data_out), UVM_MEDIUM);
            if (seq_item_sb.data_out !== data_out_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Data mismatch: Expected = %0h, Actual = %0h", data_out_ref, seq_item_sb.data_out));
            end else begin
                correct_count++;
            end
            if (seq_item_sb.wr_ack !== wr_ack_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Write acknowledgment mismatch: Expected = %0b, Actual = %0b", wr_ack_ref, seq_item_sb.wr_ack));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.overflow !== overflow_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Overflow mismatch: Expected = %0b, Actual = %0b", overflow_ref, seq_item_sb.overflow));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.full !== full_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Full status mismatch: Expected = %0b, Actual = %0b", full_ref, seq_item_sb.full));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.empty !== empty_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Empty status mismatch: Expected = %0b, Actual = %0b", empty_ref, seq_item_sb.empty));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.almostfull !== almostfull_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Almost full status mismatch: Expected = %0b, Actual = %0b", almostfull_ref, seq_item_sb.almostfull));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.almostempty !== almostempty_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Almost empty status mismatch: Expected = %0b, Actual = %0b", almostempty_ref, seq_item_sb.almostempty));
            end
            else begin
                correct_count++;
            end

            if (seq_item_sb.underflow !== underflow_ref) begin
                error_count++;
                `uvm_error(get_type_name(), $sformatf("Underflow status mismatch: Expected = %0b, Actual = %0b", underflow_ref, seq_item_sb.underflow));
            end
            else begin
                correct_count++;
            end
        end
    endtask

    // add ref model task
    task fifo_reference_model(fifo_seq_item seq_item_chk);
        // Reference model logic to generate expected values
        if (!seq_item_chk.rst_n) begin
            data_out_ref = '0;
            count = '0;
            wr_ptr = '0;
            rd_ptr = '0;
            wr_ack_ref = 1'b0;
            overflow_ref = 1'b0;
            full_ref = 1'b0;
            empty_ref = 1'b1;
            almostfull_ref = 1'b0;
            almostempty_ref = 1'b0;
            underflow_ref = seq_item_chk.rd_en ? 1'b1 : 1'b0;
        end
        else begin 
            fork
                begin
                    if (seq_item_chk.wr_en && count < FIFO_DEPTH) begin
                        mem_ref[wr_ptr] = seq_item_chk.data_in;
                        wr_ptr++;
                        wr_ack_ref = 1'b1;
                    end
                    else begin
                        wr_ack_ref = 1'b0;
                    end
                end
                begin
                    if (seq_item_chk.rd_en && count > 0) begin
                        data_out_ref = mem_ref[rd_ptr];
                        rd_ptr++;
                        empty_ref = (count == 0) ? 1'b1 : 1'b0;
                    end
                end
            join
            if ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) begin 
                if (empty_ref)
                    count++;
                else if	(full_ref)
                    count--;
            end
            else if	( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b10) && !full_ref) 
                count++;
            else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b01) && !empty_ref)
                count--;
            full_ref = (count == FIFO_DEPTH)? 1 : 0;     
            empty_ref = (count == 0)? 1 : 0;
            almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0;         
            almostempty_ref = (count == 1)? 1 : 0;    
            underflow_ref = (empty_ref)? 1 : 0; 
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total successful transactions: %0d.", correct_count), UVM_MEDIUM);
        `uvm_info("report_phase", $sformatf("Total failed transactions: %0d.", error_count), UVM_MEDIUM);
    endfunction
endclass