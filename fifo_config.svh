////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Configuration class for creating config objects.
////////////////////////////////////////////////////////////////////////////////

class fifo_config extends uvm_object;
    `uvm_object_utils(fifo_config)

    virtual fifo_if fifo_vif;

    function new(string name = "fifo_config");
        super.new(name);
    endfunction
endclass