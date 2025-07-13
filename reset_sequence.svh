////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Child sequence class to reset the DUT.
////////////////////////////////////////////////////////////////////////////////

class reset_sequence extends fifo_base_sequence;
    `uvm_object_utils(reset_sequence);
    
    function new(string name = "reset_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(), "Starting reset sequence", UVM_MEDIUM)
        
        reset();

        `uvm_info(get_type_name(), "Completed reset sequence", UVM_MEDIUM)
    endtask
endclass //reset_sequence extends superClass