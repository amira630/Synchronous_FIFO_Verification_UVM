////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Sequencer class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_sequencer extends uvm_sequencer #(fifo_seq_item);
    `uvm_component_utils(fifo_sequencer)
    
    function new(string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

endclass