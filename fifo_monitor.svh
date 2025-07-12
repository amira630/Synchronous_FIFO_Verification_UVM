////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Monitor class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if fifo_vif;
    fifo_seq_item rsp_seq_item;

    uvm_analysis_port #(fifo_seq_item) mon_ap;

    function new(string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            rsp_seq_item = fifo_seq_item::type_id::create("rsp_seq_item", this);
            @(negedge fifo_vif.clk);
            //interface input signals
            `uvm_info("run_phase", rsp_seq_item.convert2string_stimulus(), UVM_HIGH)
        end
    endtask

endclass