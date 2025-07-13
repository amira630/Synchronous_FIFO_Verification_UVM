//////////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Child sequence class to perform only write transactions.
//////////////////////////////////////////////////////////////////////////////////////

class write_only_sequence extends fifo_base_sequence;
    `uvm_object_utils(write_only_sequence);
    
    function new(string name = "write_only_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(), "Starting write only sequence", UVM_MEDIUM)
        
        write_only();

        `uvm_info(get_type_name(), "Completed write only sequence", UVM_MEDIUM)
    endtask
endclass //write_only_sequence extends superClass