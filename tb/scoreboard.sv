class scoreboard;
    //Reference model
    bit [7:0] expected_REG0 = 0;
    bit [7:0] expected_REG1 = 0;
    bit [7:0] expected_REG2 = 0;
    bit [7:0] expected_REG3 = 0;

    //Estado de la transaccion actual
    bit detected_error;
    bit transaction_pass;
    bit [7:0] expected_data;

    APB_Transaction tr_actual;
    APB_Transaction tr_expected;

    mailbox #(APB_Transaction) mbx_gen_sb;
    mailbox #(APB_Transaction) mbx_mon_sb;

    function new(
        mailbox #(APB_Transaction) mbx_gen_sb,
        mailbox #(APB_Transaction) mbx_mon_sb
    );
        this.mbx_gen_sb = mbx_gen_sb;
        this.mbx_mon_sb = mbx_mon_sb;
    endfunction

    //Actualizar reference model y calcular lo esperado
    task update_reference_model();
        detected_error = 0;
        expected_data = 0;

        if (tr_expected.PWRITE) begin
            case (tr_expected.PADDR)
                8'h00: expected_REG0 = tr_expected.PWDATA;
                8'h04: expected_REG1 = tr_expected.PWDATA;
                8'h08: expected_REG2 = tr_expected.PWDATA;
                8'h0C: expected_REG3 = tr_expected.PWDATA;

                default: detected_error = 1;
            endcase
        end
        else begin
            case (tr_expected.PADDR)
                8'h00: expected_data = expected_REG0;
                8'h04: expected_data = expected_REG1;
                8'h08: expected_data = expected_REG2;
                8'h0C: expected_data = expected_REG3;

                default: begin
                    expected_data = 8'h00;
                    detected_error = 1;
                end
            endcase
        end
    endtask

    //Comprobar la transaccion
    task check_transaction(input int transaction_num);
        //Comprobar la direccion esperada
        if (tr_actual.PADDR !== tr_expected.PADDR) begin
            transaction_pass = 0;
            $display("ERROR: Direccion incorrecta");
            $display("Expected: %0h | Actual: %0h", tr_expected.PADDR, tr_actual.PADDR);

        end

        //Comprobar la operacion
        if (tr_actual.PWRITE !== tr_expected.PWRITE) begin
            transaction_pass = 0;
            $display("ERROR: PWRITE incorrecto");
        end

        //Comprobar dato de escritura
        if (tr_expected.PWRITE) begin
            if (tr_actual.PWDATA !== tr_expected.PWDATA) begin
                transaction_pass = 0;
                $display("ERROR: PWDATA incorrecto");
            end
        end
        else begin
            //Comprobar dato de lectura
            if (tr_actual.PRDATA !== expected_data) begin
                transaction_pass = 0;
                $display("ERROR: PRDATA incorrecto");
                $display("Expected: %0h | Actual: %0h", expected_data, tr_actual.PRDATA);
            end
        end

        //Comprobar PSLVERR
        if (tr_actual.PSLVERR !== detected_error) begin
            transaction_pass = 0;
            $display("ERROR: PSLVERR no coincide con lo esperado");
            $display("Expected: %0b | Actual: %0b", detected_error, tr_actual.PSLVERR);
        end

        //Comprobar PREADY
        if (tr_actual.PREADY !== 1'b1) begin
            transaction_pass = 0;
            $display("ERROR: PREADY no esta activo durante ACCESS");
        end
    endtask

    //Reportar resultado
    task report_transaction(input int transaction_num);
        $display("");
        $display("[Transaction %0d] %s", transaction_num, tr_expected.PWRITE ? "WRITE" : "READ");
        $display("Address        : %0h", tr_expected.PADDR);

        if (tr_expected.PWRITE)
            $display("PWDATA         : %0h", tr_expected.PWDATA);
        else
            $display("Expected PRDATA: %0h", expected_data);

        case ({detected_error, tr_actual.PSLVERR})
            2'b00: $display("PSLVERR check   : PASS (sin error esperado)");
            2'b01: $display("PSLVERR check   : FAIL (error inesperado)");
            2'b10: $display("PSLVERR check   : FAIL (no reporto el error)");
            2'b11: $display("PSLVERR check   : PASS (error esperado reportado)");
        endcase

        if (transaction_pass)
            $display("RESULT          : PASS");
        else
            $display("RESULT          : FAIL");
    endtask

    //Task principal
    task scoreboard_data();
        $display("");
        $display("==================================================");
        $display("                 SCOREBOARD");
        $display("==================================================");

        for (int i = 0; i < NUM_TRANSACTIONS; i++) begin
            //Reiniciar el resultado
            transaction_pass = 1;

            mbx_gen_sb.get(tr_expected);
            mbx_mon_sb.get(tr_actual);

            update_reference_model();
            check_transaction(i + 1);
            report_transaction(i + 1);
        end
    endtask
endclass
