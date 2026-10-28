module tb;
    import apb_tb_pkg::*;
    APB_if apb_if();

    scoreboard sb;
    generator grt;
    monitor mon;
    driver drv;

    mailbox #(APB_Transaction) mbx_gen_drv;
    mailbox #(APB_Transaction) mbx_gen_sb;
    mailbox #(APB_Transaction) mbx_mon_sb;

    APB dut (
        .clk     (apb_if.clk),
        .reset_n (apb_if.reset_n),
        .PADDR   (apb_if.PADDR),
        .PWDATA  (apb_if.PWDATA),
        .PSEL    (apb_if.PSEL),
        .PENABLE (apb_if.PENABLE),
        .PWRITE  (apb_if.PWRITE),
        .PRDATA  (apb_if.PRDATA),
        .PREADY  (apb_if.PREADY),
        .PSLVERR (apb_if.PSLVERR)
    );

    initial begin
        apb_if.clk = 0;
        forever #20 apb_if.clk = ~apb_if.clk;
    end

    initial begin
        apb_if.reset_n = 1'b0;
        #45 apb_if.reset_n = 1'b1;
    end

    initial begin
        mbx_gen_drv = new();
        mbx_gen_sb  = new();
        mbx_mon_sb  = new();

        grt = new(mbx_gen_drv, mbx_gen_sb);
        drv = new(apb_if, mbx_gen_drv);
        mon = new(apb_if, mbx_mon_sb);
        sb  = new(mbx_gen_sb, mbx_mon_sb);

        fork
            grt.gen();
            drv.drive();
            mon.monitor_data();
            sb.scoreboard_data();
        join

        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
endmodule
