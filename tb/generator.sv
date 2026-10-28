class generator;
    APB_Transaction tr;
    mailbox #(APB_Transaction) mbx_gen_drv;
    mailbox #(APB_Transaction) mbx_gen_sb;

    function new(
        mailbox #(APB_Transaction) mbx_gen_drv,
        mailbox #(APB_Transaction) mbx_gen_sb
    );
    this.mbx_gen_drv = mbx_gen_drv;
    this.mbx_gen_sb  = mbx_gen_sb;
    endfunction

    task write_tests();
        for (int i = 0; i < 4; i++) begin
            tr = new();

            if (!tr.randomize() with {
                PWRITE == 1;
                PADDR  == i * 4;
            }) begin
                $error("Write randomization failed");
                return;
            end

            mbx_gen_drv.put(tr.copy());
            mbx_gen_sb.put(tr.copy());
        end
    endtask

    task read_tests();
        for (int i = 0; i < 4; i++) begin
            tr = new();

            if(!tr.randomize() with {
                PWRITE == 0;
                PADDR  == i * 4;
            }) begin    
                $error("Read randomization failed");
                return;
            end

            mbx_gen_drv.put(tr.copy());
            mbx_gen_sb.put(tr.copy());
        end
    endtask

    task invalid_write_test();
        tr = new();

        if (!tr.randomize() with {
            PWRITE == 1;
            PADDR  == 8'h10;
        }) begin
            $error("Invalid write randomization failed");
            return;
        end

        mbx_gen_drv.put(tr.copy());
        mbx_gen_sb.put(tr.copy());
    endtask

    task invalid_read_test();
        tr = new();

        if (!tr.randomize() with {
            PWRITE == 0;
            PADDR  == 8'h10;
        }) begin
            $error("Invalid read randomization failed");
            return;
        end

        mbx_gen_drv.put(tr.copy());
        mbx_gen_sb.put(tr.copy());
    endtask

    task gen();
        invalid_write_test();
        write_tests();
        invalid_write_test();
        read_tests();
        invalid_read_test();
    endtask
endclass
