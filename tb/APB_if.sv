interface APB_if;
    bit [7:0] PADDR;
    bit [7:0] PWDATA;
    bit       PSEL;
    bit       PENABLE;
    bit       PWRITE;
    bit       clk;
    logic     reset_n;

    logic [7:0] PRDATA;
    logic       PREADY;
    logic       PSLVERR;
endinterface
