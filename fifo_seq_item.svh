////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Sequence Item class for a UVM verification environment.
////////////////////////////////////////////////////////////////////////////////

class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    // FIFO transaction properties
    rand logic rst_n;
    rand logic wr_en;
    rand logic rd_en;
    randc logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    int WR_EN_ON_DISTANCE = 70; // Distance between write enable signals
    int RD_EN_ON_DISTANCE = 30; // Distance between read enable signals
    
    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction //new()


    function string convert2string();
        return $sformatf("%s reset = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0h%0h, data_out = 0h%0h, wr_ack = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b.",super.convert2string, rst_n, wr_en, rd_en, data_in, data_out, wr_ack, full, empty, almostfull, almostempty, underflow);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("reset = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_in = 0h%0h.", rst_n, wr_en, rd_en, data_in);
    endfunction

    // Constraint blocks
    constraint c_rst_n { 
        rst_n dist {1'b1 := 90, 1'b0 := 10}; // 90% chance of being 1, 10% chance of being 0
    } // Reset is active low

    constraint c_wr_en {
        wr_en dist { 1'b0 := (100 - WR_EN_ON_DISTANCE), 1'b1 := WR_EN_ON_DISTANCE}; // Write enable signal
    }       

    constraint c_rd_en {
        rd_en dist { 1'b0 := (100 - RD_EN_ON_DISTANCE), 1'b1 := RD_EN_ON_DISTANCE}; // Read enable signal
    }

    // Additional constraint block for write operation only
    constraint write_only { 
        rst_n == 1;  wr_en == 1;  rd_en == 0; 
    } 

    // Additional constraint block for read operation only
    constraint read_only { 
        rst_n == 1;  wr_en == 0;  rd_en == 1; 
    } 
    
endclass