module APB(
    input  bit [7:0] PADDR,
    input  bit [7:0] PWDATA,
    input  bit       PSEL,
    input  bit       PENABLE,
    input  bit       PWRITE,
    input  bit       clk,
    input  logic     reset_n,

    output logic [7:0] PRDATA,
    output logic       PREADY,
    output logic       PSLVERR
);

    logic [7:0] REG0;
    logic [7:0] REG1;
    logic [7:0] REG2;
    logic [7:0] REG3;

    // PREADY
    always_comb begin
        PREADY = PSEL && PENABLE;
    end

    // PRDATA y PSLVERR
    always_comb begin
        PRDATA  = 8'h00;
        PSLVERR = 1'b0;

        // ACCESS
        if (PSEL && PENABLE) begin
            if (PWRITE) begin
                case (PADDR)
                    8'h00: PSLVERR = 1'b0;
                    8'h04: PSLVERR = 1'b0;
                    8'h08: PSLVERR = 1'b0;
                    8'h0C: PSLVERR = 1'b0;
                    default: PSLVERR = 1'b1;
                endcase
            end
            else begin
                case (PADDR)
                    8'h00: PRDATA = REG0;
                    8'h04: PRDATA = REG1;
                    8'h08: PRDATA = REG2;
                    8'h0C: PRDATA = REG3;
                    default: begin
                        PRDATA  = 8'h00;
                        PSLVERR = 1'b1;
                    end
                endcase
            end
        end
    end

    // WRITE
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            REG0 <= 8'h00;
            REG1 <= 8'h00;
            REG2 <= 8'h00;
            REG3 <= 8'h00;
        end
        else if (PSEL && PENABLE && PREADY && PWRITE && !PSLVERR) begin
            case (PADDR)
                8'h00: REG0 <= PWDATA;
                8'h04: REG1 <= PWDATA;
                8'h08: REG2 <= PWDATA;
                8'h0C: REG3 <= PWDATA;
            endcase
        end
    end
endmodule
