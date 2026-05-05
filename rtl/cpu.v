module cpu (
    input clk,
    output reg we,
    output reg [31:0] addr,
    output reg [31:0] wdata,
    input [31:0] rdata
);

    reg [31:0] pc;
    reg [31:0] instr;
    reg [3:0] state;

    reg [31:0] regfile [0:3];

    integer i;

    initial begin
        pc = 0;
        state = 0;
        we = 0;
        addr = 0;
        wdata = 0;

        for (i = 0; i < 4; i = i + 1)
            regfile[i] = 0;
    end

    always @(posedge clk) begin
        case (state)

            // FETCH
            0: begin
                we <= 0;
                addr <= pc;
                state <= 1;
            end

            // WAIT
            1: state <= 2;

            // DECODE
            2: begin
                instr <= rdata;
                state <= 3;
            end

            // EXECUTE
            3: begin
                case (instr[31:24])

                    // LOAD IMM
                    8'd3: begin
                        regfile[instr[23:16]] <= instr[7:0];
                        state <= 4;
                    end

                    // ADD
                    8'd4: begin
                        regfile[instr[23:16]] <= 
                            regfile[instr[23:16]] + regfile[instr[15:8]];
                        state <= 4;
                    end

                    // OUT
                    8'd2: begin
                        addr <= 32'h10000000;
                        wdata <= regfile[instr[23:16]];
                        we <= 1;
                        state <= 5;
                    end

                    // JUMP
                    8'd5: begin
                        pc <= instr[7:0];
                        state <= 0;
                    end

                    // BNE
                    8'd6: begin
                        if (regfile[instr[23:16]] != regfile[instr[15:8]])
                            pc <= instr[7:0];
                        else
                            pc <= pc + 1;
                        state <= 0;
                    end

                    // LOAD
                    8'd8: begin
                        addr <= regfile[instr[15:8]];
                        state <= 6;
                    end

                    // HALT
                    8'd255: begin
                        $display("HALT encountered.");
                        $finish;
                    end

                    default: state <= 4;
                endcase
            end

            // WRITE HOLD
            5: begin
                we <= 0;
                state <= 4;
            end

            // LOAD COMPLETE
            6: begin
                regfile[instr[23:16]] <= rdata;
                state <= 4;
            end

            // NEXT
            4: begin
                pc <= pc + 1;
                state <= 0;
            end

        endcase
    end

endmodule
