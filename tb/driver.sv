class driver;
    APB_Transaction tr;
    virtual APB_if vif;

    mailbox #(APB_Transaction) mbx_gen_drv;

    function new(
        virtual APB_if vif,
        mailbox #(APB_Transaction) mbx_gen_drv
    );

    this.vif = vif;
    this.mbx_gen_drv = mbx_gen_drv;
    endfunction

    task drive();
        @(negedge vif.clk);
        vif.PSEL    = 0;
        vif.PENABLE = 0;
        vif.PADDR   = 0;
        vif.PWDATA  = 0;
        vif.PWRITE  = 0;

        for (int i = 0; i < NUM_TRANSACTIONS; i++) begin
            mbx_gen_drv.get(tr);

            //SETUP
            @(negedge vif.clk);
            vif.PSEL   = 1;
            vif.PWRITE = tr.PWRITE;
            vif.PWDATA = tr.PWDATA;
            vif.PADDR  = tr.PADDR;

            //ACCESS
            @(negedge vif.clk);
            vif.PSEL    = 1;
            vif.PENABLE = 1;
            vif.PWRITE  = tr.PWRITE;
            vif.PWDATA  = tr.PWDATA;
            vif.PADDR   = tr.PADDR;

            wait(vif.PREADY);
            @(negedge vif.clk);
            vif.PSEL    = 0;
            vif.PENABLE = 0;
        end
    endtask
endclass
