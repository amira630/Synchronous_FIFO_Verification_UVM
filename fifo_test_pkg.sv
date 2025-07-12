package fifo_test_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import fifo_transactions_pkg::*;
    import fifo_env_pkg::*;

    // Includes:
    `include "fifo_base_sequence.svh"
    // to include child seqs later
    `include "fifo_test.svh"
    
endpackage