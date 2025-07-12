////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Sequence Item class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    // variables for randomization here
    
    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction //new()


    function string convert2string_stimulus();
        return $sformatf("",);
    endfunction

    // Constraint blocks
    
endclass