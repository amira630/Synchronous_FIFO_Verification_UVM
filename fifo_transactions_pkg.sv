///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 04-07-2025
// Description: Package containing all necessary includes and imports for all classes for the FIFO verification environment
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package fifo_transactions_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import shared_pkg::*;
    
    // Includes:
    `include "fifo_config.svh"
    `include "fifo_seq_item.svh"

endpackage