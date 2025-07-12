////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Environment class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent agt;
    fifo_scoreboard sb;
    fifo_coverage cov;

    function new(string name = "fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = fifo_agent::type_id::create("agt", this);
        sb = fifo_scoreboard::type_id::create("sb", this);
        cov = fifo_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction

endclass