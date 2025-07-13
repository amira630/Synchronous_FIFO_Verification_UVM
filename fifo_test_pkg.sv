package fifo_test_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import shared_pkg::*;
    import fifo_transactions_pkg::*;

    import fifo_env_pkg::*;

    // Includes:
    `include "fifo_base_sequence.svh"
    `include "reset_sequence.svh"
    `include "write_only_sequence.svh"
    `include "read_only_sequence.svh"
    `include "write_read_sequence.svh"
    `include "fifo_test.svh"
    
endpackage