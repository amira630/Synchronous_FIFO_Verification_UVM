////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Agent class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    uvm_sequencer #(fifo_seq_item) sqr;
    fifo_driver drv;
    fifo_monitor mon;
    fifo_config fifo_cfg;

    uvm_analysis_port #(fifo_seq_item) agt_ap;

    function new(string name = "fifo_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(fifo_config)::get(this, "", "CFG", fifo_cfg))
            `uvm_fatal("build_phase", "Agent - Unable to get the configuration object.");
        
        sqr = uvm_sequencer #(fifo_seq_item)::type_id::create("sqr", this);
        drv = fifo_driver::type_id::create("drv", this);
        mon = fifo_monitor::type_id::create("mon", this);

        agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        drv.fifo_vif = fifo_cfg.fifo_vif;
        mon.fifo_vif = fifo_cfg.fifo_vif;

        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_ap.connect(agt_ap);
    endfunction
    
endclass