////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Test class acting as a testbench.
////////////////////////////////////////////////////////////////////////////////

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_config fifo_cfg;

    // virtual fifo_if fifo_vif;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        fifo_cfg = fifo_config::type_id::create("fifo_cfg", this);
        //create the sequences

        if (!uvm_config_db #(virtual fifo_if)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif))
            `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the FIFO from the uvm_config_db.");
        
        uvm_config_db #(fifo_config)::set(this, "*", "CFG", fifo_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        //sequences here
        phase.drop_objection(this);
    endtask
endclass //className extends superClass