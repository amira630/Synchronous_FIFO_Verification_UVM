/////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Base sequence class for a UVM verification environment, contains all sequences.
////////////////////////////////////////////////////////////////////////////////////////////////

class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_base_sequence)

    fifo_seq_item seq_item;
    
    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction //new()

    ///////////////////////////////// Write Only Sequence //////////////////////////////////

    task write_only();
        `uvm_info(get_type_name(), "start write only task", UVM_MEDIUM)
        if(seq_item == null) begin
            seq_item = fifo_seq_item::type_id::create("seq_item");
        end

        seq_item.constraint_mode(0);
        seq_item.write_only.constraint_mode(1);

        repeat (25) begin
            start_item(seq_item);
                assert(seq_item.randomize());
            finish_item(seq_item);
        end
        `uvm_info(get_type_name(), "Completed write only task", UVM_MEDIUM)
    endtask

    ///////////////////////////////// Read Only Sequence //////////////////////////////////

    task read_only();
        `uvm_info(get_type_name(), "start read only task", UVM_MEDIUM)
        if(seq_item == null) begin
            seq_item = fifo_seq_item::type_id::create("seq_item");
        end

        seq_item.constraint_mode(0);
        seq_item.read_only.constraint_mode(1);
        seq_item.data_in.rand_mode(0);  

        repeat (20) begin
            start_item(seq_item);
                assert(seq_item.randomize());
            finish_item(seq_item);
        end

        `uvm_info(get_type_name(), "Completed read only task", UVM_MEDIUM)
    endtask

    ///////////////////////////////// Write and Read Sequence //////////////////////////////////

    task write_read_only();
        `uvm_info(get_type_name(), "start read only task", UVM_MEDIUM)
        if(seq_item == null) begin
            seq_item = fifo_seq_item::type_id::create("seq_item");
        end

        seq_item.constraint_mode(1);
        seq_item.data_in.rand_mode(1);   
        seq_item.read_only.constraint_mode(0);
        seq_item.write_only.constraint_mode(0);

        repeat (100) begin
            start_item(seq_item);
                assert(seq_item.randomize());
            finish_item(seq_item);
        end

        `uvm_info(get_type_name(), "Completed write + read task", UVM_MEDIUM)
    endtask 

endclass