////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Coverage Collector class for a UVM verification coverageironment.
////////////////////////////////////////////////////////////////////////////////

class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    uvm_analysis_export #(fifo_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;

    fifo_seq_item seq_item_cov;

    // Covergroups
    covergroup FIFO_cvr_grp;
        // Coverpoints for FIFO transaction signals
        rst_n_c:        coverpoint F_cvg_txn.rst_n;
        wr_en_c:        coverpoint F_cvg_txn.wr_en;
        rd_en_c:        coverpoint F_cvg_txn.rd_en;
        // data_in_c:      coverpoint F_cvg_txn.data_in {option.cross_auto_bin_max = 0;};
        // data_out_c:     coverpoint F_cvg_txn.data_out{option.cross_auto_bin_max = 0;};
        wr_ack_c:       coverpoint F_cvg_txn.wr_ack;
        overflow_c:     coverpoint F_cvg_txn.overflow;
        full_c:         coverpoint F_cvg_txn.full;
        empty_c:        coverpoint F_cvg_txn.empty;
        almostfull_c:   coverpoint F_cvg_txn.almostfull;
        almostempty_c:  coverpoint F_cvg_txn.almostempty;
        underflow_c:    coverpoint F_cvg_txn.underflow;

        // Cross coverage for write and read enable signals

        wr_ack_cross: cross wr_en_c, rd_en_c, wr_ack_c {
            ignore_bins read_wr_ack = binsof(wr_en_c) intersect {0} && binsof(rd_en_c) intersect {1} && binsof(wr_ack_c) intersect {1};
            ignore_bins write_read_wr_ack = binsof(wr_en_c) intersect {0} && binsof(wr_ack_c) intersect {1};
        }

        overflow_cross: cross wr_en_c, rd_en_c, overflow_c {
            ignore_bins write_overflow = binsof(wr_en_c) intersect {0} && binsof(overflow_c) intersect {1};
        }

        full_cross: cross wr_en_c, rd_en_c, full_c {
            ignore_bins write_full = binsof(wr_en_c) intersect {0} && binsof(full_c) intersect {1};
            ignore_bins read_full = binsof(rd_en_c) intersect {1} && binsof(full_c) intersect {1};
        }
        
        empty_cross: cross wr_en_c, rd_en_c, empty_c {
            ignore_bins read_empty = binsof(rd_en_c) intersect {0} && binsof(empty_c) intersect {1};
        }

        almostfull_cross: cross wr_en_c, rd_en_c, almostfull_c {
            ignore_bins read_write_almostfull = binsof(wr_en_c) intersect {0} && binsof(rd_en_c) intersect {1} && binsof(almostfull_c) intersect {1};
            ignore_bins write_almostfull = binsof(wr_en_c) intersect {0} && binsof(almostfull_c) intersect {1};
        }   

        almostempty_cross: cross wr_en_c, rd_en_c, almostempty_c {
            ignore_bins read_almostempty = binsof(rd_en_c) intersect {0} && binsof(almostempty_c) intersect {1};
            ignore_bins write_read_almostempty = binsof(rd_en_c) intersect {0} && binsof(wr_en_c) intersect {1} && binsof(almostempty_c) intersect {1};
        }

        underflow_cross: cross wr_en_c, rd_en_c, underflow_c {
            ignore_bins read_underflow = binsof(rd_en_c) intersect {0} && binsof(underflow_c) intersect {1};
            ignore_bins write_underflow = binsof(wr_en_c) intersect {1} && binsof(underflow_c) intersect {1};
        }
    endgroup : FIFO_cvr_grp

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        //create the covergroups
        FIFO_cvr_grp = new();
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            cov_fifo.get(seq_item_cov);
            // Covergroups sample() method calls
            FIFO_cvr_grp.sample();
        end
    endtask

endclass