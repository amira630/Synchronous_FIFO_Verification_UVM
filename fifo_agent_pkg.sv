package fifo_agent_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import shared_pkg::*;
    import fifo_transactions_pkg::*;

    // Includes:
    `include "fifo_driver.svh"
    `include "fifo_monitor.svh"
    `include "fifo_agent.svh"

endpackage