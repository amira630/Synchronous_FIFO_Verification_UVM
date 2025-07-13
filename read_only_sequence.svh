//////////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Child sequence class to perform only read transactions.
//////////////////////////////////////////////////////////////////////////////////////

class read_only_sequence extends fifo_base_sequence;
    `uvm_object_utils(read_only_sequence);
    
    function new(string name = "read_only_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(), "Starting read only sequence", UVM_MEDIUM)
        
        read_only();

        `uvm_info(get_type_name(), "Completed read only sequence", UVM_MEDIUM)
    endtask
endclass //read_only_sequence extends superClass