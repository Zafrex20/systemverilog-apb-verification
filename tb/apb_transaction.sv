class APB_Transaction;
    rand bit [7:0] PADDR;
    rand bit [7:0] PWDATA;
    rand bit       PWRITE;

    logic    [7:0] PRDATA;
    logic          PSLVERR;
    logic          PREADY;

    bit            PENABLE;
    bit            PSEL;


    function APB_Transaction copy();
        copy = new();
        copy.PSLVERR = PSLVERR;
        copy.PENABLE = PENABLE;
        copy.PADDR   = PADDR;
        copy.PWDATA  = PWDATA;
        copy.PWRITE  = PWRITE;
        copy.PRDATA  = PRDATA;
        copy.PREADY  = PREADY;
        copy.PSEL    = PSEL;

    endfunction
endclass
