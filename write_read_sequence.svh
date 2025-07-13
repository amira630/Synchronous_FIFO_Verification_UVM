//////////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Child sequence class to perform a mix of write & read transactions.
//////////////////////////////////////////////////////////////////////////////////////

class write_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(write_read_sequence);
    
    function new(string name = "write_read_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(), "Starting write + read sequence", UVM_MEDIUM)
        
        write_read();

        `uvm_info(get_type_name(), "Completed write + read sequence", UVM_MEDIUM)
    endtask
endclass //write_read_sequence extends superClass