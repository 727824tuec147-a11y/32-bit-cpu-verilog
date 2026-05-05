module ram (
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);

    reg [31:0] mem [0:255];
    wire [7:0] index = addr[9:2];

    initial begin
        // Program: print 'I'
        mem[0] = {8'd3, 8'd1, 8'd0, 8'd72}; // 'H'
        mem[1] = {8'd3, 8'd2, 8'd0, 8'd1};  // +1
        mem[2] = {8'd4, 8'd1, 8'd2, 8'd0};  // 'I'
        mem[3] = {8'd2, 8'd1, 8'd0, 8'd0};  // OUT
        mem[4] = {8'd255, 24'd0};           // HALT
    end

    always @(posedge clk) begin
        if (we)
            mem[index] <= wdata;

        rdata <= mem[index];
    end

endmodule
