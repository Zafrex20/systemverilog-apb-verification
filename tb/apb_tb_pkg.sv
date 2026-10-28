package apb_tb_pkg;
    localparam int NUM_TRANSACTIONS = 11;

    `include "apb_transaction.sv"
    `include "generator.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"
endpackage
