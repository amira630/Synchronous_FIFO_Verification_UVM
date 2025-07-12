////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Sequence Item class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_base_sequence)

    fifo_seq_item seq_item;
    
    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction //new()

    // Sequences here
    
endclass