////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Driver class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_driver extends uvm_driver;
    `uvm_component_utils(fifo_driver)

    virtual fifo_if fifo_vif;
    fifo_seq_item stim_seq_item;

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            stim_seq_item = fifo_seq_item::type_id::create("stim_seq_item", this);
            seq_item_port.get_next_item(stim_seq_item);
            //interface input signals
            @(negedge fifo_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
        end
    endtask

endclass