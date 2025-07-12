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

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        //create the covergroups
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
        end
    endtask

endclass