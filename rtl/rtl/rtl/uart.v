module uart (
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] wdata
);

    always @(posedge clk) begin
        if (we && addr == 32'h10000000) begin
            $write("%c", wdata[7:0]);
        end
    end

endmodule
