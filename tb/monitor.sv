class monitor;
    APB_Transaction tr;
    virtual APB_if vif;

    mailbox #(APB_Transaction) mbx_mon_sb;

    function new(
        virtual APB_if vif,
        mailbox #(APB_Transaction) mbx_mon_sb
    );

    this.vif = vif;
    this.mbx_mon_sb = mbx_mon_sb;
    endfunction

    task monitor_data();
        @(negedge vif.clk);
        for (int i = 0; i < NUM_TRANSACTIONS; i++) begin

            //Espera a haber un ACCESS y que PREADY ya sea 1
            wait(vif.PSEL && vif.PENABLE && vif.PREADY);
            @(posedge vif.clk);
            #1;

            tr = new();

            tr.PSLVERR = vif.PSLVERR;
            tr.PWDATA  = vif.PWDATA;
            tr.PWRITE  = vif.PWRITE;
            tr.PREADY  = vif.PREADY;
            tr.PRDATA  = vif.PRDATA;
            tr.PADDR   = vif.PADDR;

            mbx_mon_sb.put(tr);

            wait (!vif.PSEL || !vif.PENABLE);
        end
    endtask
endclass
