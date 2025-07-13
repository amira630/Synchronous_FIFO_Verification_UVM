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

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////// Sequences /////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    reset_sequence reset_seq;
    write_only_sequence wr_seq;
    read_only_sequence rd_seq;
    write_read_sequence wr_rd_seq;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        fifo_cfg = fifo_config::type_id::create("fifo_cfg", this);
        // Sequences creation
        reset_seq = reset_sequence::type_id::create("reset_seq", this);
        wr_seq = write_only_sequence::type_id::create("wr_seq", this);
        rd_seq = read_only_sequence::type_id::create("rd_seq", this);
        wr_rd_seq = write_read_sequence::type_id::create("wr_rd_seq", this);

        if (!uvm_config_db #(virtual fifo_if)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif))
            `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the FIFO from the uvm_config_db.");
        
        uvm_config_db #(fifo_config)::set(this, "*", "CFG", fifo_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        //sequences here

        `uvm_info("run_phase", "RESET stimulus generation started", UVM_LOW);
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "RESET generation ended", UVM_LOW);

        `uvm_info("run_phase", "WRITE ONLY stimulus generation started", UVM_LOW);
        wr_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "WRITE ONLY stimulus generation ended", UVM_LOW);

        `uvm_info("run_phase", "READ ONLY stimulus generation started", UVM_LOW);
        rd_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "READ ONLY stimulus generation ended", UVM_LOW);

        `uvm_info("run_phase", "WRITE + READ stimulus generation started", UVM_LOW);
        wr_rd_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "WRITE + READ stimulus generation ended", UVM_LOW);

        phase.drop_objection(this);
    endtask
endclass //className extends superClass