package fifo_env_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import fifo_transactions_pkg::*;
    
    import fifo_agent_pkg::*;

    // Includes:
    `include "fifo_scoreboard.svh"
    `include "fifo_coverage.svh"
    `include "fifo_env.svh"
endpackage