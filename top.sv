////////////////////////////////////////////////////////////////////////////////
// Author: Amira Atef
// Course: Digital Verification using SV & UVM
// Date: 12-07-2025
// Description: Top-level module for FIFO Design Verification
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

// Standard UVM import & include:
import uvm_pkg::*;
`include "uvm_macros.svh"

// Any further package imports:
import fifo_test_pkg::*;
import shared_pkg::*;

module top();

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    bit clk;

    initial begin

        // Start the clock
        forever
            #5 clk = ~clk; // Clock period of 10 time units
    end

    fifo_if #(.FIFO_WIDTH(FIFO_WIDTH)) fifoif (clk);

    FIFO #(.FIFO_WIDTH(FIFO_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) DUT (fifo_if);

    FIFO SVA (fifoif);
    bind FIFO DUT SVA (fifoif);

    initial begin
        uvm_config_db #(virtual fifo_if)::set(null, "uvm_test_top", "FIFO_IF", fifoif);
        run_test("fifo_test");
    end
endmodule